#include "../user/usr_printstr.c"
#include "../user/usr_thread.c"
#include "../user/usr_proc.c"

int addr_thread_curta;
int tid;
int i;

void thread_curta() {
    printstr("T-start\n");
    i = 0;
    while (i < 3) {
        printstr("T\n");
        i = i + 1;
        yield();
    }
    printstr("T-exit\n");
    thread_exit();
    printstr("T-ERRO\n");
}

void main() {
    asm("MOV thread_curta"); asm("STA addr_thread_curta");
    tid = thread_create(addr_thread_curta, 4);
    wait(tid);
    printstr("MAIN-ok\n");
    exit();
}
