#ifndef SYS_THREAD_C
#define SYS_THREAD_C

//----------------------------------------------------------------------
// --- Criação de Threads (Processos Leves) ---
//----------------------------------------------------------------------
int kernel_thread_create(int task_addr, int priority) {
    int i = 0;
    int free_pid = -1;
    int shared_mem;
    int stack_offset;
    
    // 1. Procura um PID livre (Terminado)
    while (i < MAX_PROCESSES && free_pid == -1) {
        if (pcb[i].state == STATE_TERMINATED) {
            free_pid = i;
        }
        i = i + 1;
    }
    
    if (free_pid == -1) {
        return -1;
    }
    
    // 2. Recupera a base de memória compartilhada do processo pai
    shared_mem = curr_pcb->mem_base;
    
    // 3. CÁLCULO DO TAMANHO DA PILHA (Fatiamento de 20 palavras)
    // Se PID 0 é o pai, o topo da pilha é shared_mem + 60.
    // Se PID 1 é a Thread 1, o topo da pilha é shared_mem + 40.
    // Se PID 2 é a Thread 2, o topo da pilha é shared_mem + 20.
    stack_offset = free_pid * 20;
    stack_offset = 60 - stack_offset;
    
    // 4. Montagem da thread
    // O SP inicial será shared_mem + stack_offset
    create_process(free_pid, task_addr, shared_mem + stack_offset, priority, shared_mem);
    
    return free_pid;
}

#endif
