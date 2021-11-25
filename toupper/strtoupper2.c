#include <string.h>
#include <ctype.h>


size_t
mystrlen(char *s)
{
    size_t num = 0;

    while(s[num] != '\0') num++;

    return num;
} /* end of mystrlen */


size_t
strtoupper(char *s)
{
    size_t num = 0;
    size_t len = mystrlen(s);

    for(size_t i = 0; i < len; i++) {
        if(islower(s[i])) {
            num++;
            s[i] = toupper(s[i]);
        } /* end if */
    } /* end for */

    return num;
} /* end of strtoupper */
