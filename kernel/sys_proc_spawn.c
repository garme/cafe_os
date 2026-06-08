#ifndef SYS_PROC_SPAWN_C
#define SYS_PROC_SPAWN_C

/*
 * Criação de processo lógico com cópia privada da .data.
 *
 * spawn(task_addr, priority) cria uma nova tarefa com:
 *   - PID próprio;
 *   - pilha própria;
 *   - mesmo segmento de código do pai (CS), porque task_addr é offset no overlay;
 *   - cópia privada da área .data do pai;
 *   - DS apontando para essa cópia privada.
 *
 * thread_create(task_addr, priority), em sys_thread.c, continua sendo diferente:
 *   - herda CS/DS/mem_base do pai;
 *   - compartilha os globais intencionalmente;
 *   - aloca apenas uma pilha própria.
 */

int kernel_data_is_shared_elsewhere(int pid, int mem_base) {
    int i;
    i = 0;
    while (i < MAX_PROCESSES) {
        if (i != pid) {
            if (pcb[i].state != STATE_TERMINATED) {
                if (pcb[i].mem_base == mem_base) {
                    return 1;
                }
            }
        }
        i = i + 1;
    }
    return 0;
}

void kernel_release_process_resources(int pid) {
    int mem;
    int data_heap;

    mem = pcb[pid].stack_mem;
    if (mem != 0) {
        free(mem);
        pcb[pid].stack_mem = 0;
    }

    mem = pcb[pid].mem_base;
    data_heap = pcb[pid].data_is_heap;

    if (data_heap == 1) {
        if (mem != 0) {
            if (kernel_data_is_shared_elsewhere(pid, mem) == 0) {
                free(mem);
            }
        }
    }

    pcb[pid].mem_base = 0;
    pcb[pid].data_size = 0;
    pcb[pid].data_is_heap = 0;
}

void kernel_init_pcb_common(struct PCB_Struct *p, int priority, int mem_base, int data_size, int data_is_heap, int stack_mem, int is_thread) {
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
}

void kernel_build_initial_frame(struct PCB_Struct *p, int entry_pc, int stack_base) {
    int *sp_ptr;

    sp_ptr = &ram[stack_base - 1];

    *sp_ptr = entry_pc; sp_ptr = sp_ptr - 1;
    *sp_ptr = 8;        sp_ptr = sp_ptr - 1;
    *sp_ptr = 0;        sp_ptr = sp_ptr - 1;
    *sp_ptr = 0;        sp_ptr = sp_ptr - 1;
    *sp_ptr = 0;        sp_ptr = sp_ptr - 1;
    *sp_ptr = 0;        sp_ptr = sp_ptr - 1;
    *sp_ptr = 0;        sp_ptr = sp_ptr - 1;
    *sp_ptr = 0;        sp_ptr = sp_ptr - 1;
    *sp_ptr = 0;        sp_ptr = sp_ptr - 1;
    *sp_ptr = 0;        sp_ptr = sp_ptr - 1;
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

void create_process(int pid, int task_addr, int stack_base, int priority,
                    int mem_base, int data_size, int data_is_heap,
                    int stack_mem, int is_thread) {
    create_process_ex(pid, task_addr, stack_base, priority,
                      curr_pcb->cs, curr_pcb->ds,
                      mem_base, data_size, data_is_heap,
                      stack_mem, is_thread);
}

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
        if (pcb[i].state == STATE_TERMINATED) {
            free_pid = i;
        }
        i = i + 1;
    }

    if (free_pid == -1) {
        return -1;
    }

    data_size = curr_pcb->data_size;

    if (data_size == 0) {
        return -1;
    }

    // 1. Clona a .data do pai.
    data_mem = malloc(data_size);
    if (data_mem == 0) {
        return -1;
    }

    src_data = curr_pcb->ds - KERNEL_DS;
    i = 0;
    while (i < data_size) {
        ram[data_mem + i] = ram[src_data + i];
        i = i + 1;
    }

    // 2. Aloca pilha própria.
    stack_mem = malloc(64);
    if (stack_mem == 0) {
        free(data_mem);
        return -1;
    }

    // Processo real no modelo segmentado: mesmo CS, novo DS.
    create_process_ex(free_pid,
                      task_addr,
                      stack_mem + 64,
                      priority,
                      curr_pcb->cs,
                      KERNEL_DS + data_mem,
                      data_mem,
                      data_size,
                      1,
                      stack_mem,
                      0);

    return free_pid;
}

#endif
