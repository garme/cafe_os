#include "../user/usr_io.c"
#include "../user/usr_yield.c"

#define W 40
#define H 18

int star[18];
int seed;
int x;
int y;
int i;
int key;
int run;

int rnd() {
    seed = (seed * 5) + 3;
    while (seed >= 997) {
        seed = seed - 997;
    }
    return seed;
}

void main() {
    seed = 21;
    i = 0;

    while (i < H) {
        star[i] = rnd();
        while (star[i] >= W) {
            star[i] = star[i] - W;
        }
        i = i + 1;
    }

    run = 1;

    while (run != 0) {
        key = read_char();
        if (key == 113) { run = 0; }

        print_char(12);
        y = 0;

        while (y < H) {
            x = 0;

            while (x < W) {
                if (x == star[y]) {
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

        i = 0;
        while (i < H) {
            star[i] = star[i] + 1;
            if (star[i] >= W) {
                star[i] = 0;
            }
            i = i + 1;
        }

        yield(); yield();
    }
}
