#ifndef USR_PRINTINT_C
#define USR_PRINTINT_C
#include "../user/usr_print_char.c"

void printint(int val) {
    int q;
    int r;
    int reverse[10];
    int count;
    int i;

    if (val == 0) {
        print_char(48);
    } else {
        if (val < 0) {
            print_char(45);
            val = 0 - val;
        }

        count = 0;
        while (val > 0) {
            q = 0;
            r = val;
            while (r >= 10) {
                r = r - 10;
                q = q + 1;
            }
            reverse[count] = r + 48;
            count = count + 1;
            val = q;
        }

        i = count - 1;
        while (i >= 0) {
            print_char(reverse[i]);
            i = i - 1;
        }
    }
}

#endif
