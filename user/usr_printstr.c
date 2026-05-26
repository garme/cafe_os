#ifndef USR_PRINTSTR_C
#define USR_PRINTSTR_C
#include "../user/usr_print_char.c"

void printstr(char* str) {
    int i;
    int c;
    i = 0;
    c = str[i];
    while (c != 0) {
        print_char(c);
        i = i + 1;
        c = str[i];
    }
}

#endif
