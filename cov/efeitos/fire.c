#include "../user/usr_io.c"
#include "../user/usr_yield.c"

#define W 36
#define H 14

int seed;
int x;
int y;
int v;
int key;
int run;

int rnd() {
    seed = (seed * 7) + 3;
    while (seed >= 997) {
        seed = seed - 997;
    }
    return seed;
}

void main() {
    seed = 17;
    run = 1;

    while (run != 0) {
        key = read_char();
        if (key == 113) { run = 0; }

        print_char(12);
        y = 0;

        while (y < H) {
            x = 0;

            while (x < W) {
                v = rnd();
                while (v >= H) {
                    v = v - H;
                }

                if (v >= y) {
                    if (y > H - 4) {
                        print_char(35);
                    } else {
                        if (y > H - 8) {
                            print_char(42);
                        } else {
                            print_char(46);
                        }
                    }
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

        yield(); yield();
    }
}
