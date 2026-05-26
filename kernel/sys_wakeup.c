#ifndef SYS_WAKEUP_C
#define SYS_WAKEUP_C

//----------------------------------------------------------------------
// --- Utilitários de Acordar Processos ---
//----------------------------------------------------------------------
void wakeup_waiters(int dead_pid) {
    int i;
    struct PCB_Struct *p;
    
    i = 0;
    p = &pcb[0];
    
    while(i < MAX_PROCESSES) {
        if (p->state == STATE_WAITING) {
            if (p->waiting_for_pid == dead_pid) {
                p->state = STATE_READY;
                p->waiting_for_pid = -1;
            }
        }
        p = p + 1;
        i = i + 1;
    }
}

void wakeup_all() {
    int i;
    i = 0;
    while(i < MAX_PROCESSES) {
        if (pcb[i].state == STATE_BLOCKED) {
            pcb[i].state = STATE_READY;
        }
        i = i + 1;
    }
}

#endif
