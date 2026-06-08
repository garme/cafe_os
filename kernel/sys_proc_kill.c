#ifndef SYS_PROC_KILL_C
#define SYS_PROC_KILL_C

void kernel_kill(int target_pid, int signal) {
    struct PCB_Struct *target;
    target = &pcb[target_pid];

    if (target->state != STATE_TERMINATED) {
        if (signal == SIGKILL) {
            target->state = STATE_TERMINATED;
            free(target->stack_mem);
            target->stack_mem = 0;
            wakeup_waiters(target_pid);
            kernel_need_resched = 1;
        } else {
            target->pending_signal = signal;
            if (target->state == STATE_PAUSED) {
                target->state = STATE_READY;
                kernel_need_resched = 1;
            }
        }
    }
}

#endif
