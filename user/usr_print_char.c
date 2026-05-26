#ifndef USR_PRINT_CHAR_C
#define USR_PRINT_CHAR_C
#include "../user/usr_abi.h"

void print_char(int ascii) {
    asm("LDA print_char_ascii"); asm("SOP PUSH_OP");
    asm("MOV 10"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
}

#endif
