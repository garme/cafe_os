#ifndef SYS_PROC_SPAWN_C
#define SYS_PROC_SPAWN_C

/*
 * Versão compatível com overlays.
 * A versão antiga criava processos legados sempre com CS/DS do kernel.
 * Para spawn/thread_create a partir de uma aplicação overlay, o filho precisa
 * herdar CS e DS do processo chamador, pois task_addr é um offset dentro do
 * código do próprio overlay.
 */
void create_process(int pid, int task_addr, int stack_base, int priority, int mem_base) {
    struct PCB_Struct *p;
    int *sp_ptr;

    p = &pcb[pid];

    p->state = STATE_READY;
    p->ac = 0;
    p->pc = task_addr;
    p->cs = curr_pcb->cs;
    p->ds = curr_pcb->ds;
    p->ss = KERNEL_SS;
    p->priority = priority;
    p->age = 0;
    p->mem_base = mem_base;
    p->waiting_for_pid = -1;
    p->wakeup_tick = 0;
    p->alarm_tick = 0;
    p->pending_signal = 0;
    p->signal_handler = 0;
    p->saved_pc = 0;
    p->in_signal = 0;

    p->sig_saved_sp = 0;
    p->sig_saved_ac = 0;
    p->sig_saved_ptr = 0;
    p->sig_saved_idx = 0;
    p->sig_saved_lhs = 0;
    p->sig_saved_val = 0;
    p->sig_saved_left_cond = 0;
    p->sig_saved_left = 0;
    p->sig_saved_right = 0;
    p->sig_saved_arr_base = 0;
    p->sig_saved_step = 0;
    p->sig_saved_flags = 0;

    sp_ptr = &ram[stack_base - 1];

    *sp_ptr = task_addr; sp_ptr = sp_ptr - 1;
    *sp_ptr = 8;         sp_ptr = sp_ptr - 1;
    *sp_ptr = 0;         sp_ptr = sp_ptr - 1;
    *sp_ptr = 0;         sp_ptr = sp_ptr - 1;
    *sp_ptr = 0;         sp_ptr = sp_ptr - 1;
    *sp_ptr = 0;         sp_ptr = sp_ptr - 1;
    *sp_ptr = 0;         sp_ptr = sp_ptr - 1;
    *sp_ptr = 0;         sp_ptr = sp_ptr - 1;
    *sp_ptr = 0;         sp_ptr = sp_ptr - 1;
    *sp_ptr = 0;         sp_ptr = sp_ptr - 1;
    *sp_ptr = 0;

    p->sp = stack_base - 11;
}

int kernel_spawn(int task_addr, int priority) {
    int i = 0;
    int free_pid = -1;
    int mem;

    while (i < MAX_PROCESSES && free_pid == -1) {
        if (pcb[i].state == STATE_TERMINATED) {
            free_pid = i;
        }
        i = i + 1;
    }

    if (free_pid == -1) {
        return -1;
    }

    mem = malloc(40);
    if (mem == 0) {
        return -1;
    }

    create_process(free_pid, task_addr, mem + 40, priority, mem);
    return free_pid;
}

#endif
