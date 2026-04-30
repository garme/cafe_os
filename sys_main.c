#include "sys_core.h"

// ESCOLHA O SEU ESCALONADOR AQUI (Comente um e descomente o outro)
//#include "sys_sched_fp.c"    // Prioridade Fixa
#include "sys_sched_rr.c"    // Round-Robin
//#include "sys_sched_dp.c"    // Aging

#include "sys_mem.c"         
#include "sys_ipc.c"

#include "usr_tasks_11.c"

//Globais temporárias par AC e SP
int isr_tmp_ac;   
int isr_tmp_sp;

//Globais temporárias para Syscalls
int tmp_sys_flags;
int tmp_sys_pc;
int tmp_sys_id;
int tmp_sys_arg;
int tmp_sys_arg2;

//Globais endereços de memória das tasks
int addr_task_a;
int addr_task_b;


void main() {
    // =======================================================
    // 1. TABELA DE VETORES DE INTERRUPÇÃO (IVT Densa)
    // =======================================================
    
    asm("JMP os_boot");                // Vetor 0x0000: Boot / Reset
    asm("JMP kernel_dispatcher");      // Vetor 0x0001: Hardware Timer
    asm("JMP kernel_syscall_handler"); // Vetor 0x0002: Syscall (TRAP)
    asm("JMP kernel_fault_handler");   // Vetor 0x0003: Memory/Privilege Fault
    
    // =======================================================
    // 2. KERNEL HANDLERS (A partir do endereço 0x0004)
    // =======================================================
    // =======================================================
    // 2.1 Hander de Erro de Processo
    // =======================================================
    asm("kernel_fault_handler:");
    asm("INT CLI_INT");
    asm("SOP POP_OP"); // Descarta Flags antigas
    asm("SOP POP_OP"); // Descarta PC corrompido/malicioso
    kernel_kill(current_pid, SIGKILL); // Mata o processo infrator!
    schedule(); // Elege um novo processo
    asm("JMP dispatcher_restore_context");
    
    // =======================================================
    // 2.2 Hander de Syscall
    // =======================================================
    asm("kernel_syscall_handler:");
    asm("INT CLI_INT");
    asm("STA isr_tmp_ac"); // Preserva o acumulador sujo pelo processo
    
    // 1. Extração Cirúrgica: Tira Flags, PC, ID e Arg do topo da pilha do utilizador
    asm("SOP POP_OP"); asm("STA tmp_sys_flags");
    asm("SOP POP_OP"); asm("STA tmp_sys_pc");
    asm("SOP POP_OP"); asm("STA tmp_sys_id");
    asm("SOP POP_OP"); asm("STA tmp_sys_arg");
    
    // Extrai mais um arg da pilha, se for a syscall kill (ID 3)
    if (tmp_sys_id == 3 || tmp_sys_id == 25) {
        asm("SOP POP_OP"); asm("STA tmp_sys_arg2"); 
    }

    // 2. Reconstrução: Devolve o PC e as Flags originais para o topo
    // (Isto deixa a pilha perfeita para quando o IRET_INT precisar de a restaurar)
    asm("LDA tmp_sys_pc");  asm("SOP PUSH_OP");
    asm("LDA tmp_sys_flags"); asm("SOP PUSH_OP");

    // 3. Salva os registos temporários do compilador na pilha (Idêntico ao Dispatcher)
    asm("LDA tmp_ptr"); asm("SOP PUSH_OP");
    asm("LDA tmp_idx"); asm("SOP PUSH_OP");
    asm("LDA tmp_lhs"); asm("SOP PUSH_OP");
    asm("LDA tmp_val"); asm("SOP PUSH_OP");
    asm("LDA tmp_left_cond"); asm("SOP PUSH_OP");
    asm("LDA tmp_left"); asm("SOP PUSH_OP");
    asm("LDA tmp_right"); asm("SOP PUSH_OP");
    asm("LDA tmp_arr_base"); asm("SOP PUSH_OP");
    asm("LDA tmp_step");     asm("SOP PUSH_OP");

    struct PCB_Struct *curr;
    curr = &pcb[current_pid];
    
    asm("MOV $SP");         
    asm("STA isr_tmp_sp");

    curr->ac = isr_tmp_ac;
    curr->sp = isr_tmp_sp;

    // --- LÓGICA DE TEMPO E SINAIS ---
    system_ticks = system_ticks + 1;

    int i;
    struct PCB_Struct *p;
    i = 0;
    while(i < MAX_PROCESSES) {
        p = &pcb[i];
        if (p->state != STATE_TERMINATED) {
            
            // 1. Verifica os processos em SLEEP
            if (p->state == STATE_SLEEPING) {
                if (system_ticks >= p->wakeup_tick) {
                    p->state = STATE_READY; // Acorda!
                }
            }

            // 2. Verifica os ALARMES
            if (p->alarm_tick > 0) {
                if (system_ticks >= p->alarm_tick) {
                    p->pending_signal = SIGALRM; // Entrega o sinal
                    p->alarm_tick = 0;           // Desarma o alarme
                }
            }
        }
        i = i + 1;
    }
    // -------------------------------------

    // =================================================================
    // Agora estamos 100% seguros em Kernel Space!
    // =================================================================
    if (tmp_sys_id == 1) {
        kernel_exit();
    } 
    if (tmp_sys_id == 2) {
        kernel_wait(tmp_sys_arg);
    }
    if (tmp_sys_id == 3) {
        kernel_kill(tmp_sys_arg, tmp_sys_arg2);
    }
    // IDs 4 e 5: Semáforo (Bloqueio)
    if (tmp_sys_id == 4) {
        kernel_sem_lock(); 
    }
    if (tmp_sys_id == 5) {
        kernel_sem_unlock();
    }
    // RESERVADO
    if (tmp_sys_id == 6) {
        
    }
    // IDs 7 e 8: Mutex (Spinlock)
    if (tmp_sys_id == 7) {
        isr_tmp_ac = kernel_mutex_trylock(); // Responde 1 ou 0 para a tarefa
        curr_pcb->ac = isr_tmp_ac;
    }
    if (tmp_sys_id == 8) {
        kernel_mutex_unlock();
    }
    // ID 9: Yield (Ceder a vez)
    if (tmp_sys_id == 9) {
        // Não faz nada ativamente! O schedule() no final da função já vai
        // forçar a troca de contexto porque a syscall foi invocada.
    }
    // ID 10: Imprimir Caractere
    if (tmp_sys_id == 10) {
        kernel_print_char(tmp_sys_arg);
    }
    // ID 11: Ler Caractere
    if (tmp_sys_id == 11) {
        isr_tmp_ac = kernel_read_char(); // Retorna o valor lido para a tarefa!
        curr_pcb->ac = isr_tmp_ac;
    }
    // ID 12: Por a tarefa para dormir
    if (tmp_sys_id == 12) {
        kernel_sleep(tmp_sys_arg);
    }
    // ID 13: Configurar um alarme para acordar a tarefa
    if (tmp_sys_id == 13) {
        kernel_alarm(tmp_sys_arg);
    }
    // ID 14: Pausar a tarefa
    if (tmp_sys_id == 14) {
        kernel_pause();
    }
    // IDs 15, 16, 17: Tratamento de Sinais
    if (tmp_sys_id == 15) {
        kernel_signal(tmp_sys_arg);
    }
    if (tmp_sys_id == 16) {
        kernel_sigreturn(); // Aqui ocorre a sobreposição de tmp_sys_pc!
    }
    if (tmp_sys_id == 17) {
        isr_tmp_ac = kernel_get_signal();
        curr_pcb->ac = isr_tmp_ac;
    }
    // IDs 20, 21: Pipes
    if (tmp_sys_id == 20) { 
        isr_tmp_ac = kernel_write_pipe(tmp_sys_arg); 
        curr_pcb->ac = isr_tmp_ac; 
       }
    if (tmp_sys_id == 21) { 
        isr_tmp_ac = kernel_read_pipe(); 
        curr_pcb->ac = isr_tmp_ac; 
    }
    // ID 25: Memória Compartilhada (shmget)
    if (tmp_sys_id == 25) { 
        // arg1 = key, arg2 = size
        isr_tmp_ac = kernel_shmget(tmp_sys_arg, tmp_sys_arg2); 
        curr_pcb->ac = isr_tmp_ac; 
    }


    // 6. Resolução da Syscall: Força o escalonador a atuar e salta para o fluxo de restauro
    schedule(); 
    
    asm("JMP dispatcher_restore_context");
    
    // =======================================================
    // 2.3 Hander de Timer Interrupt
    // =======================================================
    asm("kernel_dispatcher:");
    asm("INT CLI_INT");
    asm("STA isr_tmp_ac");
           
    asm("LDA tmp_ptr"); asm("SOP PUSH_OP");
    asm("LDA tmp_idx"); asm("SOP PUSH_OP");
    asm("LDA tmp_lhs"); asm("SOP PUSH_OP");
    asm("LDA tmp_val"); asm("SOP PUSH_OP");
    asm("LDA tmp_left_cond"); asm("SOP PUSH_OP");
    asm("LDA tmp_left"); asm("SOP PUSH_OP");
    asm("LDA tmp_right"); asm("SOP PUSH_OP");
    asm("LDA tmp_arr_base"); asm("SOP PUSH_OP");
    asm("LDA tmp_step");     asm("SOP PUSH_OP");
    
    asm("MOV $SP");         
    asm("STA isr_tmp_sp");
    
    // Salva o contexto de quem estava a rodar
    pcb[current_pid].ac = isr_tmp_ac;
    pcb[current_pid].sp = isr_tmp_sp;

    schedule(); 
    
    // Rótulo de reentrada (Aproveitado pelo Fault e Syscall se precisarem)
    asm("dispatcher_restore_context:");
    
    
    // =================================================================
    // STACK SPOOFING (A MÁGICA DOS SINAIS)
    // =================================================================
    
    curr = &pcb[current_pid];
    int target_sp;
    int *sp_ptr;
    target_sp = curr->sp;

    if (curr->pending_signal > 0) {
        if (curr->signal_handler != 0) {
            if (curr->in_signal == 0) {
                curr->sig_saved_sp = target_sp;
                curr->sig_saved_ac = curr->ac;
                
                sp_ptr = &ram[target_sp];
                
                curr->sig_saved_step      = *sp_ptr; sp_ptr = sp_ptr + 1;
                curr->sig_saved_arr_base  = *sp_ptr; sp_ptr = sp_ptr + 1;
                curr->sig_saved_right     = *sp_ptr; sp_ptr = sp_ptr + 1;
                curr->sig_saved_left      = *sp_ptr; sp_ptr = sp_ptr + 1;
                curr->sig_saved_left_cond = *sp_ptr; sp_ptr = sp_ptr + 1;
                curr->sig_saved_val       = *sp_ptr; sp_ptr = sp_ptr + 1;
                curr->sig_saved_lhs       = *sp_ptr; sp_ptr = sp_ptr + 1;
                curr->sig_saved_idx       = *sp_ptr; sp_ptr = sp_ptr + 1;
                curr->sig_saved_ptr       = *sp_ptr; sp_ptr = sp_ptr + 1;
                
                curr->sig_saved_flags = *sp_ptr;     sp_ptr = sp_ptr + 1;
                curr->saved_pc = *sp_ptr; 
                
                // Injeta o handler no topo
                *sp_ptr = curr->signal_handler;
                
                curr->in_signal = 1;
            }
        }
    }
    // =================================================================

    // Restaura o contexto do processo eleito
    isr_tmp_sp = pcb[current_pid].sp;
    isr_tmp_ac = pcb[current_pid].ac;
    
    asm("LDA isr_tmp_sp");
    asm("MOV -$SP");             
    
    asm("SOP POP_OP"); asm("STA tmp_step");
    asm("SOP POP_OP"); asm("STA tmp_arr_base");
    asm("SOP POP_OP"); asm("STA tmp_right");
    asm("SOP POP_OP"); asm("STA tmp_left");
    asm("SOP POP_OP"); asm("STA tmp_left_cond");
    asm("SOP POP_OP"); asm("STA tmp_val");
    asm("SOP POP_OP"); asm("STA tmp_lhs");
    asm("SOP POP_OP"); asm("STA tmp_idx");
    asm("SOP POP_OP"); asm("STA tmp_ptr");

    asm("LDA isr_tmp_ac");       
    asm("INT IRET_INT");         

    // =======================================================
    // 3. KERNEL BOOT
    // =======================================================
    asm("os_boot:");
    asm("INT CLI_INT");
    
    // Limpa PCB
    for(i=0; i<MAX_PROCESSES; i++) { pcb[i].state = STATE_TERMINATED; }
    
    // --- DESBLOQUEIO DE HARDWARE (SEGMENTO DE PILHA) ---
    // Avisa a CPU que as pilhas podem viver em qualquer lugar da RAM (Heap)
    asm("MOV 0"); 
    asm("MOV -$SS");
    
    ram = (int*) 0; 
    
    // --- Inicialização do heap! ---
    asm("MOV os_heap"); asm("STA HEAP_START");
    init_heap(); // Formata a memória a partir da posição 2000
    
    init_ipc_shm(); // Inicializa os controladores de SHM
    
    // Captura os endereços das funções
    asm("MOV task_a"); asm("STA addr_task_a");
    asm("MOV task_b"); asm("STA addr_task_b");
    
    // Aloca 100 palavras na RAM dinamicamente para cada processo!
    // Nota: Como a pilha cresce para BAIXO, o topo da pilha é (Ponteiro + Tamanho)
    int mem_a, mem_b;
    mem_a = malloc(40);
    mem_b = malloc(40);
    
    // create_process(PID, Função, Base_Pilha, Prioridade, Pont_Memoria)
    create_process(0, addr_task_a, mem_a + 40, 4, mem_a); // <--- Alta Prioridade
    create_process(1, addr_task_b, mem_b + 40, 4, mem_b);  // <--- Baixa Prioridade
    
    current_pid = 0;
    curr_pcb = &pcb[0];
    pcb[0].state = STATE_RUNNING;
    
    isr_tmp_sp = pcb[0].sp;
    isr_tmp_ac = pcb[0].ac;
    
    asm("JMP dispatcher_restore_context");
}
