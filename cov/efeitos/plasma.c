#include "../user/usr_io.c"
#include "../user/usr_yield.c"

#define W 36
#define H 16

int phase;
int x;
int y;
int v;
int key;
int run;

void main() {
    phase = 0;
    run = 1;

    while (run != 0) {
        key = read_char();
        if (key == 113) { run = 0; }

        print_char(12);
        y = 0;

        while (y < H) {
            x = 0;

            while (x < W) {
                v = x + y + phase;

                while (v >= 12) {
                    v = v - 12;
                }

                if (v < 3) { print_char(46); }
                else {
                    if (v < 6) { print_char(42); }
                    else {
                        if (v < 9) { print_char(79); }
                        else { print_char(35); }
                    }
                }

                x = x + 1;
            }

            if (y < H - 1) {
                print_char(13); print_char(10);
            }

            y = y + 1;
        }

        phase = phase + 1;
        if (phase >= 12) { phase = 0; }

        yield(); yield();
    }
}
