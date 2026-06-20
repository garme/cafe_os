#ifndef SYS_PIPE_C
#define SYS_PIPE_C

//----------------------------------------------------------------------
// --- Utilitários de Pipes ---
//----------------------------------------------------------------------
int PIPE_SIZE = 20;
int pipe_buffer[20];
int pipe_head = 0;
int pipe_tail = 0;
int pipe_count = 0;

int kernel_write_pipe(int val) {
    int i;
    struct PCB_Struct *p;

    if (pipe_count == PIPE_SIZE) {
        curr_pcb->state = STATE_WAITING_PIPE_WRITE;
        kernel_need_resched = 1;
        return 0; // Falha
    }
    
    pipe_buffer[pipe_head] = val;
    pipe_head = pipe_head + 1;
    if (pipe_head == PIPE_SIZE) { pipe_head = 0; }
    pipe_count = pipe_count + 1;
    
    i = 0;
    while(i < MAX_PROCESSES) {
        p = &pcb[i];
        if (p->state == STATE_WAITING_PIPE_READ) {
            p->state = STATE_READY;
        }
        i = i + 1;
    }
    return 1;
}

int kernel_read_pipe() {
    int i;
    int val;
    struct PCB_Struct *p;

    if (pipe_count == 0) {
        curr_pcb->state = STATE_WAITING_PIPE_READ;
        kernel_need_resched = 1;
        return -1; // Vazio
    }
    
    val = pipe_buffer[pipe_tail];
    pipe_tail = pipe_tail + 1;
    if (pipe_tail == PIPE_SIZE) { pipe_tail = 0; }
    pipe_count = pipe_count - 1;
    
    i = 0;
    while(i < MAX_PROCESSES) {
        p = &pcb[i];
        if (p->state == STATE_WAITING_PIPE_WRITE) {
            p->state = STATE_READY;
        }
        i = i + 1;
    }
    return val;
}




#endif
