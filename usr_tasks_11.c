#include "usr_syscalls.c"

int* minha_variavel;
int* minha_outra_variavel;

// TASK A (O "Pai")
naked void task_a() {

    
    // Pede um bloco de 1 palavra com a chave '99'
    minha_variavel = (int*) shmget(99, 1);
    *minha_variavel = 0; // A Task A tem a honra de inicializar
    
    while(1) {
        mutex_lock();
        *minha_variavel = *minha_variavel + 1;
        printstr("A");
        printint(*minha_variavel);
        printstr("\n");
        mutex_unlock();
        
        sleep(2);
    }
}

// TASK B (O "Filho")
naked void task_b() {
    
    sleep(1); // Espera 1 tick para a Task A inicializar a memória
    
    // Pede a MESMA chave '99'. O Kernel vai devolver o mesmo ponteiro!
    minha_outra_variavel = (int*) shmget(99, 1);
    
    while(1) {
        mutex_lock();
        *minha_outra_variavel = *minha_outra_variavel + 1;
        printstr("B");
        printint(*minha_outra_variavel);
        printstr("\n");
        mutex_unlock();
        
        sleep(2);
    }
}
