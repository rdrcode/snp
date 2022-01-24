/*===================================================================
 * DHBW Ravensburg - Campus Friedrichshafen
 *
 * Vorlesung Systemnahe Programmierung (SNP)
 *
 * main.c - test skeleton for asciitoint
 *
 * Author:  Ralf Reutemann
 * Created: 09.01.2022
 *
 *===================================================================*/

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

extern int dec_to_uint(char *s, char **errptr);

int
main(int argc, char *argv[])
{
    char *errptr;

    for(int i = 1; i < argc; i++) {
        int result = dec_to_uint(argv[i], &errptr);
        printf("'%12s' -> %12d %12d '%c'\n",
                argv[i], atoi(argv[i]),
                result, *errptr);
    }

    exit(EXIT_SUCCESS);
} /* end of main */
