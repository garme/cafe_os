#ifndef SYS_SIGNAL_C
#define SYS_SIGNAL_C

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


#endif
