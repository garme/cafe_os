#ifndef SYS_PROC_EXIT_C
#define SYS_PROC_EXIT_C

void kernel_exit() {
    curr_pcb->state = STATE_TERMINATED;
    free(curr_pcb->mem_base);
    wakeup_waiters(current_pid);
}

#endif
