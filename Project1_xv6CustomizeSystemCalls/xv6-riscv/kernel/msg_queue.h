#ifndef MSG_QUEUE_H
#define MSG_QUEUE_H

#include "proc.h"  // Include proc.h, where msg_queue and related functions are defined

// Function prototypes, in case they're not already in proc.h
int send_message(struct msg_queue *queue, struct msg *msg);
int receive_message(struct msg_queue *queue, struct msg *msg);

#endif // MSG_QUEUE_H
