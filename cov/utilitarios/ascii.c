#include "../user/usr_io.c"
#include "../user/usr_yield.c"

int c;
int v;
int h;
int d;

void print_dec(int n) {
    h = 0;
    while (n >= 100) {
        n = n - 100;
        h = h + 1;
    }

    d = 0;
    while (n >= 10) {
        n = n - 10;
        d = d + 1;
    }

    if (h > 0) {
        print_char(48 + h);
        print_char(48 + d);
    } else {
        if (d > 0) {
            print_char(48 + d);
        }
    }

    print_char(48 + n);
}

void main() {
    print_char(12);
    c = 0;

    while (c != 113) {
        c = read_char();

        if (c == 0) {
            yield();
        } else {
            if (c != 113) {
                print_char(67);
                print_char(79);
                print_char(68);
                print_char(61);

                v = c;
                print_dec(v);

                print_char(13);
                print_char(10);
            }
        }
    }
}
