#include "../user/usr_io.c"

int number;
int index;
int result;
int hundreds;
int tens;

void print_dec(int n) {
    hundreds = 0;

    while (n >= 100) {
        n = n - 100;
        hundreds = hundreds + 1;
    }

    tens = 0;

    while (n >= 10) {
        n = n - 10;
        tens = tens + 1;
    }

    if (hundreds > 0) {
        print_char(48 + hundreds);
        print_char(48 + tens);
    } else {
        if (tens > 0) {
            print_char(48 + tens);
        }
    }

    print_char(48 + n);
}

void main() {
    print_char(12);

    number = 7;
    index = 1;

    while (index <= 10) {
        print_dec(number);
        print_char(120);
        print_dec(index);
        print_char(61);

        result = number * index;
        print_dec(result);

        print_char(13);
        print_char(10);

        index = index + 1;
    }
}
