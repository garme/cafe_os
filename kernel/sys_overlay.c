#ifndef SYS_OVERLAY_C
#define SYS_OVERLAY_C
int OVERLAY_MAGIC = 51966;
int OVERLAY_HEADER_SIZE = 7;

void create_process_overlay(int pid, int entry_pc, int cs_base, int ds_base,
                            int stack_base, int priority,
                            int mem_base, int data_size, int stack_mem) {
    struct PCB_Struct *p;
    int *sp_ptr;
    p = &pcb[pid];
    p->state = STATE_READY;
    p->ac = 0;
    p->pc = entry_pc;
    p->cs = cs_base;
    p->ds = ds_base;
    p->ss = KERNEL_SS;
    p->priority = priority;
    p->age = 0;
    p->mem_base = mem_base;
    p->data_size = data_size;
    p->data_is_heap = 0;
    p->stack_mem = stack_mem;
    p->is_thread = 0;
    p->waiting_for_pid = -1;
    p->wakeup_tick = 0;
    p->alarm_tick = 0;
    p->pending_signal = 0;
    p->signal_handler = 0;
    p->in_signal = 0;

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

int kernel_spawn_overlay(int overlay_img, int priority) {
    int i;
    int free_pid;
    int version;
    int entry_pc;
    int text_size;
    int data_size;
    int bss_size;
    int stack_size;
    int header_size;
    int text_off;
    int data_off;
    int stack_mem;

    if (ram[overlay_img] != OVERLAY_MAGIC) { return -1; }
    version = ram[overlay_img + 1];
    if (version == 2) {
        entry_pc = ram[overlay_img + 2];
        text_size = ram[overlay_img + 4];
        data_size = ram[overlay_img + 5];
        bss_size = 0;
        stack_size = 64;
        header_size = 6;
    } else {
        entry_pc = ram[overlay_img + 2];
        text_size = ram[overlay_img + 3];
        data_size = ram[overlay_img + 4];
        bss_size = ram[overlay_img + 5];
        stack_size = ram[overlay_img + 6];
        if (stack_size == 0) { stack_size = 64; }
        header_size = OVERLAY_HEADER_SIZE;
    }

    i = 0;
    free_pid = -1;
    while (i < MAX_PROCESSES && free_pid == -1) {
        if (pcb[i].state == STATE_TERMINATED) { free_pid = i; }
        i = i + 1;
    }
    if (free_pid == -1) { return -1; }

    text_off = overlay_img + header_size;
    data_off = text_off + text_size;
    stack_mem = malloc(stack_size);
    if (stack_mem == 0) { return -1; }

    create_process_overlay(free_pid, entry_pc,
                           KERNEL_DS + text_off,
                           KERNEL_DS + data_off,
                           stack_mem + stack_size,
                           priority,
                           data_off,
                           data_size + bss_size,
                           stack_mem);
    return free_pid;
}
#endif
