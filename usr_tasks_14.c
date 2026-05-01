#include "usr_syscalls.c"

int child_pid;
int msg_valor;
int rodando;

naked void task_b() {
    rodando = 1;

    while(rodando == 1) {
        msg_valor = msg_recv(); // Leitura simplificada

        if (msg_valor != 0) {
            sem_lock();
            print_char('B'); 
            print_char(':'); 
            printint(msg_valor);
            print_char(10);  
            sem_unlock();

            if (msg_valor == 99) {
                rodando = 0; 
            }
        } else {
            yield(); 
        }
    }
    
    exit();
}

naked void task_a() {
    asm("MOV task_b");
    asm("STA addr_task_b");

    child_pid = spawn(addr_task_b, 4);

    if (child_pid != -1) {
        sleep(2);
        msg_send(child_pid, 250); // Envia o dado direto
        
        sleep(2); 
        msg_send(child_pid, 500);
        
        sleep(2); 
        msg_send(child_pid, 99); // Comando de parada

        wait(child_pid);
    }

    exit();
}
