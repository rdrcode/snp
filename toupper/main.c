#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>


#define BUFSIZE   80

/* generic function prototype, linker maps selected function to this name */
extern size_t strtoupper(char *s);


int
main(int __attribute__((unused)) argc, char __attribute__((unused)) **argv)
{
    char buffer[BUFSIZE+1];
    ssize_t cc;

    do {
        cc = read(STDIN_FILENO, buffer, BUFSIZE);

        if(cc > 0) {
            buffer[cc] = '\0';
            strtoupper(buffer);
            printf("%s", buffer);
        } else if(cc < 0) {
            perror("read()");
            exit(EXIT_FAILURE);
        } /* end if */
    } while(cc > 0);

    exit(EXIT_SUCCESS);
} /* end of main */
