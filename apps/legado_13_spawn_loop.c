#include "../user/usr_printstr.c"
#include "../user/usr_sync.c"

int child_pid;
int contador;
int addr_task_b;

naked void task_b() {
    sem_lock();
    printstr("B\n");
    sem_unlock();
    sleep(2);
    exit();
}

void main() {
    asm("MOV task_b");
    asm("STA addr_task_b");
    contador = 0;

    while(contador < 10) {
        sem_lock();
        printstr("A->B\n");
        sem_unlock();

        child_pid = spawn(addr_task_b, 4);
        if (child_pid != -1) {
            wait(child_pid);
            sem_lock();
            printstr("Bx\n");
            sem_unlock();
        } else {
            sem_lock();
            printstr("xB\n");
            sem_unlock();
        }
        contador = contador + 1;
    }

    printstr("Ax\n");
    exit();
}
