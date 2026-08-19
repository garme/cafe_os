#include "../user/usr_io.c"
#include "../user/usr_yield.c"

#define W 20

int body[8];
int len;
int food;
int dir;
int key;
int i;
int x;
int hit;
int run;
int seed;

int rnd() {
    seed = (seed * 5) + 3;
    while (seed >= 97) {
        seed = seed - 97;
    }
    return seed;
}

void main() {
    len = 3;
    body[0] = 8;
    body[1] = 7;
    body[2] = 6;
    food = 15;
    dir = 1;
    run = 1;
    seed = 11;

    while (run != 0) {
        key = read_char();

        if (key == 97) { dir = 0 - 1; }
        if (key == 100) { dir = 1; }
        if (key == 113) { run = 0; }

        i = len;
        while (i > 1) {
            i = i - 1;
            body[i] = body[i - 1];
        }

        body[0] = body[0] + dir;

        if (body[0] < 0) { run = 0; }
        if (body[0] >= W) { run = 0; }

        i = 1;
        while (i < len) {
            if (body[0] == body[i]) { run = 0; }
            i = i + 1;
        }

        if (body[0] == food) {
            if (len < 8) { len = len + 1; }
            food = rnd();
            while (food >= W) { food = food - W; }
        }

        print_char(12);
        print_char(43);
        i = 0; while (i < W) { print_char(45); i = i + 1; }
        print_char(43); print_char(13); print_char(10);
        print_char(124);

        x = 0;
        while (x < W) {
            hit = 0;
            if (x == food) {
                print_char(42);
                hit = 1;
            }

            i = 0;
            while (i < len) {
                if (x == body[i]) {
                    print_char(79);
                    hit = 1;
                    i = len;
                } else {
                    i = i + 1;
                }
            }

            if (hit == 0) { print_char(32); }
            x = x + 1;
        }

        print_char(124); print_char(13); print_char(10);
        print_char(43);
        i = 0; while (i < W) { print_char(45); i = i + 1; }
        print_char(43);

        yield(); yield(); yield();
    }
}
