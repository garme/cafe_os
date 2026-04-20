#include "ipc_sem.c"

int contador_a;
int contador_b;

// Usar naked e gerir o retorno manualmente!
naked void print_space() {
    asm("INT CLI_INT"); 

    asm("SOP pop");
    asm("STA tmp_lock_ret");

    asm("MOV 32"); 
    asm("INT OUT_INT");

    asm("MOV 0");
    asm("SOP push");
    asm("LDA tmp_lock_ret");
    asm("SOP push");

    asm("INT TIMER_INT");
    asm("RET");
}

naked void task_a() {
    while(contador_a < 50) {
        contador_a = contador_a + 1;
        
        lock_sem();
        printint(contador_a);
        print_space();
        unlock_sem();
    }
    // A Tarefa A terminou a sua missão!
    exit();
}

naked void task_b() {
    while(1) {
        contador_b = contador_b + 1;
        
        lock_sem();
        printint(contador_b);
        print_space();
        unlock_sem();
    }
}
