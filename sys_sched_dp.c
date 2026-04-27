// =======================================================
// sys_sched_dp.c - Escalonador de Prioridade com Aging
// =======================================================

void schedule() {
    int i;
    int highest_priority;
    int next_pid;
    int any_alive;
    int effective_priority;
    
    struct PCB_Struct *p; // Cache do processo no laço

    // 1. Despromove o processo atual (usando o Cache Global)
    if (curr_pcb->state == STATE_RUNNING) {
        curr_pcb->state = STATE_READY;
        curr_pcb->age = 0; 
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
        while(1){} 
    }
    
    // 3. Envelhecimento (Aging) e Busca
    highest_priority = 0; 
    next_pid = current_pid; 
    
    i = 0;
    while (i < MAX_PROCESSES) {
        p = &pcb[i];
        if (p->state == STATE_READY) {
            
            p->age = p->age + 1;
            effective_priority = p->priority + p->age;
            
            if (effective_priority > highest_priority) {
                highest_priority = effective_priority;
                next_pid = i;
            }
        }
        i = i + 1;
    }
    
    // 4. Promove o processo vencedor e atualiza o Cache Global
    current_pid = next_pid;
    curr_pcb = &pcb[current_pid]; // <--- ATUALIZA O CACHE KERNEL
    
    curr_pcb->state = STATE_RUNNING;
    curr_pcb->age = 0;
    
    if (curr_pcb->state == STATE_TERMINATED) {
        asm("INT CLI_INT");
        asm("INT HALT_INT");
    }
}
