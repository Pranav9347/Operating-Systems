#include "user.h"

int main() {
    //check if child(proc2) can access testfile.txt:
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
        //write(1, buf, n);  // Write to stdout(fd=1)
        printf("%s\n",buf);
    }

    if (n < 0) {
        printf("Error: Could not read file\n");
    }
    char input[100];
    printf("Proc2 Input: ");
    read(0, input, sizeof(input));
    printf("You entered: %s\n",input);
    close(fd);

    exit(0);
}