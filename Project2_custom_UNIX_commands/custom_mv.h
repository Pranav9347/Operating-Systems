#ifndef CUSTOM_MV_H
#define CUSTOM_MV_H
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <sys/stat.h>
#include <unistd.h>

#define BUFFER_SIZE 8192

// void copy_files(char* src, char* dest): defined already in custom_cp.h file
// {
//     FILE* src_file = fopen(src, "r");
//     FILE* dest_file = fopen(dest, "w"); // creates if destination file is not present
//     if (!dest_file) {
//         printf("Invalid destination path!\n");
//         return;
//     }

//     size_t bytes_read = 0;
//     char buffer[BUFFER_SIZE]; // 8KB buffer (efficient to reduce system calls)
//     do {
//         bytes_read = fread(buffer, 1, BUFFER_SIZE, src_file); // reading byte-wise
//         fwrite(buffer, 1, bytes_read, dest_file);
//     } while (bytes_read > 0);

//     fclose(dest_file);
//     fclose(src_file);
// }

// Function to copy a directory recursively: defined already in custom_cp.h file
// void copy_directory(const char *src_dir, const char *dst_dir) {
//     struct dirent *entry;
//     DIR *src_d;
//     struct stat statbuf;
//     char src_path[1024], dst_path[1024];

//     // Open the source directory
//     src_d = opendir(src_dir);
//     if (!src_d) {
//         perror("Error opening source directory");
//         return;
//     }

//     // Check if the destination directory already exists
//     if (!(stat(dst_dir, &statbuf) == 0 && S_ISDIR(statbuf.st_mode))) {
//         // Create the destination directory if it does not exist
//         if (mkdir(dst_dir, 0755) == -1) {
//             perror("Error creating destination directory");
//             closedir(src_d);
//             return;
//         }
//     }

//     // Read the source directory and copy its contents
//     while ((entry = readdir(src_d)) != NULL) {
//         // Skip the '.' and '..' entries
//         if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) {
//             continue;
//         }

//         // Build the full path for source and destination
//         snprintf(src_path, sizeof(src_path), "%s/%s", src_dir, entry->d_name);
//         snprintf(dst_path, sizeof(dst_path), "%s/%s", dst_dir, entry->d_name);

//         // Get information about the current entry
//         if (stat(src_path, &statbuf) == -1) {
//             perror("Error reading file stats");
//             continue;
//         }

//         // If it's a directory, recursively copy it
//         if (S_ISDIR(statbuf.st_mode)) {
//             copy_directory(src_path, dst_path);
//         }
//         // If it's a file, copy the file
//         else if (S_ISREG(statbuf.st_mode)) {
//             copy_files(src_path, dst_path);
//         }
//     }

//     // Close the source directory
//     closedir(src_d);
// }

// Helper function to delete a directory recursively
int remove_dir(const char *dir_path) {
    struct dirent *entry;
    DIR *dir = opendir(dir_path);
    if (!dir) {
        perror("Error opening directory for removal");
        return -1;
    }

    while ((entry = readdir(dir)) != NULL) {
        char entry_path[1024];
        snprintf(entry_path, sizeof(entry_path), "%s/%s", dir_path, entry->d_name);

        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) {
            continue;
        }

        struct stat statbuf;
        if (stat(entry_path, &statbuf) == -1) {
            perror("Error reading entry stats for removal");
            continue;
        }

        if (S_ISDIR(statbuf.st_mode)) {
            remove_dir(entry_path); // recursively delete directories
        } else {
            remove(entry_path); // remove file
        }
    }

    closedir(dir);
    return rmdir(dir_path); // remove the empty directory
}

int custom_mv(int argc, char* argv[])
{
    // Receive minimum two args (and an optional flag field)
    if (argc < 3 || strcmp(argv[0], "custom_mv") != 0) {
        printf("Usage: custom_mv src dest\n");
        return 1;
    }

    char *src, *dest;
    src = (char*)malloc((strlen(argv[argc - 2]) + 1) * sizeof(char)); // second last arg is src
    strcpy(src, argv[argc - 2]);

    dest = (char*)malloc((strlen(argv[argc - 1]) + 1) * sizeof(char)); // last arg is dest
    strcpy(dest, argv[argc - 1]);

    // Check if the args are valid file/directory names:
    struct stat path_stat_src, path_stat_dest;
    if (stat(src, &path_stat_src) != 0) { // check if the src path exists
        printf("%s: No such file or directory\n", src);
        return 2;
    }

    stat(dest, &path_stat_dest); // get info about destination
    if (S_ISREG(path_stat_src.st_mode)) { // if src is a file
        if (S_ISDIR(path_stat_dest.st_mode)) { // if dest is a dir
            // Find the last occurrence of '/' in src to get the filename
            const char *src_filename = strrchr(src, '/');
            if (src_filename) {
                src_filename++; // Move past the '/'
            } else {
                src_filename = src; // If no '/' was found, src itself is the filename
            }

            // Ensure dest is large enough to hold the concatenated string
            strcat(dest, "/");
            strcat(dest, src_filename);
        }
        copy_files(src, dest); // file to file/folder copy
    }
    else if (S_ISDIR(path_stat_src.st_mode)) { // if src is a dir
        if (S_ISREG(path_stat_dest.st_mode)) { // if dest is a file, then error
            printf("Cannot move %s dir to %s file\n", src, dest);
            return 3;
        }
        
        // If dest is a valid directory, move the entire src directory to the destination
        if (S_ISDIR(path_stat_dest.st_mode)) {
            // Create a new destination path with the source directory name
            char new_dest[1024];
            snprintf(new_dest, sizeof(new_dest), "%s/%s", dest, strrchr(src, '/') ? strrchr(src, '/') + 1 : src);
            copy_directory(src, new_dest); // Move the entire directory
        }
    }

    // After copying, remove the source
    if (S_ISDIR(path_stat_src.st_mode)) {
        remove_dir(src); // Recursively remove the source directory
    } else {
        remove(src); // Remove the file
    }

    free(src);
    free(dest);
    return 0;
}

#endif
