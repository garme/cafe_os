#include "sys_core.h"

// ESCOLHA O SEU ESCALONADOR AQUI (Comente um e descomente o outro)
//#include "sys_sched_fp.c"    // Prioridade Fixa
#include "sys_sched_dp.c"    // Round-Robin

#include "sys_mem.c"         
#include "sys_ipc.c"

#include "usr_tasks_2.c"

//Globais temporárias par AC e SP
int isr_tmp_ac;   
int isr_tmp_sp;

//Globais temporárias para Syscalls
int tmp_sys_flags;
int tmp_sys_pc;
int tmp_sys_id;
int tmp_sys_arg;

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
    asm("SOP pop"); // Descarta Flags antigas
    asm("SOP pop"); // Descarta PC corrompido/malicioso
    kernel_kill(current_pid); // Mata o processo infrator!
    schedule(); // Elege um novo processo
    asm("JMP dispatcher_restore_context");
    
    // =======================================================
    // 2.2 Hander de Syscall
    // =======================================================
    asm("kernel_syscall_handler:");
    asm("INT CLI_INT");
    asm("STA isr_tmp_ac"); // Preserva o acumulador sujo pelo processo

    // 1. Extração Cirúrgica: Tira Flags, PC, ID e Arg do topo da pilha do utilizador
    asm("SOP pop"); asm("STA tmp_sys_flags");
    asm("SOP pop"); asm("STA tmp_sys_pc");
    asm("SOP pop"); asm("STA tmp_sys_id");
    asm("SOP pop"); asm("STA tmp_sys_arg");

    // 2. Reconstrução: Devolve o PC e as Flags originais para o topo
    // (Isto deixa a pilha perfeita para quando o IRET_INT precisar de a restaurar)
    asm("LDA tmp_sys_pc");  asm("SOP push");
    asm("LDA tmp_sys_flags"); asm("SOP push");

    // 3. Salva os registos temporários do compilador na pilha (Idêntico ao Dispatcher)
    asm("LDA tmp_ptr"); asm("SOP push");
    asm("LDA tmp_idx"); asm("SOP push");
    asm("LDA tmp_lhs"); asm("SOP push");
    asm("LDA tmp_val"); asm("SOP push");
    asm("LDA tmp_left_cond"); asm("SOP push");
    asm("LDA tmp_left"); asm("SOP push");
    asm("LDA tmp_right"); asm("SOP push");

    // 4. Guarda o ponteiro da pilha final no PCB
    asm("MOV $SP");         
    asm("STA isr_tmp_sp");

    pcb[current_pid].ac = isr_tmp_ac;
    pcb[current_pid].sp = isr_tmp_sp;

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
        kernel_kill(tmp_sys_arg);
    }
    // IDs 4 e 5: Semáforo (Bloqueio)
    if (tmp_sys_id == 4) {
        kernel_sem_lock(); 
    }
    if (tmp_sys_id == 5) {
        kernel_sem_unlock();
    }
    if (tmp_sys_id == 6) {
        kernel_print_space();
    }
    // IDs 7 e 8: Mutex (Spinlock)
    if (tmp_sys_id == 7) {
        isr_tmp_ac = kernel_mutex_trylock(); // Responde 1 ou 0 para a tarefa
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
    asm("LDA tmp_ptr"); asm("SOP push");
    asm("LDA tmp_idx"); asm("SOP push");
    asm("LDA tmp_lhs"); asm("SOP push");
    asm("LDA tmp_val"); asm("SOP push");
    asm("LDA tmp_left_cond"); asm("SOP push");
    asm("LDA tmp_left"); asm("SOP push");
    asm("LDA tmp_right"); asm("SOP push");
    asm("MOV $SP");         
    asm("STA isr_tmp_sp");
    
    // Salva o contexto de quem estava a rodar
    pcb[current_pid].ac = isr_tmp_ac;
    pcb[current_pid].sp = isr_tmp_sp;

    schedule(); 
    
    // Rótulo de reentrada (Aproveitado pelo Fault e Syscall se precisarem)
    asm("dispatcher_restore_context:");

    // Restaura o contexto do processo eleito
    isr_tmp_sp = pcb[current_pid].sp;
    isr_tmp_ac = pcb[current_pid].ac;
    
    asm("LDA isr_tmp_sp");
    asm("MOV -$SP");             
    
    asm("SOP pop"); asm("STA tmp_right");
    asm("SOP pop"); asm("STA tmp_left");
    asm("SOP pop"); asm("STA tmp_left_cond");
    asm("SOP pop"); asm("STA tmp_val");
    asm("SOP pop"); asm("STA tmp_lhs");
    asm("SOP pop"); asm("STA tmp_idx");
    asm("SOP pop"); asm("STA tmp_ptr");

    asm("LDA isr_tmp_ac");       
    asm("INT IRET_INT");         

    // =======================================================
    // 3. KERNEL BOOT
    // =======================================================
    asm("os_boot:");
    asm("INT CLI_INT");
    
    // Limpa PCB
    int i;
    for(i=0; i<MAX_PROCESSES; i++) { pcb[i].state = STATE_TERMINATED; }
    
    // --- DESBLOQUEIO DE HARDWARE (SEGMENTO DE PILHA) ---
    // Avisa a CPU que as pilhas podem viver em qualquer lugar da RAM (Heap)
    asm("MOV 0"); 
    asm("MOV -$SS");
    
    ram = (int*) 0; 
    
    // --- Inicialização do heap! ---
    asm("MOV os_heap"); asm("STA HEAP_START");
    init_heap(); // Formata a memória a partir da posição 2000
    
    // Captura os endereços das funções
    asm("MOV task_a"); asm("STA addr_task_a");
    asm("MOV task_b"); asm("STA addr_task_b");
    
    // Aloca 100 palavras na RAM dinamicamente para cada processo!
    // Nota: Como a pilha cresce para BAIXO, o topo da pilha é (Ponteiro + Tamanho)
    int mem_a, mem_b;
    mem_a = malloc(100);
    mem_b = malloc(100);
    
    // create_process(PID, Função, Base_Pilha, Prioridade, Pont_Memoria)
    create_process(0, addr_task_a, mem_a + 100, 5, mem_a); // <--- Alta Prioridade
    create_process(1, addr_task_b, mem_b + 100, 5, mem_b);  // <--- Baixa Prioridade
    
    current_pid = 0;
    pcb[0].state = STATE_RUNNING;
    
    isr_tmp_sp = pcb[0].sp;
    isr_tmp_ac = pcb[0].ac;
    
    asm("LDA isr_tmp_sp");
    asm("MOV -$SP");             

    asm("SOP pop"); asm("STA tmp_right");
    asm("SOP pop"); asm("STA tmp_left");
    asm("SOP pop"); asm("STA tmp_left_cond");
    asm("SOP pop"); asm("STA tmp_val");
    asm("SOP pop"); asm("STA tmp_lhs");
    asm("SOP pop"); asm("STA tmp_idx");
    asm("SOP pop"); asm("STA tmp_ptr");

    asm("LDA isr_tmp_ac");       
    asm("INT IRET_INT");         
}
