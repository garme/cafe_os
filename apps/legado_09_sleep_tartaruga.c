#include "../user/usr_printstr.c"
#include "../user/usr_printint.c"
#include "../user/usr_sync.c"

int count_b;

void main() {
    count_b = 0;
    while(count_b < 15) {
        count_b = count_b + 1;
        sem_lock();
        printstr("t");
        printint(count_b);
        printstr(" ");
        sem_unlock();
        sleep(5);
    }
    sem_lock();
    printstr("t:FIM ");
    sem_unlock();
    exit();
}
