// =======================================================
// sched_aging.c - Escalonador c/ Envelhecimento (Aging)
// =======================================================

void schedule() {
    int i;
    int highest_priority;
    int next_pid;
    
    // 1. Despromove o processo atual
    if (pcb[current_pid].state == STATE_RUNNING) {
        pcb[current_pid].state = STATE_READY;
    }
    
    // 2. O ENVELHECIMENTO (AGING)
    // Todos os processos em espera ficam com +1 de prioridade
    i = 0;
    while (i < MAX_PROCESSES) {
        if (pcb[i].state == STATE_READY) {
            pcb[i].priority = pcb[i].priority + 1;
        }
        i = i + 1;
    }
    
    // 3. Procura o processo com maior prioridade
    highest_priority = -1;
    next_pid = current_pid; 
    
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
    
    // 4. Promove o vencedor e RESETA a sua prioridade
    current_pid = next_pid;
    pcb[current_pid].state = STATE_RUNNING;
    
    // O processo ganhou a CPU, logo volta à sua prioridade original!
    pcb[current_pid].priority = pcb[current_pid].base_priority; 
}