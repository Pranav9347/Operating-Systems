// cusotm_wc.h
#ifndef CUSTOM_WC_H
#define CUSTOM_WC_H
#include <stdio.h>
#include <ctype.h>
// Function to count lines, words, and characters in a file
void custom_wc(char *filename) {
    FILE *file = fopen(filename, "r");
    if (!file) {
        perror("Failed to open file");
        return;
    }

    int c, in_word = 0, word_count = 0;
    int line_count = 0, char_count = 0;
    while ((c = fgetc(file)) != EOF) {
        if (isspace(c)) {
            in_word = 0;
        } else if (!in_word) {
            in_word = 1;
            word_count++;
        }
        if (c == '\n') {
            line_count++;
        }
        char_count++;
    }

    fclose(file);
    printf("Line Count: %d\tWord count: %d\tChar Count: %d\n", line_count, word_count, char_count);
}


#endif // WC_H

