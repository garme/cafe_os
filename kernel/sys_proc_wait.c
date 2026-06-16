#ifndef SYS_PROC_WAIT_C
#define SYS_PROC_WAIT_C

void kernel_wait(int target_pid) {
    if (pcb[target_pid].state != STATE_TERMINATED) {
        curr_pcb->state = STATE_WAITING;
        curr_pcb->waiting_for_pid = target_pid;
    }
}

#endif
