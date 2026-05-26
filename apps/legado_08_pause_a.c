#include "../user/usr_printstr.c"
#include "../user/usr_printint.c"
#include "../user/usr_sync.c"
#include "../user/usr_signal.c"

int sig;

naked void handler_da_task_a() {
    sig = get_signal();
    sem_lock();
    printstr("A");
    printint(sig);
    printstr("C");
    sem_unlock();
    sigreturn();
}

void main() {
    signal(&handler_da_task_a);
    sem_lock();
    printstr("...");
    sem_unlock();
    pause();
    sem_lock();
    printstr("...");
    sem_unlock();
    exit();
}
