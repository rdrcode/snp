#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

struct chartag_s {
    char *tagname;
    int (*func)(int ch);
};

struct chartag_s chartags[] = {
    { "CHR_DIG", isdigit },
    { "CHR_LOW", islower },
    { "CHR_SPC", isspace },
    { "CHR_UPP", isupper },
    { "CHR_PCT", ispunct },
    { "CHR_CTL", iscntrl },
    { "CHR_OTH", NULL }
};

int main(int argc, char *argv[])
{
    int tagid = 0;

    do {
        printf("        ; %s: %d\n", chartags[tagid].tagname, tagid);
    } while(chartags[tagid++].func != NULL);

    for(int ch = 0; ch <= 128; ch++) {
        tagid = 0;
        while(chartags[tagid].func != NULL) {
            if((chartags[tagid].func)((unsigned char)ch)) break;
            tagid++;
        }

        printf("        db %d  ; %3d 0x%02x '%c' %s\n",
            tagid,
            ch, ch, isprint(ch) ? ch : '.',
            chartags[tagid].tagname);
    } /* end for */

    exit(0);
}
