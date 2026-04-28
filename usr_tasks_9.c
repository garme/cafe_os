// =======================================================
// usr_tasks_9.c - Teste de IPC de Dados (Pipes / Ring Buffer)
// =======================================================
#include "usr_syscalls.c"

int i;
int c;
int delay;

// ---------------------------------------------------------
// TAREFA A: O Produtor
// ---------------------------------------------------------
naked void task_a() {
    // Array simulado escrevendo letra por letra
    write_pipe(79);  // O
    write_pipe(108); // l
    write_pipe(97);  // a
    write_pipe(32);  // [espaço]
    write_pipe(67);  // C
    write_pipe(97);  // a
    write_pipe(114); // r
    write_pipe(105); // i
    write_pipe(114); // r
    write_pipe(105); // i
    write_pipe(33);  // !
    write_pipe(10);  // \n
    write_pipe(0);   // FIM DA STRING
    
    sem_lock();
    printstr("P:F\n");
    sem_unlock();
    
    exit();
}

// ---------------------------------------------------------
// TAREFA B: O Consumidor
// ---------------------------------------------------------
naked void task_b() {
    // Atraso propositado para deixar o produtor encher o Pipe e adormecer!
    delay = 0;
    while(delay < 10) { delay = delay + 1; yield(); }
    
    sem_lock();
    printstr("C:");
    sem_unlock();
    
    c = 1;
    while(c != 0) {
        c = read_pipe(); // Ficará bloqueado aqui se o pipe estiver vazio
        
        if (c != 0) {
            sem_lock();
            print_char(c);
            sem_unlock();
            
            // Pequeno delay para podermos apreciar o escalonador a trabalhar
            delay = 0;
            while(delay < 2) { delay = delay + 1; yield(); }
        }
    }
    
    exit();
}
