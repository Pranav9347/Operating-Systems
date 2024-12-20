#ifndef USER_H
#define USER_H
#include "../kernel/types.h" 
#define SYS_send_message 22
#define SYS_receive_message 23





struct stat;
struct sem {
    int value;
    void *chan;
};

// system calls
int syscall(int num, ...);
int fork(void);
int exit(int) __attribute__((noreturn));
int wait(int*);
int pipe(int*);
int write(int, const void*, int);
int read(int, void*, int);
int close(int);
int kill(int);
int exec(const char*, char**);
int open(const char*, int);
int mknod(const char*, short, short);
int unlink(const char*);
int fstat(int fd, struct stat*);
int link(const char*, const char*);
int mkdir(const char*);
int chdir(const char*);
int dup(int);
int getpid(void);
char* sbrk(int);
int sleep(int);
int uptime(void);
int sys_send_message(int, int, char*);
int sys_receive_message(int, char*);
int getprocstate(void);
int getppid(void);
// Declaration of system calls for semaphores
int sem_initialize(struct sem *s, int value);
void sem_up(struct sem *s);
void sem_down(struct sem *s);

// ulib.c
int stat(const char*, struct stat*);
char* strcpy(char*, const char*);
void *memmove(void*, const void*, int);
char* strchr(const char*, char c);
int strcmp(const char*, const char*);
void fprintf(int, const char*, ...) __attribute__ ((format (printf, 2, 3)));
void printf(const char*, ...) __attribute__ ((format (printf, 1, 2)));
char* gets(char*, int max);
unsigned int strlen(const char*);
void* memset(void*, int, unsigned int);
int atoi(const char*);
int memcmp(const void *, const void *, unsigned int);
void *memcpy(void *, const void *, unsigned int);

// umalloc.c
void* malloc(unsigned int);
void free(void*);
uint strlen(const char*);
void* memset(void*, int, uint);
int atoi(const char*);
int memcmp(const void *, const void *, uint);
void *memcpy(void *, const void *, uint);

// umalloc.c
void* malloc(uint);
void free(void*);

#endif
