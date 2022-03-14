/*===================================================================
 * DHBW Ravensburg - Campus Friedrichshafen
 *
 * Vorlesung Systemnahe Programmierung (SNP)
 *
 * list_test.c
 *
 * Author:  Ralf Reutemann
 * Created: 2022-03-14
 *
 *===================================================================*/

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <sys/time.h>
#include <assert.h>


// function prototypes
extern void list_init(void);
extern short list_size(void);
extern bool list_is_sorted(void);
extern short list_add(struct timeval *tv);
extern short list_find(struct timeval *tv);
extern bool list_get(struct timeval *tv, short idx);


struct timeval timestamps[] = {
    {1400000000, 123456},
    {1450000000, 200000},
    {1500000000, 0},
    {1550000000, 500000},
    {1590000000, 999999},
    {1600000000, 2},
    {1600000000, 5},
    {1700000000, 100000},
    {0, 0}
};


int
main(int argc, char *argv[])
{
    struct timeval tv_tmp;

    list_init();
    assert(list_size() == 0);
    assert(list_is_sorted() == false);
    assert(list_get(&tv_tmp, 0) == false);
    assert(list_get(NULL, 0) == false);

    int idx = 0;
    while(timestamps[idx].tv_sec != 0) {
        short pos = list_add(&timestamps[idx]);
        assert(pos == idx);
        idx++;
    }
    assert(list_size() == idx);
    assert(list_is_sorted() == true);

    assert(list_get(&tv_tmp, 0) == true);
    assert(memcmp(&tv_tmp, &timestamps[0], sizeof(struct timeval)) == 0);
    assert(list_find(&timestamps[0]) == 0);

    assert(list_get(&tv_tmp, idx/2) == true);
    assert(memcmp(&tv_tmp, &timestamps[idx/2], sizeof(struct timeval)) == 0);
    assert(list_find(&timestamps[idx/2]) == idx/2);

    assert(list_get(&tv_tmp, idx-1) == true);
    assert(memcmp(&tv_tmp, &timestamps[idx-1], sizeof(struct timeval)) == 0);
    assert(list_find(&timestamps[idx-1]) == idx-1);

    struct timeval tv = {1700000000, 0};
    list_add(&tv);
    assert(list_size() == idx+1);
    assert(list_is_sorted() == false);

    exit(EXIT_SUCCESS);
} /* end of main */
