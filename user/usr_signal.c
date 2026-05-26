#ifndef USR_SIGNAL_C
#define USR_SIGNAL_C
#include "../user/usr_runtime.c"

void signal(int * handler_addr) {
    asm("LDA signal_handler_addr"); asm("SOP PUSH_OP");
    asm("MOV 15"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
}

void sigreturn() {
    asm("MOV 0"); asm("SOP PUSH_OP");
    asm("MOV 16"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
}

int get_signal() {
    asm("MOV 0"); asm("SOP PUSH_OP");
    asm("MOV 17"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
    asm("STA sys_ret_val");
    return sys_ret_val;
}

#endif
