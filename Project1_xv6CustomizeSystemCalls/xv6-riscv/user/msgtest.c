// #include "user.h"

// int main() {
//     int pid = 1;          // Example PID
//     int msg_type = 1;     // Example message type
//     char msg[128] = "Hello, World!";  // Example message content
//     char received_msg[128];
//     char *ptr = received_msg;
//     //printf("%p",msg);
//     if (sys_send_message(pid, msg_type, msg) < 0) {
//     printf("sys_send_message failed\n");
// }


// if (sys_receive_message(msg_type, ptr) < 0) {
//     printf("sys_receive_message failed\n");
// } else {
//     printf("Message received: %s\n", ptr);
//     //printf("%p",ptr);

// }
// /*Direct Memory Access: XV6 doesn't provide automatic mechanisms like "shared memory" or direct memory access between user-space and kernel-space, which makes passing pointers and having them point to the same location more complex*/

//     return 0;
// }

#include "user.h"

int main() {
    int msg_type = 1;       
    char msg[128] = "Hello from Parent!";  // Parent's message to child
    char received_msg[128];  // Buffer to store received messages

    int pid = fork();  // Create a child process

    if (pid < 0) {
        printf("Fork failed!\n");
        exit(1);
    } else if (pid == 0) {
        // Child process
      

        // Receive message from parent
        if (sys_receive_message(msg_type, received_msg) < 0) {
            printf("Child: sys_receive_message failed\n");
            exit(1);
        } else {
            printf("Child: Message received: %s\n", received_msg);
        }

        exit(0);
    } else {
        // Parent process
        

        // Send message to child
        if (sys_send_message(pid, msg_type, msg) < 0) {
            printf("Parent: sys_send_message failed\n");
            exit(1);
        }


        // Wait for child to finish
        wait(0);
    }

    return 0;
}
