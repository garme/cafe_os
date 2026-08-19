#ifndef USR_FS_SHELL_MIN_C
#define USR_FS_SHELL_MIN_C

#include "../user/usr_runtime.c"

/*
 * API mínima exclusiva do shell.
 * Syscalls:
 *   33 = fs_out
 *   35 = fs_exec
 *
 * O shell não lê portas do FS; apenas monta, limpa TX,
 * envia o caminho e solicita execução.
 */

int fs_shell_out(int w) {
    asm("LDA fs_shell_out_w");
    asm("SOP PUSH_OP");
    asm("MOV 33");
    asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
    asm("STA sys_ret_val");
    return sys_ret_val;
}

void fs_shell_mount() {
    fs_shell_out(16386);
}

void fs_shell_begin_exec() {
    fs_shell_out(16387);
}

void fs_shell_put(int c) {
    fs_shell_out(17408 + c);
}

int fs_shell_exec(int priority) {
    asm("LDA fs_shell_exec_priority");
    asm("SOP PUSH_OP");
    asm("MOV 35");
    asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
    asm("STA sys_ret_val");
    return sys_ret_val;
}

#endif
