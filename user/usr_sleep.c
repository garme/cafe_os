#ifndef USR_SLEEP_C
#define USR_SLEEP_C
#include "../user/usr_abi.h"

void sleep(int ticks) {
    asm("LDA sleep_ticks"); asm("SOP PUSH_OP"); asm("MOV 12"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
}

#endif
