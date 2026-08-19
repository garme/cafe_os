#include "../user/usr_printint.c"
#include "../user/usr_print_char.c"
#include "../user/usr_exit.c"

void main() {
    int a;
    int b;
    int t;
    int i;

    a = 0;
    b = 1;
    i = 0;

    while (i < 12) {
        printint(a);
        print_char(32);
        t = a + b;
        a = b;
        b = t;
        i = i + 1;
    }

    print_char(13);
    print_char(10);
    exit();
}
