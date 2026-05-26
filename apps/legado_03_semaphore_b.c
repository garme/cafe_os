#include "../user/usr_printstr.c"
#include "../user/usr_printint.c"
#include "../user/usr_sync.c"

int cont_b;

void main() {
    cont_b = 0;
    while(1) {
        cont_b = cont_b + 1;
        sem_lock();
        printint(cont_b);
        printstr(" ");
        sem_unlock();
    }
}
