// // customrm.h
// #ifndef CUSTOM_RM_H
// #define CUSTOM_RM_H
// #include <stdio.h>
// // Function to remove a file
// void custom_rm(char *filename) {
//     if (remove(filename) == 0) {
//         printf("File %s deleted successfully.\n", filename);
//     } else {
//         perror("Failed to delete the file");
//     }
// }

// #endif // RM_H

// customrm.h
#ifndef CUSTOM_RM_H
#define CUSTOM_RM_H
#include <stdio.h>
#include<dirent.h>
#include<string.h>
#include<sys/stat.h>
// Function to remove a file
void custom_rm(int argc,char* argv[]) {
    struct stat  buffer;
    
    
            if(argv[1][0] == '*')
            {
                printf("Entered\n");
                int dot = 0;
                int z = 0;
                char extension[10];
                for(int i = 0;i < strlen(argv[1]);i++)
                {
                    if(dot)
                    {
                        extension[z++] = argv[1][i];
                        extension[z] = '\0';
                    }
                    else
                    {
                        if(argv[1][i] == '.')
                        {
                            dot = 1;
                        }
                    }
                }
                
                //remove all the files with .extensiontype
                
                DIR *dir;
                struct dirent *entry;

                // Open the current directory
                dir = opendir(".");
                if (dir == NULL) 
                {
                    perror("opendir");
                    
                }

             // Iterate over each file in the directory
                while ((entry = readdir(dir)) != NULL) 
                {
                  // Check if the file ends with ".txt"
                  if (strcmp(entry->d_name + strlen(entry->d_name) - strlen(extension), extension) == 0) 
                  {
                      // Attempt to delete the file
                    if (unlink(entry->d_name) == 0) 
                    {
                            printf("Deleted: %s\n", entry->d_name);
                    }            
                    else 
                    {
                        perror("unlink");
                    }
                  }
                  
                }
                closedir(dir);
                return;
            }
                if(strcmp(argv[1],"-r") == 0)
                {
                    remove(argv[2]);
                    return;
                }
                else if(stat(argv[1],&buffer) == 0)
                {
                
                    if(S_ISDIR(buffer.st_mode))
                    {
                        if(strcmp(argv[1],"-r") == 0)
                        {
                            remove(argv[2]);
                        }
                        else
                        {
                            printf(" %s is a Directory\n",argv[1]);
                        }
                        
                    }
                    else
                    {
                        unlink(argv[1]);    
                    }
                }
                else
                {
                    perror("Failed Finding the file\n");
                }           
        
    }
    


#endif // RM_H