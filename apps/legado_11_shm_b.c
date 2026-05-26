#include "../user/usr_printstr.c"
#include "../user/usr_printint.c"
#include "../user/usr_sync.c"
#include "../user/usr_shm.c"

int* minha_outra_variavel;

void main() {
    sleep(1);
    minha_outra_variavel = (int*) shmget(99, 1);

    while(1) {
        mutex_lock();
        *minha_outra_variavel = *minha_outra_variavel + 1;
        printstr("B");
        printint(*minha_outra_variavel);
        printstr("\n");
        mutex_unlock();
        sleep(2);
    }
}
