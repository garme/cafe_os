#include "../user/usr_printstr.c"
#include "../user/usr_printint.c"
#include "../user/usr_sleep.c"
#include "../user/usr_exit.c"

void main() {
    int i;
    i = 0;
    while (i < 5) {
        printstr("contador=");
        printint(i);
        print_char(10);
        i = i + 1;
        sleep(2);
    }
    exit();
}
