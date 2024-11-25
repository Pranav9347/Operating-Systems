#include "user.h"

int main() {
    int fd;
    char buf[512];
    int n;

    // Open the file for reading
    fd = open("testfile.txt", 0);//opening in read_mode: O_RDONLY
    if (fd < 0) {
        printf("Error: Could not open file\n");
        exit(1);
    }

    // Read and print the file contents
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
        write(1, buf, n);  // Write to stdout(fd=1)
    }

    if (n < 0) {
        printf("Error: Could not read file\n");
    }

    close(fd);

    exit(0);
}