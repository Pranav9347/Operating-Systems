#include "./kernel/types.h"
#include "user.h"
int main() {


    if(fork()==0)
    {
        printf("Childs => Parent's PID:");
        printf("%d\n", getppid());
        exit(1);
    }
    wait(0);
    printf("Parent's => PID:");
    printf("%d\n", getpid());
    exit(0);
}
