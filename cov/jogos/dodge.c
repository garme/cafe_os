#include "../user/usr_io.c"
#include "../user/usr_yield.c"

#define W 18
#define H 9

int px;
int ox;
int oy;
int key;
int x;
int y;
int seed;
int hit;
int run;

int rnd() {
    seed = (seed * 7) + 5;
    while (seed >= 97) {
        seed = seed - 97;
    }
    return seed;
}

void main() {
    px = 8;
    ox = 3;
    oy = 0;
    seed = 13;
    run = 1;

    while (run != 0) {
        key = read_char();

        if (key == 97) { if (px > 0) { px = px - 1; } }
        if (key == 100) { if (px < W - 1) { px = px + 1; } }
        if (key == 113) { run = 0; }

        oy = oy + 1;

        if (oy >= H - 1) {
            if (ox == px) {
                run = 0;
            } else {
                oy = 0;
                ox = rnd();
                while (ox >= W) { ox = ox - W; }
            }
        }

        print_char(12);
        y = 0;
        while (y < H) {
            x = 0;
            while (x < W) {
                hit = 0;

                if (x == ox) {
                    if (y == oy) {
                        print_char(88);
                        hit = 1;
                    }
                }

                if (y == H - 1) {
                    if (x == px) {
                        print_char(65);
                        hit = 1;
                    }
                }

                if (hit == 0) { print_char(32); }
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
