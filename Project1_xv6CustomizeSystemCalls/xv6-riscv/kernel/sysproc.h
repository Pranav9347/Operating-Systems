// sysproc.h
#ifndef SYSPROC_H
#define SYSPROC_H

#include "types.h"

uint64 sys_send_message(int pid, int msg_type, char *message);
uint64 sys_receive_message(int msg_type, char *received_msg);

#endif
