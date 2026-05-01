// =======================================================
// sys_ipc.c - Lógica de Retaguarda do Kernel (Ring 0)
// =======================================================

// --- VARIÁVEIS DE CONTEXTO PARA SINCRONIZAÇÂO ---
int SEM_STATE = 0; // 0 = Livre, 1 = Ocupado
int MUTEX_ZERO = 0;
int MUTEX_STATE = 0;
int tmp_lock_ret; // Usada em zonas estritamente protegidas (CLI)

//----------------------------------------------------------------------
// --- IPC: Memória Compartilhada (Shared Memory) ---
//----------------------------------------------------------------------

// Vamos permitir até 5 blocos de memória compartilhada simultâneos
int shm_keys[5];
int shm_addrs[5];
int shm_count = 0;

void init_ipc_shm() {
    int i = 0;
    while(i < 5) {
        shm_keys[i] = 0;
        shm_addrs[i] = 0;
        i = i + 1;
    }
}

// O Handler do Kernel para alocar/recuperar a memória
int kernel_shmget(int key, int size) {
    int i = 0;
    int ptr;
    
    // 1. Busca se a chave já existe
    while(i < shm_count) {
        if (shm_keys[i] == key) {
            return shm_addrs[i]; // Já existe! Devolve o mesmo ponteiro
        }
        i = i + 1;
    }
    
    // 2. Se não existe e tem espaço na tabela, aloca memória nova
    if (shm_count < 5) {
        ptr = malloc(size);
        if (ptr != 0) {
            shm_keys[shm_count] = key;
            shm_addrs[shm_count] = ptr;
            shm_count = shm_count + 1;
            return ptr;
        }
    }
    
    return 0; // Erro: Tabela cheia ou falta de RAM
}


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
    p = &pcb[0]; // Aponta para a base
    
    while(i < MAX_PROCESSES) {
        if (p->state == STATE_WAITING) {
            if (p->waiting_for_pid == dead_pid) {
                p->state = STATE_READY;
                p->waiting_for_pid = -1;
            }
        }
        p = p + 1; // Avança o ponteiro rápido!
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


//----------------------------------------------------------------------
// --- Criação Dinâmica de Processos (Spawn) ---
//----------------------------------------------------------------------
int kernel_spawn(int task_addr, int priority) {
    int i = 0;
    int free_pid = -1;
    int mem;
    
    // 1. Procura um PID livre (Terminado)
    while (i < MAX_PROCESSES && free_pid == -1) {
        if (pcb[i].state == STATE_TERMINATED) {
            free_pid = i;
        }
        i = i + 1;
    }
    
    if (free_pid == -1) {
        return -1; // Erro: Tabela de processos cheia
    }
    
    // 2. Aloca a pilha para o novo processo (40 palavras)
    mem = malloc(40);
    if (mem == 0) {
        return -1; // Erro: Out of Memory no Heap
    }
    
    // 3. Usa a função nativa para montar a pilha do novo processo
    create_process(free_pid, task_addr, mem + 40, priority, mem);
    
    return free_pid; // Retorna o PID do filho para o pai
}

//----------------------------------------------------------------------
// --- IPC: Filas de Mensagens (VERSÃO SIMPLISTA / ESPARTANA) ---
//----------------------------------------------------------------------

int ipc_mailbox[2]; // 0 significa "Vazio"

void init_ipc_mailbox() {
    ipc_mailbox[0] = 0; 
    ipc_mailbox[1] = 0;
}

// Retorna 1 (Sucesso) ou 0 (Caixa cheia/Erro)
int kernel_msg_send(int target_pid, int msg) {
    if (target_pid < 0 || target_pid >= MAX_PROCESSES) { return 0; }
    if (ipc_mailbox[target_pid] != 0) { return 0; }
    
    ipc_mailbox[target_pid] = msg;
    return 1;
}

// Retorna o valor lido ou 0 se a caixa estiver vazia
int kernel_msg_recv() {
    int msg;
    msg = ipc_mailbox[current_pid];
    
    if (msg == 0) {
        return 0; // Vazia
    }
    
    ipc_mailbox[current_pid] = 0; // Esvazia a caixa
    return msg;
}
