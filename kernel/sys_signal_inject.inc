#ifndef SYS_SIGNAL_INJECT_INC
#define SYS_SIGNAL_INJECT_INC

// Fallback completo. Kernel+Overlay substitui por versão vazia quando sinais não são usados.
void kernel_signal_inject(struct PCB_Struct *curr, int target_sp) {
    int *sp_ptr;

    if (curr->pending_signal > 0) {
        if (curr->signal_handler != 0) {
            if (curr->in_signal == 0) {
                curr->sig_saved_sp = target_sp;
                curr->sig_saved_ac = curr->ac;

                sp_ptr = &ram[target_sp];

                curr->sig_saved_step      = *sp_ptr; sp_ptr = sp_ptr + 1;
                curr->sig_saved_arr_base  = *sp_ptr; sp_ptr = sp_ptr + 1;
                curr->sig_saved_right     = *sp_ptr; sp_ptr = sp_ptr + 1;
                curr->sig_saved_left      = *sp_ptr; sp_ptr = sp_ptr + 1;
                curr->sig_saved_left_cond = *sp_ptr; sp_ptr = sp_ptr + 1;
                curr->sig_saved_val       = *sp_ptr; sp_ptr = sp_ptr + 1;
                curr->sig_saved_lhs       = *sp_ptr; sp_ptr = sp_ptr + 1;
                curr->sig_saved_idx       = *sp_ptr; sp_ptr = sp_ptr + 1;
                curr->sig_saved_ptr       = *sp_ptr; sp_ptr = sp_ptr + 1;

                curr->sig_saved_flags = *sp_ptr;     sp_ptr = sp_ptr + 1;
                curr->saved_pc = *sp_ptr;
                *sp_ptr = curr->signal_handler;
                curr->in_signal = 1;
            }
        }
    }
}

#endif
