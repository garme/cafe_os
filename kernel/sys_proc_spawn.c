#ifndef SYS_PROC_SPAWN_C
#define SYS_PROC_SPAWN_C

/*
 * Criação de processo lógico no mesmo overlay.
 *
 * spawn(task_addr, priority) cria uma tarefa independente quanto a PID,
 * estado, escalonamento, wait()/kill() e pilha. Como a arquitetura atual
 * mantém apenas 4K de dados e não há MMU/cópia de .data, o filho herda
 * CS/DS do processo chamador. Portanto, globais do overlay continuam no
 * mesmo domínio de dados. Para processo isolado por imagem, use overlay.
 *
 * Diferença importante para thread_create():
 *   - spawn(): mem_base próprio e pilha própria;
 *   - thread_create(): mem_base herdado do pai e pilha própria.
 */
void create_process(int pid, int task_addr, int stack_base, int priority, int mem_base, int stack_mem, int is_thread) {
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
    p->stack_mem = stack_mem;
    p->is_thread = is_thread;
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
    int i;
    int free_pid;
    int stack_mem;

    i = 0;
    free_pid = -1;

    while (i < MAX_PROCESSES && free_pid == -1) {
        if (pcb[i].state == STATE_TERMINATED) {
            free_pid = i;
        }
        i = i + 1;
    }

    if (free_pid == -1) {
        return -1;
    }

    // 64 palavras por tarefa. Use literal para evitar a multiplicação genérica
    // por variável no codegen atual.
    stack_mem = malloc(64);
    if (stack_mem == 0) {
        return -1;
    }

    // Processo lógico: pilha própria e mem_base próprio.
    create_process(free_pid, task_addr, stack_mem + 64, priority, stack_mem, stack_mem, 0);
    return free_pid;
}

#endif
