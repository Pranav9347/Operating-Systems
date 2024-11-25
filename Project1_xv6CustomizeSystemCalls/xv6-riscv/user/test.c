#include "./kernel/types.h"
#include "user.h"

// Declare the system call for process state
int getprocstate(void);  // We declared this in user.h and sys_getprocstate is implemented in the kernel.

int main(void) {
    int pid1, pid2;

    // Create first child process
    pid1 = fork();
    if (pid1 < 0) {
        printf("Fork failed!\n");
        exit(1);
    }
    
    if (pid1 == 0) {
        // Child process 1
        sleep(5);
        exit(1);
    }

    // Create second child process
    pid2 = fork();
    if (pid2 < 0) {
        printf("Fork failed!\n");
        exit(1);
    }
    
    if (pid2 == 0) {
        // Child process 2
        sleep(5);
        exit(1);
    }

    // Parent process
    
    getprocstate();  // This should print the states of child processes.

    // Wait for children to finish
    wait(0);
    wait(0);

    exit(1);  // Exit the parent process
}
