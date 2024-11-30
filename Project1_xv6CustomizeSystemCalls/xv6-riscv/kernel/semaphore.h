#ifndef SEMAPHORE_H
#define SEMAPHORE_H

#include "spinlock.h"
struct sem {
    int value;        // Counter for available resources
    void *chan;       // Channel for sleeping processes
    struct spinlock lock; // Spinlock for mutual exclusion
};
void
sem_initialize(struct sem *s, int value) {
    s->value = value;
    s->chan = s; // Use the semaphore's address as the channel
    initlock(&s->lock, "semaphore");
}

void
sem_down(struct sem *s) {
    acquire(&s->lock);
    s->value--;
    if (s->value < 0) {
        sleep(s->chan, &s->lock); // Sleep until signaled
    }
    release(&s->lock);
}

void
sem_up(struct sem *s) {
    acquire(&s->lock);
    s->value++;
    if (s->value <= 0) {
        wakeup(s->chan); // Wake up one sleeping process
    }
    release(&s->lock);
}

#endif