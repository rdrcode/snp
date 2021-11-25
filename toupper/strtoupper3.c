#include <string.h>
#include <ctype.h>


size_t
strtoupper(char *s)
{
    size_t i = 0;
    size_t num = 0;

    while(s[i] != '\0') {
        if(islower(s[i])) {
            num++;
            s[i] = toupper(s[i]);
        } /* end if */
        i++;
    } /* end for */

    return num;
} /* end of strtoupper */
