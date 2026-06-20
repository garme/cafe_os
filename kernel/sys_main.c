#include "kernel/sys_core.h"
#include "kernel/sys_config.inc"

// ESCOLHA O SEU ESCALONADOR AQUI (Comente um e descomente o outro)
//#include "kernel/sys_sched_fp.c"    // Prioridade Fixa
#include "kernel/sys_sched_rr.c"    // Round-Robin
//#include "kernel/sys_sched_dp.c"    // Aging

#include "kernel/sys_kernel_includes.inc"
#include "kernel/sys_dispatch.inc"
#include "kernel/sys_init.inc"
#include "kernel/sys_tick.inc"
#include "kernel/sys_signal_inject.inc"
#include "kernel/sys_overlays.inc"


//Globais temporárias par AC e SP
int isr_tmp_ac;   
int isr_tmp_sp;

//Globais temporárias para Syscalls
int tmp_sys_flags;
int tmp_sys_pc;
int tmp_sys_id;
int tmp_sys_arg;
int tmp_sys_arg2;
int tmp_sys_arg3;

// Bloco de contexto usado pela INT CTXSW_INT. Ordem exigida pela CPU:
// [0]=pc, [1]=cs, [2]=ds, [3]=ss, [4]=sp, [5]=ac, [6]=flags
int ctx_block[7];
int ctx_tmp_flags;
int ctx_tmp_pc;



void main() {
    int i;
    struct PCB_Struct *p;
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
    
    // Extrai mais um arg da pilha, se for kill (3), spawn (6), shmget (25) ou msg_send (27)
    if (tmp_sys_id == 3 || tmp_sys_id == 6 || tmp_sys_id == 25 || tmp_sys_id == 27 || tmp_sys_id == 29) {
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
    //~ curr = &pcb[current_pid];
    curr = curr_pcb;
    
    asm("MOV $SP");         
    asm("STA isr_tmp_sp");

    curr->ac = isr_tmp_ac;
    curr->sp = isr_tmp_sp;

    // --- LÓGICA DE TEMPO E SINAIS ---
    kernel_tick_update();
    // -------------------------------------

    // =================================================================
    // Agora estamos 100% seguros em Kernel Space!
    // O dispatcher é gerado pela IDE no modo Kernel+Overlay.
    // Em Kernel isolado, kernel/sys_dispatch.inc fornece o dispatcher completo.
    // =================================================================
    kernel_need_resched = 0;
    kernel_dispatch_syscall();

    // Syscalls leves retornam à mesma tarefa; bloqueio/yield/exit solicitam troca.
    if (kernel_need_resched == 1) { schedule(); } 
    
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
    //~ pcb[current_pid].ac = isr_tmp_ac;
    //~ pcb[current_pid].sp = isr_tmp_sp;
    curr_pcb->ac = isr_tmp_ac;
    curr_pcb->sp = isr_tmp_sp;

    kernel_tick_update();
    schedule(); 
    
    // Rótulo de reentrada (Aproveitado pelo Fault e Syscall se precisarem)
    asm("dispatcher_restore_context:");
    
    
    // =================================================================
    // STACK SPOOFING / SINAIS
    // Kernel+Overlay troca isso por função vazia quando sinais não são usados.
    // =================================================================
    curr = curr_pcb;
    int target_sp;
    target_sp = curr->sp;
    kernel_signal_inject(curr, target_sp);
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

    // A pilha agora contém flags e pc. Copiamos para o bloco de contexto
    // e fazemos a troca segmentada de forma atômica na CPU.
    asm("SOP POP_OP"); asm("STA ctx_tmp_flags");
    asm("SOP POP_OP"); asm("STA ctx_tmp_pc");
    asm("MOV $SP");    asm("STA isr_tmp_sp");

    ctx_block[0] = ctx_tmp_pc;
    ctx_block[1] = curr_pcb->cs;
    ctx_block[2] = curr_pcb->ds;
    ctx_block[3] = curr_pcb->ss;
    ctx_block[4] = isr_tmp_sp;
    ctx_block[5] = isr_tmp_ac;
    ctx_block[6] = ctx_tmp_flags;

    asm("MOV ctx_block");
    asm("INT CTXSW_INT");

    // =======================================================
    // 3. KERNEL BOOT
    // =======================================================
    asm("os_boot:");
    asm("INT CLI_INT");
    
    // Limpa PCB
    for(i=0; i<MAX_PROCESSES; i++) { pcb[i].state = STATE_TERMINATED; }
    
    // --- DESBLOQUEIO DE HARDWARE (SEGMENTO DE PILHA) ---
    // Avisa a CPU que as pilhas podem viver em qualquer lugar da RAM (Heap)
//    asm("MOV 0"); 
//    asm("MOV -$SS");
    
    ram = (int*) 0; 
    
    // --- Inicialização do heap! ---
    asm("MOV os_heap"); asm("STA HEAP_START");
    init_heap(); // Formata a memória a partir da posição 2000
    
    init_kernel_services(); // Inicialização seletiva dos serviços do kernel
    
    // Inicializa as aplicações de usuário injetadas como overlays pela IDE.
    boot_overlays();
    
    current_pid = 0;
    curr_pcb = &pcb[0];
    pcb[0].state = STATE_RUNNING;
    
    isr_tmp_sp = pcb[0].sp;
    isr_tmp_ac = pcb[0].ac;
    
    asm("JMP dispatcher_restore_context");
}
