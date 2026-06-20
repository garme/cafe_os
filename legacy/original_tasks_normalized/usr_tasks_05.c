#include "usr_syscalls.c"

int cont_a;
int cont_b;

naked void task_a() {
    cont_a = 0;
    while(cont_a < 3) {
        cont_a = cont_a + 1;
        sem_lock(); 
        printint(cont_a); 
        printstr(" "); 
        sem_unlock();
    }
    
    // A Tarefa A suspende a sua execução e espera pela morte da Tarefa B
    wait(1); 
    
    while(cont_a < 5) {
        cont_a = cont_a + 1;
        sem_lock(); 
        printint(cont_a); 
        printstr(" ");
        sem_unlock();
    }
    exit();
}

naked void task_b() {
    cont_b = 99;
    while(cont_b < 105) {
        cont_b = cont_b + 1;
        sem_lock(); 
        printint(cont_b); 
        printstr(" "); 
        sem_unlock();
    }
    // Quando a Tarefa B chamar exit(), o Kernel vai acordar a Tarefa A!
    exit();
}
