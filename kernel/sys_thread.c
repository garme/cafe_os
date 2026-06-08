#ifndef SYS_THREAD_C
#define SYS_THREAD_C

//----------------------------------------------------------------------
// --- Criação de Threads (Processos Leves) ---
//----------------------------------------------------------------------
int kernel_thread_create(int task_addr, int priority) {
    int i;
    int free_pid;
    int shared_mem;
    int stack_mem;

    i = 0;
    free_pid = -1;

    while (i < MAX_PROCESSES && free_pid == -1) {
        if (pcb[i].state == STATE_TERMINATED) {
            free_pid = i;
        }
        i = i + 1;
    }

    if (free_pid == -1) {
        return -1;
    }

    // Thread compartilha o domínio de memória do pai, mas NUNCA a pilha.
    shared_mem = curr_pcb->mem_base;

    // Pilha própria de 64 palavras. Literal intencional por limitação atual
    // do codegen em multiplicação por variável simbólica.
    stack_mem = malloc(64);
    if (stack_mem == 0) {
        return -1;
    }

    create_process(free_pid, task_addr, stack_mem + 64, priority, shared_mem, stack_mem, 1);
    return free_pid;
}

#endif
