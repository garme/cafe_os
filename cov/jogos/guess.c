#include "../user/usr_io.c"
#include "../user/usr_yield.c"

int alvo;
int c;
int n;
int tent;
int done;

void main() {
    print_char(12);
    alvo = 42;
    tent = 0;
    done = 0;

    while (done == 0) {
        print_char(62); print_char(32);
        n = 0;
        c = 0;

        while (c != 13) {
            c = read_char();
            if (c == 0) {
                yield();
            } else {
                if ((c >= 48) && (c <= 57)) {
                    n = (n * 10) + c - 48;
                    print_char(c);
                }
            }
        }

        print_char(13); print_char(10);
        tent = tent + 1;

        if (n < alvo) {
            print_char(77); print_char(65); print_char(73); print_char(79); print_char(82);
        } else {
            if (n > alvo) {
                print_char(77); print_char(69); print_char(78); print_char(79); print_char(82);
            } else {
                print_char(79); print_char(75);
                done = 1;
            }
        }

        print_char(13); print_char(10);
    }
}
