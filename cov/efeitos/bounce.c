#include "../user/usr_io.c"
#include "../user/usr_yield.c"

#define W 30
#define H 12

int bx;
int by;
int dx;
int dy;
int x;
int y;
int key;
int run;

void main() {
    bx = 2;
    by = 2;
    dx = 1;
    dy = 1;
    run = 1;

    while (run != 0) {
        key = read_char();
        if (key == 113) { run = 0; }

        bx = bx + dx;
        by = by + dy;

        if (bx <= 0) { dx = 1; }
        if (bx >= W - 1) { dx = 0 - 1; }
        if (by <= 0) { dy = 1; }
        if (by >= H - 1) { dy = 0 - 1; }

        print_char(12);
        y = 0;

        while (y < H) {
            x = 0;

            while (x < W) {
                if (x == bx) {
                    if (y == by) {
                        print_char(79);
                    } else {
                        print_char(32);
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
