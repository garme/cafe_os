// =======================================================
// ipc_proc.c - Gestão do Ciclo de Vida dos Processos
// =======================================================


void create_process(int pid, int task_addr, int stack_base, int priority, int mem_base) {
    pcb[pid].state = STATE_READY;
    pcb[pid].ac = 0;
    
    // Configura a prioridade inicial e a base
    pcb[pid].priority = priority; 
    pcb[pid].base_priority = priority;
    
    // Guard o ponteiro para o segmento de memória do processo
    pcb[pid].mem_base = mem_base;
    
    // Alinhamento Perfeito do Hardware (IRET)
    ram[stack_base - 1] = task_addr; 
    ram[stack_base - 2] = 0;         
    
    // SIMULAÇÃO DO CONTEXTO DO COMPILADOR (7 Variáveis Fantasmas)
    ram[stack_base - 3] = 0; 
    ram[stack_base - 4] = 0; 
    ram[stack_base - 5] = 0; 
    ram[stack_base - 6] = 0; 
    ram[stack_base - 7] = 0; 
    ram[stack_base - 8] = 0; 
    ram[stack_base - 9] = 0; 
    
    pcb[pid].sp = stack_base - 9;   
}



// Função de Kernel (Privilegiada)
void kernel_exit() {
    // 1. Marca o processo atual como morto
    pcb[current_pid].state = STATE_TERMINATED;
    
    // 2. Devolve as 100 posições de RAM da pilha ao Sistema!
    free(pcb[current_pid].mem_base); 
}

// Syscall de Utilizador (Naked)
naked void exit_process() {
    asm("INT CLI_INT");       // Tranca as interrupções durante o funeral
    
    asm("CALL kernel_exit");  // Chama a limpeza
    asm("SOP pop");           // Limpa o lixo do CALL (a correção que já dominamos!)
    
    asm("INT TIMER_INT");     // Chama o Escalonador para remover esta tarefa da CPU para sempre!
    
    // Se por um milagre quântico a CPU voltar aqui, cai num buraco negro seguro.
    asm("trap_dead:");
    asm("JMP trap_dead");
}