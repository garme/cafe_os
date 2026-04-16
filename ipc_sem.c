// =======================================================
// ipc_sem.c - Sincronização com Bloqueio de Processos
// =======================================================

int SEM_ZERO = 0;
int SEM_STATE = 0;
int tmp_lock_ret; 

// --- FUNÇÕES DE KERNEL PARA GESTÃO DE ESTADOS ---

void block_me() {
    // Tira o processo atual da fila de execução
    pcb[current_pid].state = STATE_BLOCKED;
}

void wakeup_all() {
    int i;
    i = 0;
    // Procura na tabela do PCB quem estava a dormir e acorda-os
    while(i < MAX_PROCESSES) {
        if (pcb[i].state == STATE_BLOCKED) {
            pcb[i].state = STATE_READY;
        }
        i = i + 1;
    }
}

// --- FUNÇÕES DE USER SPACE (NAKED) ---

naked void lock_sem() {
    asm("lock_spin:");
    asm("INT CLI_INT");         // Tranca a porta para não ser interrompido

    asm("SOP pop");
    asm("STA tmp_lock_ret");

    asm("LDA SEM_STATE");
    asm("SUB SEM_ZERO");
    asm("JZ lock_get");

    // ==============================================
    // SE ESTÁ OCUPADO: O PROCESSO VAI DORMIR
    // ==============================================
    asm("LDA tmp_lock_ret");
    asm("SOP push");            // Devolve endereço de retorno
    
    asm("CALL block_me");       // 1. Muda estado para BLOCKED
    asm("SOP pop");
    
    asm("INT TIMER_INT");       // 2. Abre a porta para o Hardware Timer atuar
    asm("JMP lock_spin");       // 3. Fica aqui. Como está BLOCKED, o escalonador vai saltá-lo!

    // ==============================================
    // SE ESTÁ LIVRE: TRANCA O MUTEX
    // ==============================================
    asm("lock_get:");
    asm("MOV 1");
    asm("STA SEM_STATE");

    asm("MOV 0");
    asm("SOP push");
    asm("LDA tmp_lock_ret");
    asm("SOP push");

    asm("INT TIMER_INT");       
    asm("RET");                 
}

naked void unlock_sem() {
    asm("INT CLI_INT");         

    asm("SOP pop");
    asm("STA tmp_lock_ret");

    asm("MOV 0");
    asm("STA SEM_STATE");    // 1. Liberta o Mutex!

    asm("CALL wakeup_all");     // 2. ACORDA OS PROCESSOS BLOQUEADOS!
    asm("SOP pop");

    asm("MOV 0");
    asm("SOP push");
    asm("LDA tmp_lock_ret");
    asm("SOP push");

    asm("INT TIMER_INT");
    asm("RET");
}
