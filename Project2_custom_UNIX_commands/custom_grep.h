//include guards
#ifndef CUSTOM_GREP_H
#define CUSTOM_GREP_H

#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<ctype.h>

#define BUFFER_SIZE 8192
#define MAX_LINE_LENGTH 1024

int containsPattern(const char* line,const char* pattern,int ignoreCase)
{
    if(ignoreCase)
    {
        char* lowerline=strdup(line);
        char* lowerPattern=strdup(pattern);

        for(int i=0;lowerline[i];i++) lowerline[i]=tolower(lowerline[i]);
        for(int i=0;lowerPattern[i];i++) lowerPattern[i]=tolower(lowerPattern[i]);

            int found=strstr(lowerline,lowerPattern)!=NULL;

            free(lowerline);
            free(lowerPattern);

            return found;
    }
    else
    {
        return strstr(line,pattern)!=NULL;
    }
}


int custom_grep(int argc,char* argv[])
{
	if(argc<3 || strcmp(argv[0],"custom_grep")!=0)
	{
		printf("Usage: custom_grep [-i] pattern dest\n");
		return 1;
	}

	char *pattern,*src,buffer[BUFFER_SIZE],line[MAX_LINE_LENGTH];

	pattern=(char*)malloc((strlen(argv[argc-2])+1)*sizeof(char));
	strcpy(pattern,argv[argc-2]+1);
    pattern[strlen(argv[argc-2])-2]='\0';
    printf("\nPATTERN=%s\n",pattern);

	src=(char*)malloc((strlen(argv[argc-1])+1)*sizeof(char));
    strcpy(src,argv[argc-1]);

    FILE *file;
    file=fopen(src,"r");

    if(file==NULL)
    {
    	perror("Error opening file");
    	return 1;
    }

    int lineNumber=1;
    int found=0;
    int ignoreCase=0;

    for(int i=1;i<argc-2;i++)
    {
        if(strcmp(argv[i],"-i")==0)
        {
            ignoreCase=1;
            break;
        }
    }

    //Read the file line by line
    while(fgets(line,MAX_LINE_LENGTH,file)!=NULL)
    {
    	if(containsPattern(line,pattern,ignoreCase))
    	{
    		printf("Pattern found at line %d:%s",lineNumber,line);
    		found=1;
    	}
    	lineNumber++;
    }

    if(!found)
    {
    	printf("Pattern '%s' not found in file '%s'.\n",pattern,src);
    }

    fclose(file);
    return 0;
}
#endif