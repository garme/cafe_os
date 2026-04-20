// =======================================================
// sys_sched_dp.c - Escalonador de Prioridade com Aging
// =======================================================

void schedule() {
    int i;
    int highest_priority;
    int next_pid;
    int any_alive;
    int effective_priority;

    // 1. Despromove o processo atual e zera a sua idade (pois ele acabou de rodar)
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
    highest_priority = -1;
    next_pid = -1; 
    
    i = 0;
    while (i < MAX_PROCESSES) {
        if (pcb[i].state == STATE_READY) {
            
            // A tarefa está esperando, então fica mais "velha"
            pcb[i].age = pcb[i].age + 1;
            
            // Calcula a prioridade para este exato momento
            effective_priority = pcb[i].priority + pcb[i].age;
            
            if (effective_priority > highest_priority) {
                highest_priority = effective_priority;
                next_pid = i;
            }
        }
        i = i + 1;
    }
    
    // 4. Promove o processo vencedor para a CPU
    if (next_pid != -1) {
        current_pid = next_pid;
        pcb[current_pid].state = STATE_RUNNING;
        
        // A tarefa ganhou a CPU! A fome acabou, a idade volta a zero.
        pcb[current_pid].age = 0;
        
        if (pcb[current_pid].state == STATE_TERMINATED) {
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