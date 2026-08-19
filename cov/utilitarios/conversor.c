#include "../user/usr_io.c"
#include "../user/usr_yield.c"

int n;
int c;
int done;

void main() {
    print_char(12);
    print_char(68); print_char(69); print_char(67); print_char(61);

    n = 0;
    done = 0;

    while (done == 0) {
        c = read_char();

        if (c == 0) {
            yield();
        } else {
            if (c == 13) {
                done = 1;
            } else {
                if ((c >= 48) && (c <= 57)) {
                    n = (n * 10) + c - 48;
                    print_char(c);
                }
            }
        }
    }

    print_char(13); print_char(10);
    print_char(72); print_char(69); print_char(88); print_char(61);

    if (n >= 256) {
        print_char(69); print_char(82); print_char(82);
        print_char(13); print_char(10);
        return;
    }

    c = n / 16;

    if (c < 10) {
        print_char(48 + c);
    } else {
        print_char(55 + c);
    }

    c = n - ((n / 16) * 16);

    if (c < 10) {
        print_char(48 + c);
    } else {
        print_char(55 + c);
    }

    print_char(13); print_char(10);
}
