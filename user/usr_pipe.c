#ifndef USR_PIPE_C
#define USR_PIPE_C
#include "../user/usr_runtime.c"

int write_pipe(int val) {
    int success;
    success = 0;
    while(success == 0) {
        asm("LDA write_pipe_val"); asm("SOP PUSH_OP");
        asm("MOV 20"); asm("SOP PUSH_OP");
        asm("INT SYSCALL_INT");
        asm("STA sys_ret_val");
        success = sys_ret_val;
    }
    return success;
}

int read_pipe() {
    int val;
    val = -1;
    while(val == -1) {
        asm("MOV 0"); asm("SOP PUSH_OP");
        asm("MOV 21"); asm("SOP PUSH_OP");
        asm("INT SYSCALL_INT");
        asm("STA sys_ret_val");
        val = sys_ret_val;
    }
    return val;
}

#endif
