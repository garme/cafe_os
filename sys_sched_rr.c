// =====================================
// sched_rr.c - Escalonador Round-Robin 
// =====================================

void schedule() {
    int i;
    int next_pid;
    int any_alive;
    int temp_pid;

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
        while(1){} 
    }
    
    // 3. Busca Circular (Avança na fila a partir do atual)
    next_pid = -1;
    i = 1;
    while (i <= MAX_PROCESSES) {
        temp_pid = current_pid + i;
        
        // Aplica o módulo (Wrap-around)
        if (temp_pid >= MAX_PROCESSES) {
            temp_pid = temp_pid - MAX_PROCESSES;
        }
        
        // O primeiro que estiver READY ganha a CPU!
        if (pcb[temp_pid].state == STATE_READY) {
            next_pid = temp_pid;
            i = MAX_PROCESSES + 1; // Quebra o laço 'while'
        } else {
            i = i + 1;
        }
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
