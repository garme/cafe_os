#include "usr_syscalls.c"

int compartilhado;

int addr_thread_incremento;
int addr_thread_decremento;
int t1, t2;

// Comportamento 1: Incrementador
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

// Comportamento 2: Decrementador
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

// Processo Pai (Iniciado pelo Kernel como PID 0)
naked void task_a() {
    compartilhado = 10;

    // Captura endereços para a syscall thread_create (ID 29)
    asm("MOV thread_incremento"); asm("STA addr_thread_incremento");
    asm("MOV thread_decremento"); asm("STA addr_thread_decremento");

    // Cria duas threads com comportamentos distintos no mesmo mem_base
    t1 = thread_create(addr_thread_incremento, 4);
    t2 = thread_create(addr_thread_decremento, 4);

    // O pai pode monitorar ou realizar um terceiro comportamento
    wait(t1);
    wait(t2);
    exit();
}
