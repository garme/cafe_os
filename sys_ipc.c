// =======================================================
// sys_ipc.c - Lógica de Retaguarda do Kernel (Ring 0)
// =======================================================

int SEM_STATE = 0; // 0 = Livre, 1 = Ocupado
int MUTEX_ZERO = 0;
int MUTEX_STATE = 0;
int tmp_lock_ret; // Usada em zonas estritamente protegidas (CLI)

//----------------------------------------------------------------------
// --- Utilitários de Acordar Processos ---
//----------------------------------------------------------------------
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
    pcb[current_pid].state = STATE_TERMINATED;
    free(pcb[current_pid].mem_base); 
    wakeup_waiters(current_pid);     
}

void kernel_wait(int target_pid) {
    if (pcb[target_pid].state != STATE_TERMINATED) {
        pcb[current_pid].state = STATE_WAITING;
        pcb[current_pid].waiting_for_pid = target_pid;
    }
}

// Syscall: kill(pid, sinal)
void kernel_kill(int target_pid, int signal) {
    if (pcb[target_pid].state != STATE_TERMINATED) {
        
        if (signal == SIGKILL) {
            // Comportamento antigo: Mata impiedosamente
            pcb[target_pid].state = STATE_TERMINATED;
            free(pcb[target_pid].mem_base);  
            wakeup_waiters(target_pid);
        } else {
            // Apenas entrega a carta (o sinal) na caixa de correio
            pcb[target_pid].pending_signal = signal;
            
            // Se o processo estava PAUSED esperando um sinal, acorda ele!
            if (pcb[target_pid].state == STATE_PAUSED) {
                pcb[target_pid].state = STATE_READY;
            }
        }
    }
}

void kernel_sleep(int ticks_to_sleep) {
    pcb[current_pid].wakeup_tick = system_ticks + ticks_to_sleep;
    pcb[current_pid].state = STATE_SLEEPING;
    // O schedule() no final da syscall vai forçar a troca de contexto
}

void kernel_alarm(int ticks) {
    if (ticks == 0) {
        pcb[current_pid].alarm_tick = 0; // alarm(0) cancela o alarme
    } else {
        pcb[current_pid].alarm_tick = system_ticks + ticks;
    }
}

void kernel_pause() {
    pcb[current_pid].state = STATE_PAUSED;
}

//----------------------------------------------------------------------
// --- Criação do Processo ---
//----------------------------------------------------------------------
void create_process(int pid, int task_addr, int stack_base, int priority, int mem_base) {
    pcb[pid].state = STATE_READY;
    pcb[pid].ac = 0;
    pcb[pid].priority = priority;
    pcb[pid].age = 0;
    pcb[pid].mem_base = mem_base;
    pcb[pid].waiting_for_pid = -1;
    pcb[pid].wakeup_tick = 0;
    pcb[pid].alarm_tick = 0;
    pcb[pid].pending_signal = 0;
    pcb[pid].signal_handler = 0;
    pcb[pid].saved_pc = 0;
    pcb[pid].in_signal = 0;
    
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


//----------------------------------------------------------------------
// --- ROTINAS DE INJEÇÃO DO KERNEL (SIGNALS) ---
//----------------------------------------------------------------------

// Regista a função do utilizador
void kernel_signal(int handler_addr) {
    pcb[current_pid].signal_handler = handler_addr;
}

// A Mágica da Fuga (sigreturn)
void kernel_sigreturn() {
    pcb[current_pid].in_signal = 0;
    pcb[current_pid].pending_signal = 0;
    
    // Quando o usuário chama sigreturn(), o Kernel extraiu o PC 
    // atual (que é o final da função handler) para 'tmp_sys_pc'.
    // Nós DESTRUÍMOS esse PC e o substituímos pelo PC original!
    tmp_sys_pc = pcb[current_pid].saved_pc;
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
