// =======================================================
// ipc_mutex.c - Gerenciador de Sincronização (Spinlocks)
// =======================================================

int MUTEX_ZERO = 0;
int MUTEX_STATE = 0;
int tmp_lock_ret; // Usada em zonas estritamente protegidas (CLI)

naked void lock_mutex() {
    asm("lock_spin:");
    asm("INT CLI_INT");         // 1. TRANCA A PORTA IMEDIATAMENTE!

    // 2. Com as interrupções desligadas, é seguro usar a global
    asm("SOP pop");
    asm("STA tmp_lock_ret");

    // 3. Verifica o Mutex
    asm("LDA MUTEX_STATE");
    asm("SUB MUTEX_ZERO");
    asm("JZ lock_get");

    // 4. SE ESTÁ OCUPADO: Devolve o endereço intacto para a pilha!
    asm("LDA tmp_lock_ret");
    asm("SOP push");
    asm("INT TIMER_INT");       // Abre a porta para o SO respirar
    asm("JMP lock_spin");       // Tenta novamente

    // 5. SE ESTÁ LIVRE: Tranca!
    asm("lock_get:");
    asm("MOV 1");
    asm("STA MUTEX_STATE");

    // 6. Prepara o retorno C (Pilha: [0 Dummy, Endereço de Retorno])
    asm("MOV 0");
    asm("SOP push");
    asm("LDA tmp_lock_ret");
    asm("SOP push");

    asm("INT TIMER_INT");       // Abre a porta
    asm("RET");                 // Volta para a tarefa!
}

naked void unlock_mutex() {
    asm("INT CLI_INT");         // Tranca a porta IMEDIATAMENTE!

    asm("SOP pop");
    asm("STA tmp_lock_ret");

    asm("MOV 0");
    asm("STA MUTEX_STATE");    // Liberta o Mutex!

    asm("MOV 0");
    asm("SOP push");
    asm("LDA tmp_lock_ret");
    asm("SOP push");

    asm("INT TIMER_INT");
    asm("RET");
}
