// Constantes Globais
int STATE_READY   = 0;
int STATE_RUNNING = 1;
int STATE_BLOCKED = 2;
int STATE_TERMINATED = 3;

int MAX_PROCESSES = 2;

int IN_INT = 20;
int OUT_INT = 21;
int TIMER_INT = 22;  // Liga Interrupções (STI)
int CLI_INT = 23;    // Desliga Interrupções (CLI)
int IRET_INT = 24;   // Retorno de Interrupções

// A Estrutura do Process Control Block (PCB)
struct PCB_Struct {
    int state;
    int sp;
    int ac;
    int priority;       // Quanto maior o número, maior a prioridade
    int base_priority;  // A prioridade original (para o reset)
    int mem_base;       // Guarda o ponteiro original do malloc para o free()
};

// A Tabela de Processos (Array de Structs)
struct PCB_Struct pcb[2];

// Variáveis de Controle
int current_pid;
int *ram;


