#ifndef USR_THREAD_C
#define USR_THREAD_C
#include "../user/usr_runtime.c"

int thread_create(int task_addr, int priority) {
    asm("LDA thread_create_priority");  asm("SOP PUSH_OP");
    asm("LDA thread_create_task_addr"); asm("SOP PUSH_OP");
    asm("MOV 29");                      asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
    asm("STA sys_ret_val");
    return sys_ret_val;
}

#endif
