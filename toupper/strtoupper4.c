#include <string.h>


size_t
strtoupper(char *s)
{
    size_t i = 0;
    size_t num = 0;

    while(s[i] != '\0') {
        if((s[i] >= 'a') && (s[i] <= 'z')) {
            num++;
            s[i] = s[i] - ('a'-'A');
        } /* end if */
        i++;
    } /* end for */

    return num;
} /* end of strtoupper */
