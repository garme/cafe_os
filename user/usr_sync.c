#ifndef USR_SYNC_C
#define USR_SYNC_C
#include "../user/usr_proc.c"

void sem_lock() {
    asm("MOV 0"); asm("SOP PUSH_OP"); asm("MOV 4"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
}

void sem_unlock() {
    asm("MOV 0"); asm("SOP PUSH_OP"); asm("MOV 5"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
}

int sys_mutex_trylock() {
    asm("MOV 0"); asm("SOP PUSH_OP"); asm("MOV 7"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
    asm("STA sys_ret_val");
    return sys_ret_val;
}

void mutex_unlock() {
    asm("MOV 0"); asm("SOP PUSH_OP"); asm("MOV 8"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
}

void mutex_lock() {
    while (sys_mutex_trylock() == 0) { yield(); }
}

#endif
