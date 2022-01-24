/******************************************************************** 
 *
 * This example program contains two functions that copy the contents
 * of a two-dimensional array from a source to a destination location.
 *
 * Execution time can be measured by:
 *   time ./copyij
 *   time ./copyji
 *
 ********************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


#define NUM_ROWS    16384
#define NUM_COLS    NUM_ROWS 


typedef int two_dim_array[NUM_ROWS][NUM_COLS];

extern void copy_array(two_dim_array *src, two_dim_array *dst);


int
main(int argc, char *argv[])
{
    two_dim_array *src;
    two_dim_array *dst;

    /* allocate memory on the heap */
    src = malloc(sizeof(two_dim_array));
    dst = malloc(sizeof(two_dim_array));
    if((src == NULL) || (dst == NULL)) {
        fprintf(stderr, "Error: cannot allocate memory for arrays\n");
        exit(EXIT_FAILURE);
    } /* end if */

    printf("Copying a two-dimensional (%dx%d) array. This may take a while...\n", 
          NUM_ROWS, NUM_COLS);
    copy_array(src, dst);

    /* free the allocated memory on the heap */
    free(src);
    free(dst);

    exit(EXIT_SUCCESS);
} /* end of main */
