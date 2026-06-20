#ifndef SYS_PROC_EXIT_C
#define SYS_PROC_EXIT_C

// Dependência explícita: mantém o módulo autocontido mesmo com IDEs antigas.
#include "kernel/sys_proc_resources.c"
void kernel_exit() {
    curr_pcb->state = STATE_TERMINATED;
    kernel_release_process_resources(current_pid);
    wakeup_waiters(current_pid);
    kernel_need_resched = 1;
}
#endif
