#include "../user/usr_io.c"
#include "../user/usr_yield.c"

#define W 40
#define H 12

int phase;
int x;
int y;
int pos;
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
                pos = x + phase;
                while (pos >= H + H) {
                    pos = pos - (H + H);
                }

                if (pos >= H) {
                    pos = (H + H - 1) - pos;
                }

                if (y == pos) {
                    print_char(42);
                } else {
                    print_char(32);
                }

                x = x + 1;
            }

            if (y < H - 1) {
                print_char(13); print_char(10);
            }

            y = y + 1;
        }

        phase = phase + 1;
        if (phase >= H + H) { phase = 0; }

        yield(); yield();
    }
}
