#ifndef SYS_PROC_RESOURCES_C
#define SYS_PROC_RESOURCES_C

int kernel_data_is_shared_elsewhere(int pid, int mem_base) {
    int i;
    i = 0;
    while (i < MAX_PROCESSES) {
        if (i != pid) {
            if (pcb[i].state != STATE_TERMINATED) {
                if (pcb[i].mem_base == mem_base) { return 1; }
            }
        }
        i = i + 1;
    }
    return 0;
}

void kernel_release_process_resources(int pid) {
    int mem;
    mem = pcb[pid].stack_mem;
    if (mem != 0) { free(mem); pcb[pid].stack_mem = 0; }

    mem = pcb[pid].mem_base;
    if (pcb[pid].data_is_heap == 1) {
        if (mem != 0) {
            if (kernel_data_is_shared_elsewhere(pid, mem) == 0) { free(mem); }
        }
    }
    pcb[pid].mem_base = 0;
    pcb[pid].data_size = 0;
    pcb[pid].data_is_heap = 0;
}

#endif
