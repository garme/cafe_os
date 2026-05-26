#include "../user/usr_printstr.c"
#include "../user/usr_printint.c"
#include "../user/usr_sync.c"

int child_pid;
int addr_task_b;

naked void task_b() {
    sem_lock();
    printstr("BS\n");
    sem_unlock();
    sleep(2);
    sem_lock();
    printstr("BX\n");
    sem_unlock();
    exit();
}

void main() {
    asm("MOV task_b");
    asm("STA addr_task_b");

    printstr("AS\n");
    child_pid = spawn(addr_task_b, 4);

    if (child_pid != -1) {
        sem_lock();
        printstr("A");
        printint(child_pid);
        printstr("\n");
        sem_unlock();
        wait(child_pid);
        printstr("AW\n");
    } else {
        printstr("PCB*\n");
    }

    printstr("AX\n");
    exit();
}
