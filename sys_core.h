// Constantes Globais

// --- ESTADOS DE PROCESSOS ---
int STATE_READY      = 0;
int STATE_RUNNING    = 1;
int STATE_BLOCKED    = 2;
int STATE_TERMINATED = 3;
int STATE_WAITING    = 4;
int STATE_SLEEPING   = 5;
int STATE_PAUSED     = 6; 

// --- SINAIS POSIX BÁSICOS ---
int SIGKILL = 9;  // Mata imediatamente (não pode ser ignorado)
int SIGALRM = 14; // O tempo do alarm() acabou
int SIGTERM = 15; // Pedido educado de encerramento
int SIGCONT = 18; // Continua a execução (acorda do pause)

// --- INTERRUPÇÕES
int IN_INT      = 20;  // I/O IN  
int OUT_INT     = 21;  // I/O OUT 
int TIMER_INT   = 22;  // Liga Interrupções (STI)
int CLI_INT     = 23;  // Desliga Interrupções (CLI)
int IRET_INT    = 24;  // Retorno de Interrupções
int HALT_INT    = 25;  // Halt
int SYSCALL_INT = 26;  // Syscall


// --- RELÓGIO DO SISTEMA ---
int system_ticks = 0;

// --- PROCESS CONTROL BLOCK (PCB) ---
struct PCB_Struct {
    // --- CAMPOS BASE DE UMA TAREFA ---
    int state;
    int sp;
    int ac;
    int priority;        // Quanto maior o número, maior a prioridade
    int age;             // Guarda o age da tarefa (Escalonador Prioridade Dinâmica)
    int mem_base;        // Guarda o ponteiro original do malloc para o free()
    
    // --- LÓGICA DE SYSCALLS ---
    int waiting_for_pid; // Guarda o PID de um processo para uso com wait()
    int wakeup_tick;     // Em qual tick este processo deve acordar do sleep()
    int alarm_tick;      // Em qual tick o alarme deve disparar
    int pending_signal;  // Armazena o sinal que o processo recebeu (0 = nenhum)
    
    // --- LÓGICA DE STACK SPOOFING ---
    int signal_handler;  // Endereço da função do usuário (Ring 1)
    int saved_pc;        // Guarda o PC original (Para onde o processo ia)
    int in_signal;       // Flag para impedir que um sinal interrompa outro sinal
};

int MAX_PROCESSES = 2;

// A Tabela de Processos (Array de Structs)
struct PCB_Struct pcb[2];

// Variáveis de Controle
int current_pid;
int *ram;


