#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "syscall.h"
#include "defs.h"

extern uint64 sys_send_message(int, int, char*);
extern uint64 sys_receive_message(int msg_type, char *received_msg);

// Fetch the uint64 at addr from the current process.
int
fetchaddr(uint64 addr, uint64 *ip)
{
  struct proc *p = myproc();
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    return -1;
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    return -1;
  return 0;
}

// Fetch the nul-terminated string at addr from the current process.
// Returns length of string, not including nul, or -1 for error.
int
fetchstr(uint64 addr, char *buf, int max)
{
  struct proc *p = myproc();
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    return -1;
  return strlen(buf);
}

uint64 sys_send_message_wrapper(void) {
    int pid, msg_type;
    char msg[128];

    // Fetch arguments
    argint(0, &pid);
    argint(1, &msg_type);
    argstr(2, msg, sizeof(msg));

    // Call the actual function
    return sys_send_message(pid, msg_type, msg);
}

uint64 sys_receive_message_wrapper(void) {
    int msg_type;
    char received_msg[128];

    // Fetch arguments
    argint(0, &msg_type);

    // Call the actual function
    return sys_receive_message(msg_type, received_msg);
}

static uint64
argraw(int n)
{
  struct proc *p = myproc();
  switch (n) {
  case 0:
    return p->trapframe->a0;
  case 1:
    return p->trapframe->a1;
  case 2:
    return p->trapframe->a2;
  case 3:
    return p->trapframe->a3;
  case 4:
    return p->trapframe->a4;
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
  *ip = argraw(n);
}

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
  *ip = argraw(n);
}

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
}

// Prototypes for the functions that handle system calls.
extern uint64 sys_fork(void);
extern uint64 sys_exit(void);
extern uint64 sys_wait(void);
extern uint64 sys_pipe(void);
extern uint64 sys_read(void);
extern uint64 sys_kill(void);
extern uint64 sys_exec(void);
extern uint64 sys_fstat(void);
extern uint64 sys_chdir(void);
extern uint64 sys_dup(void);
extern uint64 sys_getpid(void);
extern uint64 sys_sbrk(void);
extern uint64 sys_sleep(void);
extern uint64 sys_uptime(void);
extern uint64 sys_open(void);
extern uint64 sys_write(void);
extern uint64 sys_mknod(void);
extern uint64 sys_unlink(void);
extern uint64 sys_link(void);
extern uint64 sys_mkdir(void);
extern uint64 sys_close(void);

extern uint64 sys_getprocstate(void);
extern uint64 sys_getppid(void);
extern uint64 sys_sem_init(void);
extern uint64 sys_sem_up(void);
extern uint64 sys_sem_down(void);

// An array mapping syscall numbers from syscall.h
// to the function that handles the system call.
static uint64 (*syscalls[])(void) = {
[SYS_fork]    sys_fork,
[SYS_exit]    sys_exit,
[SYS_wait]    sys_wait,
[SYS_pipe]    sys_pipe,
[SYS_read]    sys_read,
[SYS_kill]    sys_kill,
[SYS_exec]    sys_exec,
[SYS_fstat]   sys_fstat,
[SYS_chdir]   sys_chdir,
[SYS_dup]     sys_dup,
[SYS_getpid]  sys_getpid,
[SYS_sbrk]    sys_sbrk,
[SYS_sleep]   sys_sleep,
[SYS_uptime]  sys_uptime,
[SYS_open]    sys_open,
[SYS_write]   sys_write,
[SYS_mknod]   sys_mknod,
[SYS_unlink]  sys_unlink,
[SYS_link]    sys_link,
[SYS_mkdir]   sys_mkdir,
[SYS_close]   sys_close,
[SYS_sys_send_message]     sys_send_message_wrapper,
[SYS_sys_receive_message]  sys_receive_message_wrapper,
[SYS_getprocstate]   sys_getprocstate,
[SYS_getppid] sys_getppid,
[SYS_sem_init] sys_sem_init,
[SYS_sem_up]  sys_sem_up,
[SYS_sem_down] sys_sem_down,
};





void
syscall(void)
{
  int num;
  struct proc *p = myproc();

  num = p->trapframe->a7;


  // Check if the syscall number is valid
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    // Handle sys_send_message
    if (num == SYS_sys_send_message) {
      int pid, msg_type;
      char msg[128];  // Static buffer for message content

      // Fetch arguments for sys_send_message
      argint(0, &pid);          // Process ID
      argint(1, &msg_type);     // Message type
      argstr(2, msg, 128);      // Message content

      // Call sys_send_message and store the result
      p->trapframe->a0 = sys_send_message(pid, msg_type, msg);
    } 
    // Handle sys_receive_message
    else if (num == SYS_sys_receive_message) {
      int msg_type;
      char received_msg[128];  // Static buffer for received message
      
      // Fetch arguments for sys_receive_message
      argint(0, &msg_type);     // Message type

      // Call sys_receive_message and store the result
      p->trapframe->a0 = sys_receive_message(msg_type, received_msg);
    } 
    // Handle other syscalls
    else {
      p->trapframe->a0 = syscalls[num]();
    }
  } else {
    // Handle invalid system call number
    printf("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    p->trapframe->a0 = -1;
  }
}
