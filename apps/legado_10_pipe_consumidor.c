#include "../user/usr_printstr.c"
#include "../user/usr_print_char.c"
#include "../user/usr_sync.c"
#include "../user/usr_pipe.c"

int c;
int delay;

void main() {
    delay = 0;
    while(delay < 10) {
        delay = delay + 1;
        yield();
    }

    sem_lock();
    printstr("C:");
    sem_unlock();

    c = 1;
    while(c != 0) {
        c = read_pipe();
        if (c != 0) {
            sem_lock();
            print_char(c);
            sem_unlock();
            delay = 0;
            while(delay < 2) {
                delay = delay + 1;
                yield();
            }
        }
    }
    exit();
}
