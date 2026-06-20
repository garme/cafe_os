#include "usr_syscalls.c"

int child_pid;

// TASK FILHA
naked void task_b() {
    sem_lock();
    printstr("BS\n");
    sem_unlock();
    sleep(2);
    sem_lock();
    printstr("BX\n");
    sem_unlock();
    
    // O exit() da biblioteca vai chamar o Kernel. 
    // O Kernel vai dar free() na minha pilha, limpar o PID e acordar o meu pai!
    exit(); 
}

// TASK MÃE (A única iniciada pelo Boot)
naked void task_a() {
    
    // Captura o endereço da tarefa filha em C
    asm("MOV task_b");
    asm("STA addr_task_b");

    printstr("AS\n");
    
    // Chama o SO para alocar o filho dinamicamente
    child_pid = spawn(addr_task_b, 4);
    
    if (child_pid != -1) {
        sem_lock();
        printstr("A");
        printint(child_pid);
        printstr("\n");
        sem_unlock();
        
        // Bloqueia a task_init até que o filho dispare o exit()
        wait(child_pid); 
        
        printstr("AW\n");
    } else {
        printstr("PCB*\n");
    }
    
    printstr("AX\n");
    exit();
}
