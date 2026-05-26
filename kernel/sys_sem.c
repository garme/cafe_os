#ifndef SYS_SEM_C
#define SYS_SEM_C

int SEM_STATE = 0;

void kernel_sem_lock() {
    if (SEM_STATE == 0) {
        SEM_STATE = 1;
    } else {
        pcb[current_pid].state = STATE_BLOCKED;
    }
}

void kernel_sem_unlock() {
    int i;
    int acordou_alguem;
    
    acordou_alguem = 0;
    i = 0;
    
    while(i < MAX_PROCESSES) {
        if (pcb[i].state == STATE_BLOCKED) {
            pcb[i].state = STATE_READY;
            acordou_alguem = 1;
            i = MAX_PROCESSES;
        } else {
            i = i + 1;
        }
    }
    
    if (acordou_alguem == 0) {
        SEM_STATE = 0;
    }
}

#endif
