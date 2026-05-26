#include "../user/usr_printstr.c"
#include "../user/usr_printint.c"

int cont_a;

void main() {
    cont_a = 0;
    while(1) {
        cont_a = cont_a + 1;
        printint(cont_a);
        printstr(" ");
    }
}
