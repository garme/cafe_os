#include "../user/usr_printstr.c"
#include "../user/usr_sync.c"

int SIGTERM = 15;
int SIGKILL = 9;
int i;

void main() {
    i = 0;
    while(i < 30) {
        i = i + 1;
        yield();
    }

    sem_lock();
    printstr("T");
    sem_unlock();
    kill(0, SIGTERM);

    i = 0;
    while(i < 30) {
        i = i + 1;
        yield();
    }

    sem_lock();
    printstr("K");
    sem_unlock();
    kill(0, SIGKILL);

    printstr("H");
    exit();
}
