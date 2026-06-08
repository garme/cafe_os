// Constantes Globais

// --- ESTADOS DE PROCESSOS ---
int STATE_READY      = 0;
int STATE_RUNNING    = 1;
int STATE_BLOCKED    = 2;
int STATE_TERMINATED = 3;
int STATE_WAITING    = 4;
int STATE_SLEEPING   = 5;
int STATE_PAUSED     = 6;
int STATE_WAITING_PIPE_READ  = 7;
int STATE_WAITING_PIPE_WRITE = 8;

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
int CTXSW_INT   = 27;  // Troca atômica de contexto segmentado

// --- BASES DOS SEGMENTOS DO KERNEL ---
int KERNEL_CS = 0;
int KERNEL_DS = 4096;
int KERNEL_SS = 4096;

// --- PERFIL DE MEMÓRIA / CAPACIDADE ---
// Mantém o perfil arquitetural: 4K para código e 4K para dados+pilhas.
// Máximo de tarefas simultâneas: processo principal + até 2 filhos/threads.
int MAX_PROCESSES = 3;
int TASK_STACK_WORDS = 64;

// --- RELÓGIO DO SISTEMA ---
int system_ticks = 0;

// Flag usada para evitar schedule() em syscalls leves.
// Syscalls que bloqueiam, finalizam ou cedem CPU colocam esse valor em 1.
int kernel_need_resched = 0;

// --- PROCESS CONTROL BLOCK (PCB) ---
struct PCB_Struct {
    // --- CAMPOS BASE DE UMA TAREFA ---
    int state;
    int sp;
    int ac;
    int pc;              // PC lógico da tarefa
    int cs;              // Base física do segmento de código
    int ds;              // Base física do segmento de dados do overlay
    int ss;              // Base física da pilha
    int priority;        // Quanto maior o número, maior a prioridade
    int age;             // Guarda o age da tarefa (Escalonador Prioridade Dinâmica)

    // mem_base é o offset lógico do início da área .data vista pela tarefa.
    // Em overlay in-place, aponta para a imagem injetada no .data do kernel.
    // Em spawn() com clone, aponta para um bloco privado alocado no heap.
    // Em thread_create(), é herdado do pai.
    int mem_base;

    // Quantas palavras da área .data pertencem ao domínio da tarefa.
    // spawn() usa esse tamanho para clonar a .data do pai.
    int data_size;

    // 1 quando mem_base veio de malloc() e deve ser liberado quando o
    // último processo/thread que compartilha esse domínio terminar.
    // 0 quando mem_base aponta para a imagem in-place do overlay.
    int data_is_heap;

    // stack_mem é sempre o ponteiro real devolvido por malloc() para a pilha
    // desta tarefa. É esse bloco que deve ser liberado em exit()/kill().
    int stack_mem;

    // 0 = processo lógico; 1 = thread leve criada por thread_create().
    int is_thread;

    // --- LÓGICA DE SYSCALLS ---
    int waiting_for_pid; // Guarda o PID de um processo para uso com wait()
    int wakeup_tick;     // Em qual tick este processo deve acordar do sleep()
    int alarm_tick;      // Em qual tick o alarme deve disparar
    int pending_signal;  // Armazena o sinal que o processo recebeu (0 = nenhum)

    // --- LÓGICA DE STACK SPOOFING ---
    int signal_handler;  // Endereço da função do usuário (Ring 1)
    int saved_pc;        // Guarda o PC original (Para onde o processo ia)
    int in_signal;       // Flag para impedir que um sinal interrompa outro sinal

    // --- CONTEXTO SALVO PARA SINAIS ---
    int sig_saved_sp;
    int sig_saved_ac;
    int sig_saved_ptr;
    int sig_saved_idx;
    int sig_saved_lhs;
    int sig_saved_val;
    int sig_saved_left_cond;
    int sig_saved_left;
    int sig_saved_right;
    int sig_saved_flags;
    int sig_saved_arr_base;
    int sig_saved_step;
};

// A Tabela de Processos (Array de Structs)
struct PCB_Struct pcb[3];

// Variáveis de Controle
int current_pid;
struct PCB_Struct *curr_pcb;    // Cache da PCB
int *ram;
