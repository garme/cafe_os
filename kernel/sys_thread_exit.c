#ifndef SYS_THREAD_EXIT_C
#define SYS_THREAD_EXIT_C

int kernel_thread_exit() {
    if (curr_pcb->is_thread != 1) { return -1; }
    curr_pcb->state = STATE_TERMINATED;
    kernel_release_process_resources(current_pid);
    wakeup_waiters(current_pid);
    kernel_need_resched = 1;
    return 0;
}

#endif
