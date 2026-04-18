// =======================================================
// sched_fp.c - Escalonador de Prioridade Fixa
// =======================================================

void schedule() {
    int i;
    int highest_priority;
    int next_pid;
    int any_alive;

    // 1. Despromove o processo atual
    if (pcb[current_pid].state == STATE_RUNNING) {
        pcb[current_pid].state = STATE_READY;
    }

    // 2. VERIFICAÇÃO DE FIM DE SISTEMA
    any_alive = 0;
    i = 0;
    while (i < MAX_PROCESSES) {
        if (pcb[i].state != STATE_TERMINATED) {
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
        if (pcb[i].state == STATE_READY) {
            if (pcb[i].priority > highest_priority) {
                highest_priority = pcb[i].priority;
                next_pid = i;
            }
        }
        i = i + 1;
    }
    
    // 4. Promove o processo vencedor para a CPU (se houver algum READY)
    if (next_pid != -1) {
        current_pid = next_pid;
        pcb[current_pid].state = STATE_RUNNING;
        
        if (pcb[current_pid].state == STATE_TERMINATED) {
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
