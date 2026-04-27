// =====================================
// sched_rr.c - Escalonador Round-Robin 
// =====================================

void schedule() {
    int i;
    int next_pid;
    int any_alive;
    int temp_pid;
    
    // Novas variáveis de ponteiro
    struct PCB_Struct *curr;
    struct PCB_Struct *p;

    curr = &pcb[current_pid]; // Cache do processo atual

    // 1. Despromove o processo atual
    if (curr->state == STATE_RUNNING) {
        curr->state = STATE_READY;
    }

    // 2. VERIFICAÇÃO DE FIM DE SISTEMA
    any_alive = 0;
    i = 0;
    while (i < MAX_PROCESSES) {
        p = &pcb[i]; // Cache do processo indexado
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
    
    // 3. Busca Circular (Avança na fila a partir do atual)
    next_pid = -1;
    i = 1;
    while (i <= MAX_PROCESSES) {
        temp_pid = current_pid + i;
        
        if (temp_pid >= MAX_PROCESSES) {
            temp_pid = temp_pid - MAX_PROCESSES;
        }
        
        p = &pcb[temp_pid]; // Cache do processo testado
        if (p->state == STATE_READY) {
            next_pid = temp_pid;
            i = MAX_PROCESSES + 1; 
        } else {
            i = i + 1;
        }
    }
    
    // 4. Promove o processo vencedor para a CPU
   if (next_pid != -1) {
        current_pid = next_pid;
        curr_pcb = &pcb[current_pid]; // <--- ATUALIZA O CACHE UMA ÚNICA VEZ
        
        curr_pcb->state = STATE_RUNNING;
        
        if (curr_pcb->state == STATE_TERMINATED) {
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
