// customrm.h
#ifndef CUSTOM_RM_H
#define CUSTOM_RM_H
#include <stdio.h>
// Function to remove a file
void custom_rm(char *filename) {
    if (remove(filename) == 0) {
        printf("File %s deleted successfully.\n", filename);
    } else {
        perror("Failed to delete the file");
    }
}

#endif // RM_H

