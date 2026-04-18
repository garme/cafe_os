// =======================================================
// sys_ipc.c - Lógica de Retaguarda do Kernel (Ring 0)
// =======================================================

int SEM_STATE = 0; // 0 = Livre, 1 = Ocupado
int MUTEX_ZERO = 0;
int MUTEX_STATE = 0;
int tmp_lock_ret; // Usada em zonas estritamente protegidas (CLI)


// --- Utilitários de Acordar Processos ---
void wakeup_waiters(int dead_pid) {
    int i;
    i = 0;
    while(i < MAX_PROCESSES) {
        if (pcb[i].state == STATE_WAITING) {
            if (pcb[i].waiting_for_pid == dead_pid) {
                pcb[i].state = STATE_READY;
                pcb[i].waiting_for_pid = -1;
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


// --- 1. LÓGICA DO SEMÁFORO (BLOQUEIO) ---
void kernel_sem_lock() {
    if (SEM_STATE == 0) {
        SEM_STATE = 1; // Pega a tranca imediatamente
    } else {
        // A mágica: Adormece o processo! O escalonador fará o resto.
        pcb[current_pid].state = STATE_BLOCKED;
    }
}

void kernel_sem_unlock() {
    SEM_STATE = 0;
    wakeup_all(); // Acorda todos para que tentem pegar a tranca novamente
}

// --- 2. LÓGICA DO MUTEX / SPINLOCK (ESPERA OCUPADA) ---
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

// --- Handlers das Chamadas de Sistema ---
void kernel_exit() {
    pcb[current_pid].state = STATE_TERMINATED;
    free(pcb[current_pid].mem_base); 
    wakeup_waiters(current_pid);     
}

void kernel_kill(int target_pid) {
    if (pcb[target_pid].state != STATE_TERMINATED) {
        pcb[target_pid].state = STATE_TERMINATED;
        free(pcb[target_pid].mem_base);  
        wakeup_waiters(target_pid);      
    }
}

void kernel_wait(int target_pid) {
    if (pcb[target_pid].state != STATE_TERMINATED) {
        pcb[current_pid].state = STATE_WAITING;
        pcb[current_pid].waiting_for_pid = target_pid;
    }
}

int kernel_lock_sem() {
    if (SEM_STATE == 0) {
        SEM_STATE = 1; // Ocupa a tranca
        return 1;      // Diz ao User Space: Sucesso!
    } else {
        pcb[current_pid].state = STATE_BLOCKED;
        return 0;      // Diz ao User Space: Bloqueado (Tenta novamente mais tarde)
    }
}

void kernel_unlock_sem() {
    SEM_STATE = 0;
    wakeup_all(); // Acorda todos para disputarem a tranca
}

void kernel_print_space() {
    // O Kernel tem privilégios para falar com o hardware (OUT_INT)
    asm("MOV 32"); 
    asm("INT OUT_INT");
}

// --- Criação do Processo ---
void create_process(int pid, int task_addr, int stack_base, int priority, int mem_base) {
    pcb[pid].state = STATE_READY;
    pcb[pid].ac = 0;
    pcb[pid].priority = priority; 
    pcb[pid].mem_base = mem_base;
    pcb[pid].waiting_for_pid = -1;
    
    ram[stack_base - 1] = task_addr; 
    ram[stack_base - 2] = 8;  // Flag 8 (Bit 3) = RING 1 (USER MODE)
    ram[stack_base - 3] = 0; 
    ram[stack_base - 4] = 0; 
    ram[stack_base - 5] = 0; 
    ram[stack_base - 6] = 0; 
    ram[stack_base - 7] = 0; 
    ram[stack_base - 8] = 0; 
    ram[stack_base - 9] = 0; 
    
    pcb[pid].sp = stack_base - 9;   
}

// --- Funções de I/O (Ring 0) ---

void kernel_print_char(int ascii_code) {
    asm("LDA ascii_code");
    asm("INT OUT_INT");    // Acesso direto ao hardware liberado!
}

int kernel_read_char() {
    int val;
    asm("MOV 256");        // Porta 1 do teclado
    asm("INT IN_INT");
    asm("STA val");
    return val;
}
