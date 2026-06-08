#ifndef SYS_DISPATCH_INC
#define SYS_DISPATCH_INC

// Fallback para compilação Kernel isolada: dispatcher completo.
// No modo Kernel+Overlay, a IDE substitui este arquivo por uma versão seletiva em memória.
void kernel_dispatch_syscall() {
    if (tmp_sys_id == 1) { kernel_exit(); }
    if (tmp_sys_id == 2) { kernel_wait(tmp_sys_arg); }
    if (tmp_sys_id == 3) { kernel_kill(tmp_sys_arg, tmp_sys_arg2); }
    if (tmp_sys_id == 4) { kernel_sem_lock(); }
    if (tmp_sys_id == 5) { kernel_sem_unlock(); }
    if (tmp_sys_id == 6) {
        isr_tmp_ac = kernel_spawn(tmp_sys_arg, tmp_sys_arg2);
        curr_pcb->ac = isr_tmp_ac;
    }
    if (tmp_sys_id == 7) {
        isr_tmp_ac = kernel_mutex_trylock();
        curr_pcb->ac = isr_tmp_ac;
    }
    if (tmp_sys_id == 8) { kernel_mutex_unlock(); }
    if (tmp_sys_id == 9) { kernel_need_resched = 1; }
    if (tmp_sys_id == 10) { kernel_print_char(tmp_sys_arg); }
    if (tmp_sys_id == 11) {
        isr_tmp_ac = kernel_read_char();
        curr_pcb->ac = isr_tmp_ac;
    }
    if (tmp_sys_id == 12) { kernel_sleep(tmp_sys_arg); }
    if (tmp_sys_id == 13) { kernel_alarm(tmp_sys_arg); }
    if (tmp_sys_id == 14) { kernel_pause(); }
    if (tmp_sys_id == 15) { kernel_signal(tmp_sys_arg); }
    if (tmp_sys_id == 16) { kernel_sigreturn(); }
    if (tmp_sys_id == 17) {
        isr_tmp_ac = kernel_get_signal();
        curr_pcb->ac = isr_tmp_ac;
    }
    if (tmp_sys_id == 20) {
        isr_tmp_ac = kernel_write_pipe(tmp_sys_arg);
        curr_pcb->ac = isr_tmp_ac;
    }
    if (tmp_sys_id == 21) {
        isr_tmp_ac = kernel_read_pipe();
        curr_pcb->ac = isr_tmp_ac;
    }
    if (tmp_sys_id == 25) {
        isr_tmp_ac = kernel_shmget(tmp_sys_arg, tmp_sys_arg2);
        curr_pcb->ac = isr_tmp_ac;
    }
    if (tmp_sys_id == 27) {
        isr_tmp_ac = kernel_msg_send(tmp_sys_arg, tmp_sys_arg2);
        curr_pcb->ac = isr_tmp_ac;
    }
    if (tmp_sys_id == 28) {
        isr_tmp_ac = kernel_msg_recv();
        curr_pcb->ac = isr_tmp_ac;
    }
    if (tmp_sys_id == 29) {
        isr_tmp_ac = kernel_thread_create(tmp_sys_arg, tmp_sys_arg2);
        curr_pcb->ac = isr_tmp_ac;
    }
    if (tmp_sys_id == 30) {
        isr_tmp_ac = kernel_thread_exit();
        curr_pcb->ac = isr_tmp_ac;
    }
}

#endif
