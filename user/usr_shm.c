#ifndef USR_SHM_C
#define USR_SHM_C
#include "../user/usr_runtime.c"

int shmget(int key, int size) {
    asm("LDA shmget_size"); asm("SOP PUSH_OP");
    asm("LDA shmget_key");  asm("SOP PUSH_OP");
    asm("MOV 25");          asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
    asm("STA sys_ret_val");
    return sys_ret_val;
}

#endif
