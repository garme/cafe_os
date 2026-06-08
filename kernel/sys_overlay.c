#ifndef SYS_OVERLAY_C
#define SYS_OVERLAY_C

// Formato da imagem de overlay injetada pela IDE no .data:
// v1: [magic, version, entry_pc, text_size, data_size, bss_size, stack_size, text..., data...]
// v2: [magic, 2, entry_pc, ds_delta, code_size, data_size, code..., data...]
int OVERLAY_MAGIC = 51966;
int OVERLAY_HEADER_SIZE = 7;

void create_process_overlay(int pid, int entry_pc, int cs_base, int ds_base,
                            int stack_base, int priority,
                            int mem_base, int data_size, int data_is_heap,
                            int stack_mem) {
    create_process_ex(pid, entry_pc, stack_base, priority,
                      cs_base, ds_base,
                      mem_base, data_size, data_is_heap,
                      stack_mem, 0);
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

    // Apenas a pilha do processo é alocada no heap. Texto/dados do overlay
    // continuam in-place dentro do .data do kernel, preservando o limite de 4K.
    stack_mem = malloc(stack_size);
    if (stack_mem == 0) { return -1; }

    create_process_overlay(
        free_pid,
        entry_pc,
        KERNEL_DS + text_off,
        KERNEL_DS + data_off,
        stack_mem + stack_size,
        priority,
        data_off,
        data_size + bss_size,
        0,
        stack_mem
    );
    return free_pid;
}

#endif
