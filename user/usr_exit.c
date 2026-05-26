#ifndef USR_EXIT_C
#define USR_EXIT_C
#include "../user/usr_abi.h"

void exit() {
    asm("MOV 0"); asm("SOP PUSH_OP"); asm("MOV 1"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
    while(1) { asm("MOV 0"); asm("SOP PUSH_OP"); asm("MOV 9"); asm("SOP PUSH_OP"); asm("INT SYSCALL_INT"); }
}

#endif
