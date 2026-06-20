#ifndef SYS_PROC_C
#define SYS_PROC_C

void kernel_init_pcb_common(struct PCB_Struct *p, int priority, int mem_base,
                            int data_size, int data_is_heap,
                            int stack_mem, int is_thread) {
    p->state = STATE_READY;
    p->ac = 0;
    p->priority = priority;
    p->age = 0;
    p->mem_base = mem_base;
    p->data_size = data_size;
    p->data_is_heap = data_is_heap;
    p->stack_mem = stack_mem;
    p->is_thread = is_thread;
    p->waiting_for_pid = -1;
    p->wakeup_tick = 0;
    p->alarm_tick = 0;
    p->pending_signal = 0;
    p->signal_handler = 0;
    p->in_signal = 0;
}

void kernel_build_initial_frame(struct PCB_Struct *p, int entry_pc, int stack_base) {
    int *sp_ptr;
    sp_ptr = &ram[stack_base - 1];
    *sp_ptr = entry_pc; sp_ptr = sp_ptr - 1;
    *sp_ptr = 8; sp_ptr = sp_ptr - 1;
    *sp_ptr = 0; sp_ptr = sp_ptr - 1;
    *sp_ptr = 0; sp_ptr = sp_ptr - 1;
    *sp_ptr = 0; sp_ptr = sp_ptr - 1;
    *sp_ptr = 0; sp_ptr = sp_ptr - 1;
    *sp_ptr = 0; sp_ptr = sp_ptr - 1;
    *sp_ptr = 0; sp_ptr = sp_ptr - 1;
    *sp_ptr = 0; sp_ptr = sp_ptr - 1;
    *sp_ptr = 0; sp_ptr = sp_ptr - 1;
    *sp_ptr = 0;
    p->sp = stack_base - 11;
}

void create_process_ex(int pid, int task_addr, int stack_base, int priority,
                       int cs_base, int ds_base,
                       int mem_base, int data_size, int data_is_heap,
                       int stack_mem, int is_thread) {
    struct PCB_Struct *p;
    p = &pcb[pid];
    kernel_init_pcb_common(p, priority, mem_base, data_size, data_is_heap, stack_mem, is_thread);
    p->pc = task_addr;
    p->cs = cs_base;
    p->ds = ds_base;
    p->ss = KERNEL_SS;
    kernel_build_initial_frame(p, task_addr, stack_base);
}

#endif
