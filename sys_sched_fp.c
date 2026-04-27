// =======================================================
// sched_fp.c - Escalonador de Prioridade Fixa
// =======================================================

void schedule() {
    int i;
    int highest_priority;
    int next_pid;
    int any_alive;
    
    struct PCB_Struct *p; // Cache do processo no laço

    // 1. Despromove o processo atual (usando o Cache Global)
    if (curr_pcb->state == STATE_RUNNING) {
        curr_pcb->state = STATE_READY;
    }

    // 2. VERIFICAÇÃO DE FIM DE SISTEMA
    any_alive = 0;
    i = 0;
    while (i < MAX_PROCESSES) {
        p = &pcb[i];
        if (p->state != STATE_TERMINATED) {
            any_alive = 1;
        }
        i = i + 1;
    }

    if (any_alive == 0) {
        asm("INT CLI_INT"); 
        asm("INT HALT_INT");
        while(1){} // Trava de segurança no encerramento
    }
    
    // 3. Procura na tabela o processo READY com maior prioridade
    highest_priority = -1;
    next_pid = -1; 
    
    i = 0;
    while (i < MAX_PROCESSES) {
        p = &pcb[i];
        if (p->state == STATE_READY) {
            if (p->priority > highest_priority) {
                highest_priority = p->priority;
                next_pid = i;
            }
        }
        i = i + 1;
    }
    
    // 4. Promove o processo vencedor para a CPU e atualiza o Cache
    if (next_pid != -1) {
        current_pid = next_pid;
        curr_pcb = &pcb[current_pid]; // <--- ATUALIZA O CACHE KERNEL
        
        curr_pcb->state = STATE_RUNNING;
        
        if (curr_pcb->state == STATE_TERMINATED) {
            // estado inválido → trava
            asm("INT CLI_INT");
            asm("INT HALT_INT");
        }
        return;
    }
    else {
        asm("INT CLI_INT");
        asm("INT HALT_INT");
    }
}
