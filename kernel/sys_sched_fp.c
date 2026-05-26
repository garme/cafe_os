// =======================================================
// sched_fp.c - Escalonador de Prioridade Fixa
// =======================================================

void schedule() {
    int i;
    int highest_priority;
    int next_pid;
    int any_alive;
    
    struct PCB_Struct *p; // Cache do processo no laço

    // 1. Despromove o processo atual
    if (curr_pcb->state == STATE_RUNNING) {
        curr_pcb->state = STATE_READY;
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
        while(1){} // Trava de segurança no encerramento
    }
    
    // 3. Procura na tabela (Com Time Warp para CPU Ociosa)
    next_pid = -1; 
    
    // Fica preso no escalonador até achar alguém pronto!
    while(next_pid == -1) {
        highest_priority = -1;
        i = 0;
        
        while (i < MAX_PROCESSES) {
            p = &pcb[i];
            if (p->state == STATE_READY) {
                if (p->priority > highest_priority) {
                    highest_priority = p->priority;
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
    
    // 4. Promove o processo vencedor para a CPU e atualiza o Cache
    current_pid = next_pid;
    curr_pcb = &pcb[current_pid]; // ATUALIZA O CACHE KERNEL
    
    curr_pcb->state = STATE_RUNNING;
    
    if (curr_pcb->state == STATE_TERMINATED) {
        // estado inválido → trava
        asm("INT CLI_INT");
        asm("INT HALT_INT");
    }
    return;
}
