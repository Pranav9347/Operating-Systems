#include "user.h"

int main() {
    // Send ANSI escape sequences to clear the terminal
    printf("\033[H\033[J");  // Move cursor to home (top-left) and clear screen
    exit(0);
}
