#include "usr_syscalls.c"

int child_pid;
int contador;

naked void task_b() {
    sem_lock();
    printstr("B\n");
    sem_unlock();
    sleep(2);
    exit(); 
}


naked void task_a() {
    
    asm("MOV task_b");
    asm("STA addr_task_b");

    contador = 0;
    
    // Vai gerar 5 filhos sequenciais
    while(contador < 10) {
        sem_lock();
        printstr("A->B\n");
        sem_unlock();
        child_pid = spawn(addr_task_b, 4);
        
        if (child_pid != -1) {
            wait(child_pid);
            sem_lock();
            printstr("Bx\n");
            sem_unlock();
        } else {
            sem_lock();
            printstr("xB\n");
            sem_unlock();
            // Se o defrag não existisse, a memória estouraria aqui!
        }
        
        contador = contador + 1;
    }
    
    printstr("Ax\n");
    exit();
}
