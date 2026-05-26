#include "../user/usr_printstr.c"
#include "../user/usr_printint.c"
#include "../user/usr_sync.c"

int cont_a;

void main() {
    cont_a = 0;
    while(cont_a < 3) {
        cont_a = cont_a + 1;
        sem_lock();
        printint(cont_a);
        printstr(" ");
        sem_unlock();
    }

    // PID 1 deve ser legado_05_wait_b.c; selecione A antes de B na IDE.
    wait(1);

    while(cont_a < 5) {
        cont_a = cont_a + 1;
        sem_lock();
        printint(cont_a);
        printstr(" ");
        sem_unlock();
    }
    exit();
}
