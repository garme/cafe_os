// Constantes globais do CAFE OS / GUILIX

// --- ESTADOS DE PROCESSOS ---
int STATE_READY = 0;
int STATE_RUNNING = 1;
int STATE_BLOCKED = 2;
int STATE_TERMINATED = 3;
int STATE_WAITING = 4;
int STATE_SLEEPING = 5;
int STATE_PAUSED = 6;
int STATE_WAITING_PIPE_READ = 7;
int STATE_WAITING_PIPE_WRITE = 8;

// --- SINAIS POSIX BÁSICOS ---
int SIGKILL = 9;
int SIGALRM = 14;
int SIGTERM = 15;
int SIGCONT = 18;

// --- INTERRUPÇÕES DA CARIRI ---
int IN_INT = 20;
int OUT_INT = 21;
int TIMER_INT = 22;
int CLI_INT = 23;
int IRET_INT = 24;
int HALT_INT = 25;
int SYSCALL_INT = 26;
int CTXSW_INT = 27;

// --- BASES DOS SEGMENTOS DO KERNEL ---
int KERNEL_CS = 0;
int KERNEL_DS = 4096;
int KERNEL_SS = 4096;

// --- PERFIL 4K + 4K ---
int MAX_PROCESSES = 3;
int TASK_STACK_WORDS = 64;
int system_ticks = 0;

// Evita reescalonamento desnecessário em syscalls leves.
int kernel_need_resched = 0;

struct PCB_Struct {
    int state;
    int sp;
    int ac;
    int pc;
    int cs;
    int ds;
    int ss;
    int priority;
    int age;

    // Domínio de dados e propriedade de recursos.
    int mem_base;
    int data_size;
    int data_is_heap;
    int stack_mem;
    int is_thread;

    int waiting_for_pid;
    int wakeup_tick;
    int alarm_tick;
    int pending_signal;

    int signal_handler;
    int saved_pc;
    int in_signal;

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

struct PCB_Struct pcb[3];
int current_pid;
struct PCB_Struct *curr_pcb;
int *ram;
