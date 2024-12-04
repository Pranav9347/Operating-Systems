# Operating-Systems
Operating Systems projects: modify xv6 OS and Unix commands:

## xv6 Operating system
This is a collaboration project where we modify or add new features to the xv6 Operating System. xv6 is a simple, Unix-like teaching operating system developed at MIT. It is  designed as a minimal, modernized reimplementation of the UNIX Version 6 (v6) system from the 1970s.
### Plan:
- Inter-process communication: Add message passing enabling communication between any processes and bidirectional communication, unlike the exisiting IPC: pipe which allows communication between parent and child processes only.
- Locks: Add semaphores to improve the locking mechanism, currently existing spinlocks spend CPU cycles trying to acquire lock which makes it inefficient: semaphores block the process till lock is released
- get process state
- get parent process id


## Implementing Unix-commands in a custom-shell program:
* custom_ls
* custom_cat
* custom_cp
* custom_grep
* custom_wc
* custom_mv
* custom_rm


## Contributions:
### xv6 Operating System:
* Locks-semaphores: Pranav Vijay Nadgir (CS22B1034)
* Get process state: Krishna Karthik (CS22B1001)
* Get parent process ID: Prabhas Dhanikonda (CS22B1002)
* IPC-Message Passing: Nitish R Naik (CS22B1035)


### Customizing unix-commands:
* Shell program, custom_wc, custom_rm: Nitish R Naik (CS22B1035)
* custom_cp, custom_mv: Pranav Nadgir (CS22B1034)
* custom_grep: Krishna Karthik (CS22B1001)
* custom_cat: Prabhas Dhanikonda (CS22B1002)
