// =======================================================
// sched_fp.c - Escalonador de Prioridade Fixa
// =======================================================

void schedule() {
    int i;
    int highest_priority;
    int next_pid;
    
    // 1. Despromove o processo atual
    if (pcb[current_pid].state == STATE_RUNNING) {
        pcb[current_pid].state = STATE_READY;
    }
    
    highest_priority = -1;
    next_pid = current_pid; // Fallback para o próprio processo
    
    // 2. Procura na tabela inteira o processo READY com maior prioridade
    i = 0;
    while (i < MAX_PROCESSES) {
        if (pcb[i].state == STATE_READY) {
            // Se tiver maior prioridade, é o novo candidato a rodar
            if (pcb[i].priority > highest_priority) {
                highest_priority = pcb[i].priority;
                next_pid = i;
            }
        }
        i = i + 1;
    }
    
    // 3. Promove o processo vencedor para a CPU
    current_pid = next_pid;
    pcb[current_pid].state = STATE_RUNNING;
}