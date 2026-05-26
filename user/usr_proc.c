#ifndef USR_PROC_C
#define USR_PROC_C
#include "../user/usr_runtime.c"

// Gestão de ciclo de vida de tarefas/processos
void yield() {
    asm("MOV 0"); asm("SOP PUSH_OP"); asm("MOV 9"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
}

void exit() {
    asm("MOV 0"); asm("SOP PUSH_OP"); asm("MOV 1"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
    while(1) { yield(); }
}

void wait(int pid) {
    asm("LDA wait_pid"); asm("SOP PUSH_OP"); asm("MOV 2"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
}

void kill(int pid, int signal) {
    asm("LDA kill_signal"); asm("SOP PUSH_OP");
    asm("LDA kill_pid"); asm("SOP PUSH_OP");
    asm("MOV 3"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
}

void sleep(int ticks) {
    asm("LDA sleep_ticks"); asm("SOP PUSH_OP"); asm("MOV 12"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
}

void alarm(int ticks) {
    asm("LDA alarm_ticks"); asm("SOP PUSH_OP"); asm("MOV 13"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
}

void pause() {
    asm("MOV 0"); asm("SOP PUSH_OP"); asm("MOV 14"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
}

// Spawn legado por endereço de função dentro do mesmo segmento de código.
int spawn(int task_addr, int priority) {
    asm("LDA spawn_priority");  asm("SOP PUSH_OP");
    asm("LDA spawn_task_addr"); asm("SOP PUSH_OP");
    asm("MOV 6");               asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
    asm("STA sys_ret_val");
    return sys_ret_val;
}

#endif
