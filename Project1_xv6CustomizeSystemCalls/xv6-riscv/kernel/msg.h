// msg.h
#ifndef MSG_H
#define MSG_H
#define MAX_MSG_SIZE 128

// Message structure
typedef struct msg {
    int sender_pid;           // Process ID of the sender
    int receiver_pid;         // Process ID of the receiver
    int type;                 // Type of the message
    char data[MAX_MSG_SIZE];  // Actual message data
} msg_t;

// Function prototypes
int sendmsg(int receiver_pid, const char* message, int type);
int recvmsg(char* buffer, int* type);

#endif // MSG_H
