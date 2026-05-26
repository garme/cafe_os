#include "../user/usr_printstr.c"
#include "../user/usr_printint.c"
#include "../user/usr_sync.c"
#include "../user/usr_thread.c"

int compartilhado;
int addr_thread_incremento;
int addr_thread_decremento;
int t1;
int t2;

void thread_incremento() {
    while(1) {
        sem_lock();
        compartilhado = compartilhado + 1;
        printstr("I:");
        printint(compartilhado);
        printstr("\n");
        sem_unlock();
        yield();
    }
}

void thread_decremento() {
    while(1) {
        sem_lock();
        compartilhado = compartilhado - 1;
        printstr("D:");
        printint(compartilhado);
        printstr("\n");
        sem_unlock();
        yield();
    }
}

void main() {
    compartilhado = 10;
    asm("MOV thread_incremento"); asm("STA addr_thread_incremento");
    asm("MOV thread_decremento"); asm("STA addr_thread_decremento");
    t1 = thread_create(addr_thread_incremento, 4);
    t2 = thread_create(addr_thread_decremento, 4);
    wait(t1);
    wait(t2);
    exit();
}
