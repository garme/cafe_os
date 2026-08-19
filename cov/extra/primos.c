#include "../user/usr_printint.c"
#include "../user/usr_print_char.c"
#include "../user/usr_exit.c"

int divisivel(int n, int d) {
    int r;
    r = n;
    while (r > d) {
        r = r - d;
    }
    if (r == d) {
        return 1;
    }
    return 0;
}

void main() {
    int n;
    int d;
    int p;

    n = 2;
    while (n <= 40) {
        d = 2;
        p = 1;
        while ((d * d) <= n) {
            if (divisivel(n, d) != 0) {
                p = 0;
                d = n;
            }
            d = d + 1;
        }
        if (p != 0) {
            printint(n);
            print_char(32);
        }
        n = n + 1;
    }
    print_char(13);
    print_char(10);
    exit();
}
