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
    
    // 3. CÁLCULO DO TOPO DA PILHA DA THREAD.
    // IMPORTANTE: use literais numéricos aqui.
    // O compilador atual gera código mais seguro para multiplicação por constante.
    // Evite "free_pid * THREAD_STACK_WORDS" enquanto a multiplicação genérica
    // não for corrigida no codegen.
    //
    // Com MAX_PROCESSES=3 e fatias de 64 palavras:
    //   PID 0 / processo principal: shared_mem + 192
    //   PID 1 / thread 1:          shared_mem + 128
    //   PID 2 / thread 2:          shared_mem + 64
    stack_offset = free_pid * 64;
    stack_offset = 192 - stack_offset;
    
    // 4. Montagem da thread
    // O SP inicial será shared_mem + stack_offset
    create_process(free_pid, task_addr, shared_mem + stack_offset, priority, shared_mem);
    
    return free_pid;
}

#endif
