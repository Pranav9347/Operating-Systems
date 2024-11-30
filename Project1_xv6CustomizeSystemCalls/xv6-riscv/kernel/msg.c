// msg.c
#include "msg.h"
#include "proc.h"
#include "syscall.h"


int sendmsg(int receiver_pid, const char* message, int type) {
    syscall(SYS_sendmsg, receiver_pid, message, type);
}

int recvmsg(char* buffer, int* type) {
    return syscall(SYS_recvmsg, buffer, type);
}
