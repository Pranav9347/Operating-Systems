#include "user.h"

// Example user program that uses semaphores

int main() {
    struct sem mySem;  // Declare a semaphore
    int value = 3;     // Initial value of the semaphore (you can choose based on your needs)

    // Initialize the semaphore
    printf("initializing semaphore...\n");
    if (sem_initialize(&mySem, value) < 0) {
        printf("Semaphore initialization failed\n");
        exit(1);
    }
    printf("Semaphore initialized successfully!\nmySem->value=%d\n\n",mySem.value);
    while(1){
    printf("Locking...\n");
    sem_down(&mySem);  // Acquire the semaphore (this will block if value is <= 0)
    printf("\nCritical section entered\n");
    sleep(1);
    //sem_up(&mySem);  // Release the semaphore
    printf("\nCritical section exited\n");
    }
    exit(0);
}
