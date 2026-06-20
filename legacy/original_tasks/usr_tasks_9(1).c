// =======================================================
// usr_tasks_9.c - Teste da Syscall Sleep (Lebre e Tartaruga)
// =======================================================
#include "usr_syscalls.c"

int count_a;
int count_b;

// ---------------------------------------------------------
// TAREFA A: A Lebre (Acorda raramente, mas trabalha rápido)
// ---------------------------------------------------------
naked void task_a() {
    count_a = 0;
    while(count_a < 5) {
        count_a = count_a + 1;
        
        sem_lock();
        printstr("L");
        printint(count_a);
        printstr(" ");
        sem_unlock();
        
        // A Lebre tira um longo sono de 20 ticks do sistema
        sleep(20); 
    }
    
    sem_lock();
    printstr("L:FIM ");
    sem_unlock();
    
    exit();
}

// ---------------------------------------------------------
// TAREFA B: A Tartaruga (Acorda frequentemente, passos curtos)
// ---------------------------------------------------------
naked void task_b() {
    count_b = 0;
    
    // A tartaruga vai contar até um número maior, pois 
    // terá a CPU quase que exclusivamente enquanto a Lebre dorme.
    while(count_b < 15) {
        count_b = count_b + 1;
        
        sem_lock();
        printstr("t");
        printint(count_b);
        printstr(" ");
        sem_unlock();
        
        // A Tartaruga tira um cochilo curto de 5 ticks
        sleep(5); 
    }
    
    sem_lock();
    printstr("t:FIM ");
    sem_unlock();
    
    exit();
}
