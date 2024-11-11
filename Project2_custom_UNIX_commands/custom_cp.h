#ifndef CUSTOM_CP_H
#define CUSTOM_CP_H
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <sys/stat.h>
#define BUFFER_SIZE 8192

void copy_files(char* src, char* dest)
{
	FILE* src_file = fopen(src,"r");
	FILE* dest_file = fopen(dest, "w");//creates if destination file is not present
	if(!dest_file)
	{
		printf("Invalid destination path!\n");
		return;
	}

	size_t bytes_read = 0;
	char buffer[BUFFER_SIZE];//8KB buffer(efficient to reduce system calls)
	do
	{
		bytes_read = fread(buffer, 1, BUFFER_SIZE, src_file);//reading byte wise
		fwrite(buffer, 1, bytes_read, dest_file);
	} while(bytes_read > 0);
	fclose(dest_file);
	fclose(src_file);
}

// Function to copy a directory recursively
void copy_directory(const char *src_dir, const char *dst_dir) {
    struct dirent *entry;
    DIR *src_d;
    struct stat statbuf;
    char src_path[1024], dst_path[1024];

    // Open the source directory
    src_d = opendir(src_dir);
    if (!src_d) {
        perror("Error opening source directory");
        return;
    }

    // Check if the destination directory already exists
    if (!(stat(dst_dir, &statbuf) == 0 && S_ISDIR(statbuf.st_mode)))
	    // Create the destination directory if it does not exist
	    if (mkdir(dst_dir, 0755) == -1) {
	        perror("Error creating destination directory");
	        closedir(src_d);
	        return;
        
    }

    // Read the source directory and copy its contents
    while ((entry = readdir(src_d)) != NULL) {
        // Skip the '.' and '..' entries
        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) {
            continue;
        }

        // Build the full path for source and destination
        snprintf(src_path, sizeof(src_path), "%s/%s", src_dir, entry->d_name);
        snprintf(dst_path, sizeof(dst_path), "%s/%s", dst_dir, entry->d_name);

        // Get information about the current entry
        if (stat(src_path, &statbuf) == -1) {
            perror("Error reading file stats");
            continue;
        }

        // If it's a directory, recursively copy it
        if (S_ISDIR(statbuf.st_mode)) {
            copy_directory(src_path, dst_path);
        }
        // If it's a file, copy the file
        else if (S_ISREG(statbuf.st_mode)) {
            copy_files(src_path, dst_path);
        }
    }

    // Close the source directory
    closedir(src_d);
}

int custom_cp(int argc, char* argv[])
{
	// receieve mininmum two args(and an optional flag field):
	if(argc < 3 || strcmp(argv[0],"./custom_cp")!=0)
	{
		printf("Usage: custom_cp [options] src dest\n");
		return 1;
	}

	char *src, *dest, buffer[BUFFER_SIZE];
	src = (char*)malloc((strlen(argv[argc-2])+1)*sizeof(char)); //second last arg is src
	strcpy(src,argv[argc-2]);
	
	dest = (char*)malloc((strlen(argv[argc-1])+1)*sizeof(char)); //last arg is dest
	strcpy(dest,argv[argc-1]);

	// check if the args are valid file/directory names:
	/*File System in unix:"
	file to file/file to folder,
	folder to folder(with flag), folder to file: (error)*/
	
	struct stat path_stat_src, path_stat_dest;
	if(stat(src,&path_stat_src)!=0) //check if the src path exists
	{
		printf("%s: No such file or directory\n",src);
		return 2;
	}
	stat(dest,&path_stat_dest); //get info about destination
	if(S_ISREG(path_stat_src.st_mode)) //if src is a file
	{
		if(S_ISDIR(path_stat_dest.st_mode)) //if dest is a dir
		{
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
		copy_files(src, dest); //file to file/folder copy
	}
	else if(S_ISDIR(path_stat_src.st_mode)) //if src is a dir
	{

		if(strcmp(argv[1],"-r")!=0) //gotta use the -r flag for dir to dir copy
		{
			printf("Cannot copy %s dir without '-r' flag\n",src);
			return 3;
		}
		if(S_ISREG(path_stat_dest.st_mode)) //if dest is a file, then error
		{
			printf("Cannot copy %s dir to %s file\n",src,dest);
			return 3;
		}
		//else if(S_ISDIR(path_stat_dest.st_mode)) //if dest is a valid dir
			copy_directory(src,dest);
	}
	
	free(src);
	free(dest);
	return 0;
}

#endif