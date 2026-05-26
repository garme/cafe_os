#ifndef SYS_PROC_KILL_C
#define SYS_PROC_KILL_C

void kernel_kill(int target_pid, int signal) {
    struct PCB_Struct *target;
    target = &pcb[target_pid];
    
    if (target->state != STATE_TERMINATED) {
        if (signal == SIGKILL) {
            target->state = STATE_TERMINATED;
            free(target->mem_base);
            wakeup_waiters(target_pid);
        } else {
            target->pending_signal = signal;
            if (target->state == STATE_PAUSED) {
                target->state = STATE_READY;
            }
        }
    }
}

#endif
