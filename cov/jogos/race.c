#include "../user/usr_io.c"
#include "../user/usr_yield.c"

#define W 20
#define H 10

int car;
int road;
int key;
int x;
int y;
int seed;
int run;
int left;
int right;

int rnd() {
    seed = (seed * 5) + 1;
    while (seed >= 89) {
        seed = seed - 89;
    }
    return seed;
}

void main() {
    car = 10;
    road = 8;
    seed = 9;
    run = 1;

    while (run != 0) {
        key = read_char();

        if (key == 97) { if (car > 1) { car = car - 1; } }
        if (key == 100) { if (car < W - 2) { car = car + 1; } }
        if (key == 113) { run = 0; }

        road = road + 1;
        if (road >= 12) {
            road = 4 + rnd();
            while (road >= W - 4) { road = road - (W - 8); }
        }

        left = road;
        right = road + 6;

        if (car <= left) { run = 0; }
        if (car >= right) { run = 0; }

        print_char(12);
        y = 0;
        while (y < H) {
            x = 0;
            while (x < W) {
                if (x == left) {
                    print_char(124);
                } else {
                    if (x == right) {
                        print_char(124);
                    } else {
                        if (y == H - 1) {
                            if (x == car) {
                                print_char(65);
                            } else {
                                print_char(32);
                            }
                        } else {
                            print_char(32);
                        }
                    }
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
