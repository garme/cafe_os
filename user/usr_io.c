#ifndef USR_IO_C
#define USR_IO_C
#include "../user/usr_runtime.c"

void print_char(int ascii) {
    asm("LDA print_char_ascii"); asm("SOP PUSH_OP");
    asm("MOV 10"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
}

int read_char() {
    asm("MOV 0"); asm("SOP PUSH_OP"); asm("MOV 11"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
    asm("STA sys_ret_val");
    return sys_ret_val;
}

#endif
