#include "os_core.h"
#include "sched_aging.c" // Escalonador      
#include "ipc_proc.c"
#include "mm_heap.c"     // Gerenciador de Memória

#include "tasks_4.c"

int isr_tmp_ac;
int isr_tmp_sp;
int addr_task_a;
int addr_task_b;


void main() {
    asm("JMP os_boot");
    asm("ORG 15");

    // =======================================================
    // 2. DISPATCHER BLINDADO (Vetor 0x0010)
    // =======================================================
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
    create_process(0, addr_task_a, mem_a + 100, 10, mem_a); // <--- Alta Prioridade
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
