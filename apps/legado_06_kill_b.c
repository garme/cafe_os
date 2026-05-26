#include "../user/usr_printstr.c"
#include "../user/usr_printint.c"
#include "../user/usr_sync.c"

int SIGKILL = 9;
int cont_b;

void main() {
    cont_b = 99;
    while(cont_b < 105) {
        cont_b = cont_b + 1;
        sem_lock();
        printint(cont_b);
        printstr(" ");
        sem_unlock();
    }
    // PID 0 deve ser legado_06_kill_a.c; selecione A antes de B na IDE.
    kill(0, SIGKILL);
    printint(0);
    exit();
}
