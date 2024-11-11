#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include <ctype.h>
#include "custom_rm.h"
#include "custom_wc.h"
#define MAX_CMD_LEN 1024  // Increase the size to allow for larger commands
#define MAX_ARGS 100      // Max number of arguments for a command

// Function to print the prompt
void custom_prompt() {
	static int count = 0;
	if(count == 0)
	{	
		printf("----------Custom Linux Shell----------\n");
		count++;
	}
    printf(">> ");  
}

// Function to read user input
void lsh_read(char *input) {
    fgets(input, MAX_CMD_LEN, stdin);  // Read input from user
    input[strcspn(input, "\n")] = 0;   // Remove the newline character at the end
}

// Function to parse the input command into arguments
int lsh_parse(char *input, char *args[]) {
    int i = 0;
    char *token = strtok(input, " ");  
    while (token != NULL) {
        args[i++] = token;  
        token = strtok(NULL, " ");  
    }
    args[i] = NULL;  
    return i;  
}




// Function to execute the parsed command
void execute_command(char *args[]) {
    if (strcmp(args[0], "exit") == 0) {
        exit(0);  // Exit the shell
    }
    
    // Handle wc command
    if (strcmp(args[0], "custom_wc") == 0) {
        if (args[1] == NULL) {
            fprintf(stderr, "Usage: wc <filename>\n"); //for giving the instruction of error message for the stderr (error case)
        } else {
            custom_wc(args[1]);  // Call the  wc function
        }
        return;
    }

    // Handle rm command
    if (strcmp(args[0], "custom_rm") == 0) {
        if (args[1] == NULL) {
            fprintf(stderr, "Usage: rm <filename>\n"); //for giving the instruction of error message for the stderr (error case)
        } else {
            custom_rm(args[1]);  // Call the  rm function
        }
        return;
    }

    // Fork a child process to run other commands
    pid_t pid = fork();
    if (pid == 0) {  // Child process
        execvp(args[0], args);  
        perror("Command execution failed");  // If execvp fails
        exit(1);  // Exit the child process after failure
    } else if (pid > 0) {  // Parent process
        wait(NULL);  // Wait for the child to finish
    } else {
        perror("Fork failed");
    }
}

// Main function to run the shell
int main() {
    char input[MAX_CMD_LEN];  // Buffer to store input command
    char *args[MAX_ARGS];     // Array to store command arguments
    
    while (1) {
        custom_prompt();  // Display prompt
        lsh_read(input);  // Read user input

        // If the input is "exit", break the loop and exit the shell
        if (strcmp(input, "exit") == 0) {
        printf("Thank You!:)\n");
            break;  // Exit the shell
        }

        // Parse the input into arguments
        int num_args = lsh_parse(input, args);
        
        // If there are arguments, execute the command
        if (num_args > 0) {
            execute_command(args);
        }
    }

    return 0;  
}

