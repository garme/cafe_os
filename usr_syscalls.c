// =======================================================
// usr_syscalls.c - Biblioteca de User Space (Ring 1)
// =======================================================

int sys_ret_val;

// --- GESTÃO DE CICLO DE VIDA DE TAREFAS ---
void yield() {
    asm("MOV 0"); asm("SOP PUSH_OP"); asm("MOV 9"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
}

void exit() {
    asm("MOV 0"); asm("SOP PUSH_OP"); asm("MOV 1"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
    
    while(1) { 
        yield(); // Cede a CPU pacífica e infinitamente
    }
}

void wait(int pid) {
    asm("LDA wait_pid"); asm("SOP PUSH_OP"); asm("MOV 2"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
}

void kill(int pid, int signal) {
    // Empilha o sinal e depois o PID. O handler no Kernel precisará extrair os dois!
    asm("LDA kill_signal"); asm("SOP PUSH_OP"); 
    asm("LDA kill_pid"); asm("SOP PUSH_OP"); 
    asm("MOV 3"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
}


void sleep(int ticks) {
    asm("LDA sleep_ticks"); asm("SOP PUSH_OP"); asm("MOV 12"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
}

void alarm(int ticks) {
    asm("LDA alarm_ticks"); asm("SOP PUSH_OP"); asm("MOV 13"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
}

void pause() {
    asm("MOV 0"); asm("SOP PUSH_OP"); asm("MOV 14"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
}


//  --- SEMÁFORO (BLOQUEIO DE TAREFA) ---
void sem_lock() {
    asm("MOV 0"); asm("SOP PUSH_OP"); asm("MOV 4"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
}

void sem_unlock() {
    asm("MOV 0"); asm("SOP PUSH_OP"); asm("MOV 5"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
}


// --- MUTEX (SPINLOCK / ESPERA OCUPADA) ---
int sys_mutex_trylock() {
    asm("MOV 0"); asm("SOP PUSH_OP"); asm("MOV 7"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
    
    // 1. O IRET do Kernel preservou a resposta no Acumulador (AC).
    // 2. Guardamos numa variável em vez de empilhar!
    asm("STA sys_ret_val"); 
    
    // 3. Devolvemos a variável e o Compilador C cuida da pilha!
    return sys_ret_val;
}

void mutex_unlock() {
    asm("MOV 0"); asm("SOP PUSH_OP"); asm("MOV 8"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
}

void mutex_lock() {
    // Implementação clássica de Spinlock! 
    while (sys_mutex_trylock() == 0) {
        yield(); 
    }
}

// --- I/O e Periféricos ---
void print_char(int ascii) {
    // O C chama ao argumento 'print_char_ascii'
    asm("LDA print_char_ascii"); asm("SOP PUSH_OP"); 
    asm("MOV 10"); asm("SOP PUSH_OP"); 
    asm("INT SYSCALL_INT");
}

int read_char() {
    asm("MOV 0"); asm("SOP PUSH_OP"); asm("MOV 11"); asm("SOP PUSH_OP"); 
    asm("INT SYSCALL_INT");
    
    // Captura o caractere devolvido no AC
    asm("STA sys_ret_val");
    return sys_ret_val;
}


// =======================================================
// BIBLIOTECA TRATAMENTO DE SINAIS
// =======================================================
void signal(int * handler_addr) {
    asm("LDA signal_handler_addr"); asm("SOP PUSH_OP");
    asm("MOV 15"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
}

void sigreturn() {
    asm("MOV 0"); asm("SOP PUSH_OP");
    asm("MOV 16"); asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
}

int get_signal() {
     asm("MOV 0"); asm("SOP PUSH_OP");
     asm("MOV 17"); asm("SOP PUSH_OP");
     asm("INT SYSCALL_INT");
     asm("STA sys_ret_val");
     return sys_ret_val;
}

// =======================================================
// BIBLIOTECA PADRÃO (I/O FORMATADO EM USER SPACE)
// =======================================================

void printstr(char* str) {
    int i;
    int c;
    i = 0;
    c = str[i];
    
    // Percorre a string até encontrar o terminador nulo
    while (c != 0) {
        print_char(c);
        i = i + 1;
        c = str[i];
    }
}

void printint(int val) {
    int q;
    int r;
    int reverse[10]; // Buffer para guardar os dígitos invertidos
    int count;
    int i;

    if (val == 0) {
        print_char(48); // Imprime '0'
    } else {
        if (val < 0) {
            print_char(45); // Imprime '-'
            val = 0 - val;
        }

        count = 0;
        while (val > 0) {
            // Software Division (val / 10)
            q = 0;
            r = val;
            while (r >= 10) {
                r = r - 10;
                q = q + 1;
            }
            reverse[count] = r + 48; // Converte o resto para ASCII
            count = count + 1;
            val = q;
        }

        // Imprime os dígitos na ordem correta (desempilhando do array)
        i = count - 1;
        while (i >= 0) {
            print_char(reverse[i]);
            i = i - 1;
        }
    }
}

int readint() {
    int val;
    int c;
    int reading;
    int tmp;

    val = 0;
    reading = 1;

    while (reading == 1) {
        c = read_char();
        
        if (c == 0) {
            yield(); // ECOLÓGICO: Cede a CPU se o usuário não digitou nada!
        } else {
            if (c == 10) { // Se for ENTER
                reading = 0;
            } else {
                // Equivale a: val = (val * 10) + (c - 48);
                // Usamos somas para evitar a falta da instrução MUL na CPU
                tmp = val + val; // x2
                val = tmp + tmp; // x4
                val = val + val; // x8
                val = val + tmp + (c - 48); // x8 + x2 = x10 + dígito lido
            }
        }
    }
    return val;
}

void readstr(char* buffer) {
    int c;
    int i;
    int reading;
    
    i = 0;
    reading = 1;
    
    while (reading == 1) {
        c = read_char(); // Retorna int
        
        if (c == 0) {
            yield(); // Cede a CPU enquanto aguarda
        } else {
            if (c == 10) { // ENTER
                buffer[i] = (char) 0; // <--- CORREÇÃO AQUI (Cast explícito)
                reading = 0;
            } else {
                buffer[i] = (char) c; // <--- CORREÇÃO AQUI (Cast explícito)
                i = i + 1;
            }
        }
    }
}

// =======================================================
// BIBLIOTECA DE IPC (PIPES)
// =======================================================

int write_pipe(int val) {
    int success;
    success = 0;
    
    // Fica em laço tentando escrever. 
    // Se falhar (retornar 0), o Kernel bloqueia a tarefa e ela só
    // volta a testar o laço quando for acordada pelo leitor.
    while(success == 0) {
        // O compilador mapeia o argumento 'val' como 'write_pipe_val'
        asm("LDA write_pipe_val"); asm("SOP PUSH_OP");
        
        asm("MOV 20"); asm("SOP PUSH_OP"); // ID 20: kernel_write_pipe
        asm("INT SYSCALL_INT");
        asm("STA sys_ret_val");
        
        success = sys_ret_val;
    }
    return success;
}

int read_pipe() {
    int val;
    val = -1;
    
    // Fica em laço tentando ler.
    // Se o pipe estiver vazio (retornar -1), o Kernel bloqueia a tarefa.
    while(val == -1) {
        asm("MOV 0"); asm("SOP PUSH_OP"); // Argumento dummy (não usado)
        
        asm("MOV 21"); asm("SOP PUSH_OP"); // ID 21: kernel_read_pipe
        asm("INT SYSCALL_INT");
        asm("STA sys_ret_val");
        
        val = sys_ret_val;
    }
    return val;
}
