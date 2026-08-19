#include "../user/usr_io.c"

int day;
int week;
int tens;
int value;

void print2(int n) {
    tens = 0;

    while (n >= 10) {
        n = n - 10;
        tens = tens + 1;
    }

    if (tens == 0) {
        print_char(32);
    } else {
        print_char(48 + tens);
    }

    print_char(48 + n);
}

void main() {
    print_char(12);

    print_char(68);
    print_char(79);
    print_char(77);
    print_char(32);
    print_char(83);
    print_char(69);
    print_char(71);
    print_char(32);
    print_char(84);
    print_char(69);
    print_char(82);
    print_char(32);
    print_char(81);
    print_char(85);
    print_char(73);
    print_char(32);
    print_char(83);
    print_char(69);
    print_char(88);
    print_char(32);
    print_char(83);
    print_char(65);
    print_char(66);
    print_char(13);
    print_char(10);

    day = 1;
    week = 0;

    while (day <= 31) {
        print2(day);
        print_char(32);

        week = week + 1;

        if (week >= 7) {
            print_char(13);
            print_char(10);
            week = 0;
        }

        day = day + 1;
    }

    print_char(13);
    print_char(10);
}
