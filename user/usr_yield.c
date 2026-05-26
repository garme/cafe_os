#ifndef USR_YIELD_C
#define USR_YIELD_C
#include "../user/usr_abi.h"

void yield() {
    asm("MOV 0"); asm("SOP PUSH_OP"); asm("MOV 9"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
}

#endif
