#ifndef SYS_PROC_EXIT_C
#define SYS_PROC_EXIT_C

void kernel_exit() {
    curr_pcb->state = STATE_TERMINATED;
    free(curr_pcb->stack_mem);
    curr_pcb->stack_mem = 0;
    wakeup_waiters(current_pid);
    kernel_need_resched = 1;
}

#endif
