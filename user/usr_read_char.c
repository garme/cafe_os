#ifndef USR_READ_CHAR_C
#define USR_READ_CHAR_C
#include "../user/usr_abi.h"

int sys_ret_val;

int read_char() {
    asm("MOV 0"); asm("SOP PUSH_OP"); asm("MOV 11"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
    asm("STA sys_ret_val");
    return sys_ret_val;
}

#endif
