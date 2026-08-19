#include "../user/usr_io.c"

int i;

void main() {
    print_char(12);

    i = 32;
    while (i < 127) {
        print_char(i);
        print_char(32);

        if (i == 63) {
            print_char(13); print_char(10);
        }

        if (i == 95) {
            print_char(13); print_char(10);
        }

        i = i + 1;
    }

    print_char(13); print_char(10);
}
