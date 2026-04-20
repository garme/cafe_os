// Constantes Globais
int STATE_READY      = 0;
int STATE_RUNNING    = 1;
int STATE_BLOCKED    = 2;
int STATE_TERMINATED = 3;
int STATE_WAITING    = 4;

int MAX_PROCESSES = 2;

int IN_INT      = 20;  // I/O IN  
int OUT_INT     = 21;  // I/O OUT 
int TIMER_INT   = 22;  // Liga Interrupções (STI)
int CLI_INT     = 23;  // Desliga Interrupções (CLI)
int IRET_INT    = 24;  // Retorno de Interrupções
int HALT_INT    = 25;  // Halt
int SYSCALL_INT = 26;  // Syscall

// A Estrutura do Process Control Block (PCB)
struct PCB_Struct {
    int state;
    int sp;
    int ac;
    int priority;        // Quanto maior o número, maior a prioridade
    int age;             // Guarda o age da tarefa (Escalonador Prioridade Dinâmica)
    int mem_base;        // Guarda o ponteiro original do malloc para o free()
    int waiting_for_pid; // Guarda o PID de um processo para uso com wait()
};

// A Tabela de Processos (Array de Structs)
struct PCB_Struct pcb[2];

// Variáveis de Controle
int current_pid;
int *ram;


