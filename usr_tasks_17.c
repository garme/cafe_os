#include "usr_syscalls.c"

int t1;
int t2;
int addr_produtor;
int addr_consumidor;

// Variáveis Globais Compartilhadas
int buffer_teclado;
int buffer_cheio;

// ==========================================
// TAREFA 1: PRODUTOR (Lê do Teclado)
// ==========================================
void thread_produtor() {
    int c;
    
    while(1) {
        c = read_char(); // Lê hardware
        
        if (c != 0) { // Se o usuário digitou alguma coisa
            
            // Espera ocupada ecológica: Aguarda o consumidor ler o dado anterior
            while (buffer_cheio == 1) {
                yield(); 
            }
            
            // Entra na Região Crítica
            sem_lock();
            buffer_teclado = c; // Produz o dado
            buffer_cheio = 1;   // Avisa que tem dado fresco
            sem_unlock();
            
        } else {
            // Se não digitou nada, não prende a CPU atoa
            yield(); 
        }
    }
}

// ==========================================
// TAREFA 2: CONSUMIDOR (Imprime na Tela)
// ==========================================
void thread_consumidor() {
    int c;
    
    while(1) {
        // Espera ocupada ecológica: Aguarda o produtor colocar um dado
        while (buffer_cheio == 0) {
            yield();
        }
        
        // Entra na Região Crítica
        sem_lock();
        c = buffer_teclado; // Consome o dado
        buffer_cheio = 0;   // Libera o espaço para o produtor
        sem_unlock();
        
        // Imprime o dado consumido
        print_char(c);
    }
}

// ==========================================
// PROCESSO PAI (Inicializador)
// ==========================================
naked void task_a() {

    // Estado inicial
    buffer_cheio = 0;
    buffer_teclado = 0;

    printstr("P-C\n");
    printstr(": ");

    // Captura os endereços das threads
    asm("MOV thread_produtor"); asm("STA addr_produtor");
    asm("MOV thread_consumidor"); asm("STA addr_consumidor");

    // Cria as duas threads dentro do mesmo processo (Pai)
    t1 = thread_create(addr_produtor, 4);
    t2 = thread_create(addr_consumidor, 4);

    // O pai apenas espera (Embora elas rodem em loop infinito neste exemplo)
    wait(t1);
    wait(t2);
    exit();
}
