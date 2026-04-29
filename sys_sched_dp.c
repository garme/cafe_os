// =======================================================
// sys_sched_dp.c - Escalonador de Prioridade com Aging
// =======================================================

void schedule() {
    int i;
    int highest_priority;
    int next_pid;
    int any_alive;
    int effective_priority;
    
    struct PCB_Struct *p; // Cache do processo no laço

    // 1. Despromove o processo atual (usando o Cache Global)
    if (curr_pcb->state == STATE_RUNNING) {
        curr_pcb->state = STATE_READY;
        curr_pcb->age = 0; 
    }

    // 2. VERIFICAÇÃO DE FIM DE SISTEMA
    any_alive = 0;
    i = 0;
    while (i < MAX_PROCESSES) {
        p = &pcb[i];
        if (p->state != STATE_TERMINATED) {
            any_alive = 1;
        }
        i = i + 1;
    }

    if (any_alive == 0) {
        asm("INT CLI_INT"); 
        asm("INT HALT_INT");
        while(1){} 
    }
    
    // 3. Busca com Envelhecimento (Aging) e Time Warp
    next_pid = -1; 
    
    // Fica preso no escalonador até achar alguém pronto!
    while (next_pid == -1) {
        highest_priority = -1; // Resetamos a prioridade a cada ciclo de busca
        
        i = 0;
        while (i < MAX_PROCESSES) {
            p = &pcb[i];
            if (p->state == STATE_READY) {
                
                p->age = p->age + 1; // Envelhece quem está esperando
                effective_priority = p->priority + p->age;
                
                if (effective_priority > highest_priority) {
                    highest_priority = effective_priority;
                    next_pid = i;
                }
            }
            i = i + 1;
        }
        
        // Se a fila de prontos estava vazia (Todos dormindo/bloqueados)
        if (next_pid == -1) {
            // Avança o relógio instantaneamente (Simula a ociosidade da CPU)
            system_ticks = system_ticks + 1;
            
            i = 0;
            while(i < MAX_PROCESSES) {
                p = &pcb[i];
                
                // Acorda quem dorme no sleep()
                if (p->state == STATE_SLEEPING) {
                    if (system_ticks >= p->wakeup_tick) {
                        p->state = STATE_READY;
                    }
                }
                
                // Dispara os alarmes pendentes
                if (p->alarm_tick > 0) {
                    if (system_ticks >= p->alarm_tick) {
                        p->pending_signal = 14; // SIGALRM
                        p->alarm_tick = 0;
                        
                        // Sinais acordam processos em pause()
                        if (p->state == STATE_PAUSED) {
                            p->state = STATE_READY;
                        }
                    }
                }
                i = i + 1;
            }
        }
    }
    
    // 4. Promove o processo vencedor e atualiza o Cache Global
    current_pid = next_pid;
    curr_pcb = &pcb[current_pid]; // <--- ATUALIZA O CACHE KERNEL
    
    curr_pcb->state = STATE_RUNNING;
    curr_pcb->age = 0; // Zera o aging de quem ganhou a CPU
    
    if (curr_pcb->state == STATE_TERMINATED) {
        asm("INT CLI_INT");
        asm("INT HALT_INT");
    }
}
