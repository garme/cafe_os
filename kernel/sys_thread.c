#ifndef SYS_THREAD_C
#define SYS_THREAD_C

// Dependência explícita da criação comum de processos/threads.
#include "kernel/sys_proc.c"

int kernel_thread_create(int task_addr, int priority) {
    int i;
    int free_pid;
    int shared_mem;
    int stack_mem;
    int data_size;
    int data_is_heap;

    i = 0;
    free_pid = -1;
    while (i < MAX_PROCESSES && free_pid == -1) {
        if (pcb[i].state == STATE_TERMINATED) { free_pid = i; }
        i = i + 1;
    }
    if (free_pid == -1) { return -1; }

    shared_mem = curr_pcb->mem_base;
    data_size = curr_pcb->data_size;
    data_is_heap = curr_pcb->data_is_heap;

    stack_mem = malloc(64);
    if (stack_mem == 0) { return -1; }

    create_process_ex(free_pid, task_addr, stack_mem + 64, priority,
                      curr_pcb->cs, curr_pcb->ds,
                      shared_mem, data_size, data_is_heap,
                      stack_mem, 1);
    return free_pid;
}

#endif
