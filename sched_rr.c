    
// =====================================
// sched_rr.c - Escalonador Round-Robin 
// =====================================

void schedule() {
    // 1. Despromove o processo atual
    if (pcb[current_pid].state == STATE_RUNNING) {
        pcb[current_pid].state = STATE_READY;
    }
    
    // 2. Avança na fila circular
    current_pid = current_pid + 1;
    if (current_pid >= MAX_PROCESSES) {
        current_pid = 0;
    }
    
    // 3. Promove o novo processo
    pcb[current_pid].state = STATE_RUNNING;
}
