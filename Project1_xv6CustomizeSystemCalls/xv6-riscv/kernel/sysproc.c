#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "syscall.h"
#include "semaphore.h"

 

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
sys_getppid(void)
{
    struct proc *p = myproc();  // Get the current process
    if (p->parent)
        return p->parent->pid; // Return parent's PID
    return -1;                 // Return -1 if no parent exists (init process)
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

int sys_sem_init(void) {
    struct sem *s;
    uint64 addr;  // To store the user-space address
    int value = -1;  // Initialize to an invalid value

    // Retrieve the pointer argument (user-space address of semaphore struct)
    argaddr(0, &addr);  // Just call argaddr, no need to check return value here

    // Debug: Print user address
    printf("sys_sem_init: User address = 0x%lx\n", addr);

    // Ensure the address is valid
    if (addr == 0) {
        printf("sys_sem_init: Invalid address or out of range\n");
        return -1;  // Return error if the address is NULL or out of range
    }

    // Allocate memory for the semaphore structure in kernel space
    s = (struct sem *)kalloc();  // Allocating memory in kernel space
    if (s == 0) {
        printf("sys_sem_init: Memory allocation failed\n");
        return -1;  // Return error if memory allocation failed
    }

    // Debug: Check if copyin will work by printing the status of the memory page
    uint64 va0 = PGROUNDDOWN(addr);  // Align address to page boundary
    uint64 pa0 = walkaddr(myproc()->pagetable, va0);
    if (pa0 == 0) {
        printf("sys_sem_init: Invalid user-space address (physical address lookup failed)\n");
        kfree(s);  // Free allocated memory if copyin fails
        return -1;
    }

    // Copy data from user space to kernel space using copyin
    if (copyin(myproc()->pagetable, (char *)s, addr, sizeof(struct sem)) < 0) {
        printf("sys_sem_init: copyin failed\n");
        kfree(s);  // Free allocated memory if copyin fails
        return -1;  // Return error if copyin fails
    }

    // Fetch the semaphore value from user arguments (use argint without a return check)
    argint(1, &value);  // Just fetch the value, no need to check return value here

    // Debug: Print semaphore value
    printf("sys_sem_init: Semaphore value = %d\n", value);

    // Validate the semaphore value
    if (value < 0) {
        printf("sys_sem_init: Invalid semaphore value\n");
        kfree(s);  // Free memory if value is invalid
        return -1;  // Return error if value is invalid
    }

    // Initialize the semaphore with the provided value
    sem_initialize(s, value);
    printf("sys_sem_init: Semaphore initialized with value %d\n", value);

    // Copy the updated semaphore value back to user space
    if (copyout(myproc()->pagetable, addr, (char *)s, sizeof(struct sem)) < 0) {
        printf("sys_sem_init: copyout failed\n");
        kfree(s);  // Free memory if copyout fails
        return -1;  // Return error if copyout fails
    }

    return 0;  // Success
}

int sys_sem_up(void) {
    struct sem *s;  // Pointer to semaphore structure in kernel space
    uint64 addr;  // To store the user-space address
    uint64 va0, pa0;

    // Get the semaphore pointer from user space argument
    argaddr(0, &addr);

    // Debug: Print the user-space address
    printf("sys_sem_up: User address = 0x%lx\n", addr);

    // Ensure the address is valid and mapped in the page table
    va0 = PGROUNDDOWN(addr);  // Align the address to the page boundary
    pa0 = walkaddr(myproc()->pagetable, va0);
    if (pa0 == 0) {
        printf("sys_sem_up: Invalid or unmapped address\n");
        return -1;  // Return error if the address is invalid
    }

    // Allocate memory for the semaphore structure in kernel space
    s = (struct sem *)kalloc();
    if (s == 0) {
        printf("sys_sem_up: Memory allocation failed\n");
        return -1;  // Return error if memory allocation fails
    }

    // Copy the semaphore structure from user space to kernel space
    if (copyin(myproc()->pagetable, (char *)s, addr, sizeof(struct sem)) < 0) {
        printf("sys_sem_up: copyin failed\n");
        kfree(s);  // Free memory if copyin fails
        return -1;  // Return error if copyin fails
    }

    // Debug: Print semaphore value before incrementing (sem_up operation)
    printf("sys_sem_up: Semaphore value before incrementing = %d\n", s->value);

    // Perform the sem_up operation (increment the semaphore)
    sem_up(s);

    // Debug: Print semaphore value after incrementing
    printf("sys_sem_up: Semaphore value after incrementing = %d\n", s->value);

    // Copy the updated semaphore structure back to user space
    if (copyout(myproc()->pagetable, addr, (char *)s, sizeof(struct sem)) < 0) {
        printf("sys_sem_up: copyout failed\n");
        kfree(s);  // Free memory if copyout fails
        return -1;  // Return error if copyout fails
    }

    // Free allocated memory after use
    kfree(s);

    return 0;
}

int sys_sem_down(void) {
    struct sem *s;
    uint64 addr;  // To store the user-space address
    uint64 va0, pa0;

    // Get the semaphore address from user space
    argaddr(0, &addr);

    // Debug: Print user-space address
    printf("sys_sem_down: User address = 0x%lx\n", addr);

    // Ensure the address is valid by checking if it's in the user-space region
    va0 = PGROUNDDOWN(addr);  // Align address to page boundary
    pa0 = walkaddr(myproc()->pagetable, va0);  // Get the physical address

    if (pa0 == 0) {
        printf("sys_sem_down: Invalid or unmapped address\n");
        return -1;  // Return error if address is invalid or not mapped
    }

    // Allocate memory for the semaphore structure in kernel space
    s = (struct sem *)kalloc();
    if (s == 0) {
        printf("sys_sem_down: Memory allocation failed\n");
        return -1;  // Return error if memory allocation fails
    }

    // Copy the semaphore structure from user space to kernel space
    if (copyin(myproc()->pagetable, (char *)s, addr, sizeof(struct sem)) < 0) {
        printf("sys_sem_down: copyin failed\n");
        kfree(s);  // Free memory if copyin fails
        return -1;  // Return error if copyin fails
    }

    // Debug: Print semaphore value before decrementing
    printf("sys_sem_down: Semaphore value = %d\n", s->value);

    // Perform the sem_down operation (decrement the semaphore)
    sem_down(s);

    // Debug: Print semaphore value after decrementing
    printf("sys_sem_down: Semaphore value = %d\n", s->value);

    // Copy the updated semaphore structure back to user space
    if (copyout(myproc()->pagetable, addr, (char *)s, sizeof(struct sem)) < 0) {
        printf("sys_sem_down: copyout failed\n");
        kfree(s);  // Free memory if copyout fails
        return -1;  // Return error if copyout fails
    }

    kfree(s);  // Free allocated memory after use
    return 0;
}
