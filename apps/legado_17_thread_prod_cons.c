#include "../user/usr_printstr.c"
#include "../user/usr_print_char.c"
#include "../user/usr_read_char.c"
#include "../user/usr_sync.c"
#include "../user/usr_thread.c"

int t1;
int t2;
int addr_produtor;
int addr_consumidor;
int buffer_teclado;
int buffer_cheio;

void thread_produtor() {
    int c;
    while(1) {
        c = read_char();
        if (c != 0) {
            while (buffer_cheio == 1) {
                yield();
            }
            sem_lock();
            buffer_teclado = c;
            buffer_cheio = 1;
            sem_unlock();
        } else {
            yield();
        }
    }
}

void thread_consumidor() {
    int c;
    while(1) {
        while (buffer_cheio == 0) {
            yield();
        }
        sem_lock();
        c = buffer_teclado;
        buffer_cheio = 0;
        sem_unlock();
        print_char(c);
    }
}

void main() {
    buffer_cheio = 0;
    buffer_teclado = 0;
    printstr("P-C\n");
    printstr(": ");

    asm("MOV thread_produtor"); asm("STA addr_produtor");
    asm("MOV thread_consumidor"); asm("STA addr_consumidor");
    t1 = thread_create(addr_produtor, 4);
    t2 = thread_create(addr_consumidor, 4);
    wait(t1);
    wait(t2);
    exit();
}
