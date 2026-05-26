#include "../user/usr_printstr.c"
#include "../user/usr_printint.c"
#include "../user/usr_sync.c"

int count_a;

void main() {
    count_a = 0;
    while(count_a < 5) {
        count_a = count_a + 1;
        sem_lock();
        printstr("L");
        printint(count_a);
        printstr(" ");
        sem_unlock();
        sleep(20);
    }
    sem_lock();
    printstr("L:FIM ");
    sem_unlock();
    exit();
}
