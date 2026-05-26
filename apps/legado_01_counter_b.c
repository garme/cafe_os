#include "../user/usr_printstr.c"
#include "../user/usr_printint.c"

int cont_b;

void main() {
    cont_b = 0;
    while(1) {
        cont_b = cont_b + 1;
        printint(cont_b);
        printstr(" ");
    }
}
