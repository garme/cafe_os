#ifndef USR_MSG_C
#define USR_MSG_C
#include "../user/usr_runtime.c"

int msg_send(int target_pid, int msg) {
    asm("LDA msg_send_msg");        asm("SOP PUSH_OP");
    asm("LDA msg_send_target_pid"); asm("SOP PUSH_OP");
    asm("MOV 27");                  asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
    asm("STA sys_ret_val");
    return sys_ret_val;
}

int msg_recv() {
    asm("MOV 0");  asm("SOP PUSH_OP");
    asm("MOV 28"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
    asm("STA sys_ret_val");
    return sys_ret_val;
}

#endif
