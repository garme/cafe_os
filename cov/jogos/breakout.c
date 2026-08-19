#include "../user/usr_io.c"
#include "../user/usr_yield.c"

#define W 20
#define H 9

int brick[20];
int px;
int bx;
int by;
int dx;
int dy;
int key;
int x;
int y;
int i;
int hit;
int alive;
int run;

void main() {
    i = 0;
    while (i < W) {
        brick[i] = 1;
        i = i + 1;
    }

    px = 8;
    bx = 10;
    by = 5;
    dx = 1;
    dy = 0 - 1;
    alive = W;
    run = 1;

    while (run != 0) {
        key = read_char();
        if (key == 97) { if (px > 0) { px = px - 1; } }
        if (key == 100) { if (px < W - 4) { px = px + 1; } }
        if (key == 113) { run = 0; }

        bx = bx + dx;
        by = by + dy;

        if (bx <= 0) { dx = 1; }
        if (bx >= W - 1) { dx = 0 - 1; }
        if (by <= 0) {
            if (brick[bx] != 0) {
                brick[bx] = 0;
                alive = alive - 1;
            }
            dy = 1;
        }

        if (by >= H - 1) {
            if (bx >= px) {
                if (bx <= px + 3) {
                    dy = 0 - 1;
                } else {
                    run = 0;
                }
            } else {
                run = 0;
            }
        }

        if (alive == 0) { run = 0; }

        print_char(12);
        y = 0;
        while (y < H) {
            x = 0;
            while (x < W) {
                hit = 0;

                if (y == 0) {
                    if (brick[x] != 0) {
                        print_char(35);
                        hit = 1;
                    }
                }

                if (x == bx) {
                    if (y == by) {
                        print_char(79);
                        hit = 1;
                    }
                }

                if (y == H - 1) {
                    if (x >= px) {
                        if (x <= px + 3) {
                            print_char(61);
                            hit = 1;
                        }
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
