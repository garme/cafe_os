// =======================================================
// usr_tasks_7.c - Teste de Sinais e Stack Spoofing
// =======================================================
#include "usr_syscalls.c"

int delay;
int i;
int sig;

// ---------------------------------------------------------
// O HANDLER: Executa no contexto da Task A (Ring 1)
// ---------------------------------------------------------
naked void handler_da_task_a() {
    sig = get_signal();
    
    printstr("A");
    printint(sig);
    printstr("C");
        
    // OBRIGATÓRIO: Sem isso, a tarefa nunca volta ao laço principal!
    sigreturn(); 
}

// ---------------------------------------------------------
// TAREFA A: Trabalhadora
// ---------------------------------------------------------
naked void task_a() {
    // 1. Regista o endereço do tratador no Kernel
    signal(&handler_da_task_a); 
    
    while(1) {
        sem_lock();
        printstr(".");
        sem_unlock();
        
        // Atraso de software para não inundar o terminal muito rápido
        delay = 0;
        while(delay < 5) { 
            delay = delay + 1; 
        } 
        
        yield(); // Cede a CPU educadamente
    }
}

// ---------------------------------------------------------
// TAREFA B: Supervisora (Assassina)
// ---------------------------------------------------------
naked void task_b() {
    // Espera a Task A imprimir alguns pontos
    i = 0;
    while(i < 30) { 
        i = i + 1; 
        yield(); 
    } 
    
    // Envia o sinal 15 (SIGTERM). O Kernel vai sequestrar a pilha da Task A!
    sem_lock();
    printstr("T");
    sem_unlock();
    kill(0, SIGTERM); 

    // Espera mais um pouco para a Task A mostrar que sobreviveu
    i = 0;
    while(i < 30) { 
        i = i + 1; 
        yield(); 
    }
    
    // Envia o sinal 9 (SIGKILL). A Task A morre sem direito a defesa.
    sem_lock();
    printstr("K");
    sem_unlock();
    kill(0, SIGKILL);
    
    printstr("H");

    exit();
}
