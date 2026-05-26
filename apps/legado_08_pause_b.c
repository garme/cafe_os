#include "../user/usr_printstr.c"
#include "../user/usr_sync.c"

int SIGCONT = 18;
int i;

void main() {
    i = 0;
    while(i < 15) {
        i = i + 1;
        yield();
    }

    sem_lock();
    printstr("=*");
    sem_unlock();
    kill(0, SIGCONT);

    sem_lock();
    printstr("***");
    sem_unlock();
    wait(0);

    sem_lock();
    printstr("H");
    sem_unlock();
    exit();
}
