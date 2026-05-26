#include "../user/usr_printstr.c"
#include "../user/usr_printint.c"
#include "../user/usr_sync.c"

int cont_a;

void main() {
    cont_a = 0;
    while(1) {
        cont_a = cont_a + 1;
        mutex_lock();
        printint(cont_a);
        printstr(" ");
        mutex_unlock();
    }
}
