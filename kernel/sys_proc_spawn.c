#ifndef SYS_PROC_SPAWN_C
#define SYS_PROC_SPAWN_C

int kernel_spawn(int task_addr, int priority) {
    int i;
    int free_pid;
    int stack_mem;
    int data_mem;
    int src_data;
    int data_size;

    i = 0;
    free_pid = -1;
    while (i < MAX_PROCESSES && free_pid == -1) {
        if (pcb[i].state == STATE_TERMINATED) { free_pid = i; }
        i = i + 1;
    }
    if (free_pid == -1) { return -1; }

    data_size = curr_pcb->data_size;
    if (data_size == 0) { return -1; }

    data_mem = malloc(data_size);
    if (data_mem == 0) { return -1; }

    src_data = curr_pcb->ds - KERNEL_DS;
    i = 0;
    while (i < data_size) {
        ram[data_mem + i] = ram[src_data + i];
        i = i + 1;
    }

    stack_mem = malloc(64);
    if (stack_mem == 0) {
        free(data_mem);
        return -1;
    }

    create_process_ex(free_pid, task_addr, stack_mem + 64, priority,
                      curr_pcb->cs, KERNEL_DS + data_mem,
                      data_mem, data_size, 1, stack_mem, 0);
    return free_pid;
}

#endif
