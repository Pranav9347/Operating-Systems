#ifndef CUSTOM_CAT_H
#define CUSTOM_CAT_H
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void display_file_content(const char *filename, int show_line_numbers) {
    FILE *file = fopen(filename, "r");
    if (!file) {
        perror("Error opening file");
        return;
    }

    char line[1024];
    int line_number = 1;
    while (fgets(line, sizeof(line), file)) {
        if (show_line_numbers) {
            printf("%d: %s", line_number++, line);
        } else {
            printf("%s", line);
        }
    }

    fclose(file);
}

int custom_cat(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s [-n] filename1 [filename2 ...]\n", argv[0]);
        return 1;
    }

    int show_line_numbers = 0;
    int start_index = 1;

    // Check if the first argument is the -n flag
    if (strcmp(argv[1], "-n") == 0) {
        show_line_numbers = 1;
        start_index = 2;  // Start with the next argument
    }

    // Ensure there is at least one file name provided
    if (start_index >= argc) {
        fprintf(stderr, "Error: No file specified\n");
        return 1;
    }

    // Process each file
    for (int i = start_index; i < argc; i++) {
        printf("==> %s <==\n", argv[i]);  // Display file name
        display_file_content(argv[i], show_line_numbers);
        if (i < argc - 1) {
            printf("\n");  // Separate output for multiple files
        }
    }

    return 0;
}
#endif
