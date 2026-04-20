#include "usr_syscalls.c"

int cont_a;
int cont_b;

naked void task_a() {
    cont_a = 0;
    while(1) {
        cont_a = cont_a + 1;

        sem_lock(); 
        printint(cont_a); 
        print_space(); 
        sem_unlock();
    }
}

naked void task_b() {
    cont_b = 99;
    while(cont_b < 105) {
        cont_b = cont_b + 1;
        sem_lock(); 
        printint(cont_b); 
        print_space(); 
        sem_unlock();
    }
    
    // Mata a Tarefa A antes de sair.
    kill(0);
    printint(0);
    exit();
}
