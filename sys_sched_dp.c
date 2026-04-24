// =======================================================
// sys_sched_dp.c - Escalonador de Prioridade com Aging
// =======================================================

void schedule() {
    int i;
    int highest_priority;
    int next_pid;
    int any_alive;
    int effective_priority;

    // 1. Despromove o processo atual
    if (pcb[current_pid].state == STATE_RUNNING) {
        pcb[current_pid].state = STATE_READY;
        pcb[current_pid].age = 0; 
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
    
    // 3. Envelhecimento (Aging) e Busca
    highest_priority = 0; // <--- CORREÇÃO: Começa em 0 para evitar o bug de 16-bits (65535)
    next_pid = current_pid; // <--- CORREÇÃO: Fallback seguro. Se ninguém ganhar, mantém o atual.
    
    i = 0;
    while (i < MAX_PROCESSES) {
        if (pcb[i].state == STATE_READY) {
            
            pcb[i].age = pcb[i].age + 1;
            effective_priority = pcb[i].priority + pcb[i].age;
            
            if (effective_priority > highest_priority) {
                highest_priority = effective_priority;
                next_pid = i;
            }
        }
        i = i + 1;
    }
    
    // 4. Promove o processo vencedor
    current_pid = next_pid;
    pcb[current_pid].state = STATE_RUNNING;
    pcb[current_pid].age = 0;
    
    if (pcb[current_pid].state == STATE_TERMINATED) {
        asm("INT CLI_INT");
        asm("INT HALT_INT");
    }
}
