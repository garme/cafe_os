#include "../user/usr_printstr.c"
#include "../user/usr_printint.c"
#include "../user/usr_sync.c"
#include "../user/usr_shm.c"

int* minha_variavel;

void main() {
    minha_variavel = (int*) shmget(99, 1);
    *minha_variavel = 0;

    while(1) {
        mutex_lock();
        *minha_variavel = *minha_variavel + 1;
        printstr("A");
        printint(*minha_variavel);
        printstr("\n");
        mutex_unlock();
        sleep(2);
    }
}
