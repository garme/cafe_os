#include "../user/usr_io.c"
#include "../user/usr_yield.c"

int tick;
int key;
int run;
int wait_i;
int tens;

void print2(int n) {
    tens = 0;

    while (n >= 10) {
        n = n - 10;
        tens = tens + 1;
    }

    print_char(48 + tens);
    print_char(48 + n);
}

void main() {
    tick = 0;
    run = 1;

    while (run != 0) {
        key = read_char();

        if (key == 113) {
            run = 0;
        }

        print_char(12);

        print_char(84);
        print_char(69);
        print_char(77);
        print_char(80);
        print_char(79);
        print_char(32);

        print2(tick);

        print_char(13);
        print_char(10);

        print_char(81);
        print_char(32);
        print_char(83);
        print_char(65);
        print_char(73);

        wait_i = 0;
        while (wait_i < 50) {
            yield();
            wait_i = wait_i + 1;
        }

        tick = tick + 1;

        if (tick >= 100) {
            tick = 0;
        }
    }
}
