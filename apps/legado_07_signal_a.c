#include "../user/usr_printstr.c"
#include "../user/usr_printint.c"
#include "../user/usr_sync.c"
#include "../user/usr_signal.c"

int delay;
int sig;

naked void handler_da_task_a() {
    sig = get_signal();
    printstr("A");
    printint(sig);
    printstr("C");
    sigreturn();
}

void main() {
    signal(&handler_da_task_a);
    while(1) {
        sem_lock();
        printstr(".");
        sem_unlock();

        delay = 0;
        while(delay < 5) {
            delay = delay + 1;
        }
        yield();
    }
}
