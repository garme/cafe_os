// =======================================================
// sys_ipc.c - Lógica de Retaguarda do Kernel (Ring 0)
// =======================================================

// --- VARIÁVEIS DE CONTEXTO PARA SINCRONIZAÇÂO ---
int SEM_STATE = 0; // 0 = Livre, 1 = Ocupado
int MUTEX_ZERO = 0;
int MUTEX_STATE = 0;
int tmp_lock_ret; // Usada em zonas estritamente protegidas (CLI)


//----------------------------------------------------------------------
// --- Utilitários de Pipes ---
//----------------------------------------------------------------------
int PIPE_SIZE = 8;
int pipe_buffer[8];
int pipe_head = 0;
int pipe_tail = 0;
int pipe_count = 0;

int kernel_write_pipe(int val) {
    int i;
    struct PCB_Struct *p;

    if (pipe_count == PIPE_SIZE) {
        curr_pcb->state = STATE_WAITING_PIPE_WRITE;
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



//----------------------------------------------------------------------
// --- Utilitários de Acordar Processos ---
//----------------------------------------------------------------------
void wakeup_waiters(int dead_pid) {
    int i;
    struct PCB_Struct *p;
    i = 0;
    while(i < MAX_PROCESSES) {
        p = &pcb[i]; // Cache no laço
        if (p->state == STATE_WAITING) {
            if (p->waiting_for_pid == dead_pid) {
                p->state = STATE_READY;
                p->waiting_for_pid = -1;
            }
        }
        i = i + 1;
    }
}

void wakeup_all() {
    int i;
    i = 0;
    while(i < MAX_PROCESSES) {
        if (pcb[i].state == STATE_BLOCKED) {
            pcb[i].state = STATE_READY;
        }
        i = i + 1;
    }
}

//----------------------------------------------------------------------
// --- LÓGICA DO SEMÁFORO (BLOQUEIO) ---
//----------------------------------------------------------------------
void kernel_sem_lock() {
    if (SEM_STATE == 0) {
        SEM_STATE = 1; // Pega a tranca imediatamente
    } else {
        // A mágica: Adormece o processo! O escalonador fará o resto.
        pcb[current_pid].state = STATE_BLOCKED;
    }
}

void kernel_sem_unlock() {
    int i;
    int acordou_alguem;
    
    acordou_alguem = 0;
    i = 0;
    
    // Procura apenas UM processo que esteja à espera do semáforo
    while(i < MAX_PROCESSES) {
        if (pcb[i].state == STATE_BLOCKED) {
            pcb[i].state = STATE_READY; // Acorda o processo
            acordou_alguem = 1;         // Regista que encontrou alguém
            
            // Força a saída do laço para não acordar mais ninguém!
            // No seu compilador, como não há 'break', forçamos o índice:
            i = MAX_PROCESSES; 
        } else {
            i = i + 1;
        }
    }
    
    // Se a fila de espera estava vazia, destrancamos a porta de facto.
    if (acordou_alguem == 0) {
        SEM_STATE = 0;
    }
    
    // Nota: Se 'acordou_alguem' for 1, a variável SEM_STATE continua 
    // a valer 1. O Kernel acabou de transferir a posse da tranca 
    // diretamente para a tarefa que foi acordada!
}

//----------------------------------------------------------------------
// --- LÓGICA DO MUTEX / SPINLOCK (ESPERA OCUPADA) ---
//----------------------------------------------------------------------
int kernel_mutex_trylock() {
    // Apenas testa a tranca e responde. Não altera o estado do PCB!
    if (MUTEX_STATE == 0) {
        MUTEX_STATE = 1;
        return 1; // Sucesso
    }
    return 0;     // Falhou (O User Space que lide com isso)
}

void kernel_mutex_unlock() {
    MUTEX_STATE = 0;
}

//----------------------------------------------------------------------
// --- Handlers das Chamadas de Sistema ---
//----------------------------------------------------------------------
void kernel_exit() {
    curr_pcb->state = STATE_TERMINATED;
    free(curr_pcb->mem_base); 
    wakeup_waiters(current_pid);     
}

void kernel_wait(int target_pid) {
    if (pcb[target_pid].state != STATE_TERMINATED) {
        curr_pcb->state = STATE_WAITING;
        curr_pcb->waiting_for_pid = target_pid;
    }
}

// Syscall: kill(pid, sinal)
void kernel_kill(int target_pid, int signal) {
    struct PCB_Struct *target;
    target = &pcb[target_pid]; // Faz a conta APENAS UMA VEZ
    
    if (target->state != STATE_TERMINATED) {
        if (signal == SIGKILL) {
            target->state = STATE_TERMINATED;
            free(target->mem_base);  
            wakeup_waiters(target_pid);
        } else {
            target->pending_signal = signal;
            if (target->state == STATE_PAUSED) {
                target->state = STATE_READY;
            }
        }
    }
}

void kernel_sleep(int ticks_to_sleep) {
    curr_pcb->wakeup_tick = system_ticks + ticks_to_sleep;
    curr_pcb->state = STATE_SLEEPING;
}

void kernel_alarm(int ticks) {
    if (ticks == 0) {
        pcb[current_pid].alarm_tick = 0; // alarm(0) cancela o alarme
    } else {
        pcb[current_pid].alarm_tick = system_ticks + ticks;
    }
}

void kernel_pause() {
    curr_pcb->state = STATE_PAUSED;
}

//----------------------------------------------------------------------
// --- Criação do Processo ---
//----------------------------------------------------------------------
void create_process(int pid, int task_addr, int stack_base, int priority, int mem_base) {
    struct PCB_Struct *p;
    int *sp_ptr;
    
    p = &pcb[pid]; // Multiplicação pesada executada UMA única vez
    
    p->state = STATE_READY;
    p->ac = 0;
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
    p->sig_saved_arr_base = 0; // Novo
    p->sig_saved_step = 0;     // Novo
    p->sig_saved_flags = 0;
        
    sp_ptr = &ram[stack_base - 1]; 

    *sp_ptr = task_addr; sp_ptr = sp_ptr - 1;
    *sp_ptr = 8;         sp_ptr = sp_ptr - 1; // Flag 8 (User Mode)
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

//----------------------------------------------------------------------
// --- ROTINAS DE INJEÇÃO DO KERNEL (SIGNALS) ---
//----------------------------------------------------------------------

// Regista a função do utilizador
void kernel_signal(int handler_addr) {
    curr_pcb->signal_handler = handler_addr;
}

// A Mágica da Fuga Real (sigreturn)
void kernel_sigreturn() {
    struct PCB_Struct *curr;
    curr = &pcb[current_pid];

    curr->in_signal = 0;
    curr->pending_signal = 0;
    
    int orig_sp;
    orig_sp = curr->sig_saved_sp;
    curr->ac = curr->sig_saved_ac;
    
    // Ponteiro Deslizante para escrever na RAM
    int *sp_ptr;
    sp_ptr = &ram[orig_sp];
    
    *sp_ptr = curr->sig_saved_ptr;       sp_ptr = sp_ptr + 1;
    *sp_ptr = curr->sig_saved_idx;       sp_ptr = sp_ptr + 1;
    *sp_ptr = curr->sig_saved_lhs;       sp_ptr = sp_ptr + 1;
    *sp_ptr = curr->sig_saved_val;       sp_ptr = sp_ptr + 1;
    *sp_ptr = curr->sig_saved_left_cond; sp_ptr = sp_ptr + 1;
    *sp_ptr = curr->sig_saved_left;      sp_ptr = sp_ptr + 1;
    *sp_ptr = curr->sig_saved_right;     sp_ptr = sp_ptr + 1;
    *sp_ptr = curr->sig_saved_flags;     sp_ptr = sp_ptr + 1;
    *sp_ptr = curr->saved_pc;
    
    curr->sp = orig_sp;
}

// Permite que o Handler saiba qual sinal o acordou
int kernel_get_signal() {
    return pcb[current_pid].pending_signal;
}

//----------------------------------------------------------------------
// --- Funções de I/O (Ring 0) ---
//----------------------------------------------------------------------
void kernel_print_char(int ascii_code) {
    asm("MOV 0");
    asm("ADD kernel_print_char_ascii_code");
    asm("INT OUT_INT");    // Acesso direto ao hardware liberado!
}

int kernel_read_char() {
    int val;
    asm("MOV 256");        // Porta 1 do teclado
    asm("INT IN_INT");
    asm("STA isr_tmp_ac"); 
    return isr_tmp_ac;
}
