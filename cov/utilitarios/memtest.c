#include "../user/usr_io.c"

int m[64];
int i;
int ok;

void main() {
    print_char(12);

    i = 0;
    while (i < 64) {
        m[i] = i + 7;
        i = i + 1;
    }

    ok = 1;
    i = 0;

    while (i < 64) {
        if (m[i] != i + 7) {
            ok = 0;
        }
        i = i + 1;
    }

    if (ok != 0) {
        print_char(77); print_char(69); print_char(77);
        print_char(32); print_char(79); print_char(75);
    } else {
        print_char(77); print_char(69); print_char(77);
        print_char(32); print_char(69); print_char(82); print_char(82);
    }

    print_char(13); print_char(10);
}
