#ifndef SYS_SIGNAL_C
#define SYS_SIGNAL_C

void kernel_signal(int handler_addr) {
    curr_pcb->signal_handler = handler_addr;
}

void kernel_sigreturn() {
    struct PCB_Struct *curr;
    int orig_sp;
    int *sp_ptr;

    curr = &pcb[current_pid];
    curr->in_signal = 0;
    curr->pending_signal = 0;
    orig_sp = curr->sig_saved_sp;
    curr->ac = curr->sig_saved_ac;

    // Restaura exatamente o frame esperado por dispatcher_restore_context:
    // tmp_step, tmp_arr_base, tmp_right, tmp_left, tmp_left_cond,
    // tmp_val, tmp_lhs, tmp_idx, tmp_ptr, flags, pc.
    sp_ptr = &ram[orig_sp];
    *sp_ptr = curr->sig_saved_step;      sp_ptr = sp_ptr + 1;
    *sp_ptr = curr->sig_saved_arr_base;  sp_ptr = sp_ptr + 1;
    *sp_ptr = curr->sig_saved_right;     sp_ptr = sp_ptr + 1;
    *sp_ptr = curr->sig_saved_left;      sp_ptr = sp_ptr + 1;
    *sp_ptr = curr->sig_saved_left_cond; sp_ptr = sp_ptr + 1;
    *sp_ptr = curr->sig_saved_val;       sp_ptr = sp_ptr + 1;
    *sp_ptr = curr->sig_saved_lhs;       sp_ptr = sp_ptr + 1;
    *sp_ptr = curr->sig_saved_idx;       sp_ptr = sp_ptr + 1;
    *sp_ptr = curr->sig_saved_ptr;       sp_ptr = sp_ptr + 1;
    *sp_ptr = curr->sig_saved_flags;     sp_ptr = sp_ptr + 1;
    *sp_ptr = curr->saved_pc;

    curr->sp = orig_sp;
}

int kernel_get_signal() {
    return pcb[current_pid].pending_signal;
}

#endif
