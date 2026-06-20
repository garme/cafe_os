// =======================================================
// usr_tasks_8.c - A Bela Adormecida e o Príncipe
// Teste de pause(), SIGCONT e wait()
// =======================================================
#include "usr_syscalls.c"

int sig;
int i;

// ---------------------------------------------------------
// HANDLER DA TAREFA A
// ---------------------------------------------------------
naked void handler_da_task_a() {
    sig = get_signal();
    
    sem_lock();
    printstr("A");
    printint(sig);
    printstr("C");
    sem_unlock();
    
    sigreturn(); 
}

// ---------------------------------------------------------
// TAREFA A: A Bela Adormecida (PID 0)
// ---------------------------------------------------------
naked void task_a() {
    // 1. Regista o tratador de sinais
    signal(&handler_da_task_a); 
    
    sem_lock();
    printstr("...");
    sem_unlock();
    
    // 2. Dorme profundamente. O Escalonador vai ignorar a Task A.
    pause(); 
    
    // 3. Só chega aqui depois que o sinal 18 for processado pelo handler
    sem_lock();
    printstr("...");
    sem_unlock();
    
    exit(); // Morre e acorda quem estiver esperando por ela
}

// ---------------------------------------------------------
// TAREFA B: O Príncipe (PID 1)
// ---------------------------------------------------------
naked void task_b() {
    // 1. Dá um tempo para a Task A iniciar e entrar em pause()
    i = 0;
    while(i < 15) { 
        i = i + 1; 
        yield(); 
    } 
    
    // 2. Acorda a Task A com o Sinal 18 (SIGCONT)
    sem_lock();
    printstr("=*");
    sem_unlock();
    
    kill(0, SIGCONT); 

    // 3. Bloqueia a si mesma até que a Task A morra
    sem_lock();
    printstr("***");
    sem_unlock();
    
    wait(0); // Entra em STATE_WAITING aguardando o PID 0
    
    // 4. Só chega aqui quando a Task A fizer exit()
    sem_lock();
    printstr("H");
    sem_unlock();
    
    exit();
}
