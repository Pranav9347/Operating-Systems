#include "user.h"
#include "../kernel/syscall.h"


// User-space wrapper for sys_sem_init system call
int sem_initialize(struct sem *s, int value) {
    return syscall(SYS_sem_init, s, value); // System call wrapper for sem_init
}

// User-space wrapper for sys_sem_up system call
void sem_up(struct sem *s) {
    syscall(SYS_sem_up, s); // System call wrapper for sem_up
}

// User-space wrapper for sys_sem_down system call
void sem_down(struct sem *s) {
    syscall(SYS_sem_down, s); // System call wrapper for sem_down
}
