#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "syscall.h"

 

int send_message(struct msg_queue *queue, struct msg *msg);
int receive_message(struct msg_queue *queue, struct msg *msg);


extern struct proc proc[NPROC];  // Assuming NPROC is the size of the process array
extern struct spinlock ptable_lock;


// Send a message to the queue of a specific process
uint64 sys_send_message(int pid, int msg_type, char *message) {
    struct proc *receiver = 0;
    struct msg msg;

    msg.msg_type = msg_type;
    safestrcpy(msg.content, message, MSG_SIZE);

    acquire(&ptable_lock);
    for (int i = 0; i < NPROC; i++) {
        if (proc[i].pid == pid) {
            receiver = &proc[i];
            break;
        }
    }
    release(&ptable_lock);

    if (receiver == 0) {
        printf("sys_send_message: Receiver PID %d not found\n", pid);
        return -1;
    }

    //printf("sys_send_message: Sending to PID %d, Type %d, Message: %s\n",pid, msg_type, message);

    return send_message(&receiver->msg_queue, &msg);
}

// uint64 sys_receive_message(int msg_type, char *received_msg) {
//     struct proc *p = myproc();  // Get the current process
//     struct msg msg;

//     // Try to receive a message from the queue
//     if (receive_message(&p->msg_queue, &msg) == 0) {
//         // Check if the message type matches
//         if (msg.msg_type == msg_type) {
//             // Safely copy the message content to the received buffer (dereference the pointer)
//             //memcpy(received_msg, msg.content, MSG_SIZE);
//             safestrcpy(received_msg, msg.content, MSG_SIZE);  // Dereferencing the pointer to access the buffer
//             //printf("%p",received_msg);
            

//             // Print the received message for debugging
//             printf("sys_receive_message: Received Type %d, Message: %s\n", msg.msg_type, received_msg);
//             return 0;  // Success: message successfully received
//         } else {
//             // If type doesn't match, put the message back into the queue
//             printf("sys_receive_message: Type mismatch. Expected %d, got %d\n", msg_type, msg.msg_type);
//             send_message(&p->msg_queue, &msg);
//             return -1;  // Failure: type mismatch
//         }
//     }

//     // If no message is available
//     printf("sys_receive_message: No message available in the queue\n");
//     return -1;  // Failure: no message available
// }
uint64 sys_receive_message(int msg_type, char *received_msg) {
    struct proc *p = myproc();  // Get the current process
    struct msg msg;
    uint64 addr;  // To store the user-space address of the received message

    // Fetch the user-space address argument (to store received message)
    argaddr(1, &addr);  // This is the address where the message will be copied

    // Debug: Print the user-space address
    //printf("sys_receive_message: User address = 0x%lx\n", addr);

    // Ensure the address is valid
    if (addr == 0) {
        printf("sys_receive_message: Invalid address or out of range\n");
        return -1;  // Return error if the address is NULL or out of range
    }

    // Try to receive a message from the message queue
    if (receive_message(&p->msg_queue, &msg) == 0) {
        // Check if the message type matches
        if (msg.msg_type == msg_type) {
            // Debug: Print message details for verification
            //printf("sys_receive_message: Received Type %d, Message: %s\n", msg.msg_type, msg.content);

            // Now safely copy the message content to user space
            if (copyout(p->pagetable, addr, (char *)msg.content, MSG_SIZE) < 0) {
                printf("sys_receive_message: copyout failed\n");
                return -1;  // Failure: copyout failed
            }

            // Return success
            return 0;
        } else {
            // Type mismatch, put the message back into the queue
            printf("sys_receive_message: Type mismatch. Expected %d, got %d\n", msg_type, msg.msg_type);
            send_message(&p->msg_queue, &msg);  // Return the message to the queue
            return -1;  // Failure: type mismatch
        }
    }

    // If no message is available in the queue
    printf("sys_receive_message: No message available in the queue\n");
    return -1;  // Failure: no message available
}



uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  if(n < 0)
    n = 0;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
