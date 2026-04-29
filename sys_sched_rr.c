// =====================================
// sched_rr.c - Escalonador Round-Robin 
// =====================================

void schedule() {
    int i;
    int next_pid;
    int any_alive;
    int temp_pid;
    
    struct PCB_Struct *curr;
    struct PCB_Struct *p;

    curr = &pcb[current_pid]; // Cache do processo atual

    // 1. Despromove o processo atual
    if (curr->state == STATE_RUNNING) {
        curr->state = STATE_READY;
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
    
    // 3. Busca Circular (Com Time Warp)
    next_pid = -1;
    
    // NOVO: Fica preso no escalonador até achar alguém pronto!
    while (next_pid == -1) {
        i = 1;
        while (i <= MAX_PROCESSES) {
            temp_pid = current_pid + i;
            
            if (temp_pid >= MAX_PROCESSES) {
                temp_pid = temp_pid - MAX_PROCESSES;
            }
            
            p = &pcb[temp_pid]; // Cache do processo testado
            if (p->state == STATE_READY) {
                next_pid = temp_pid;
                i = MAX_PROCESSES + 1; // Quebra o laço de busca
            } else {
                i = i + 1;
            }
        }
        
        // Se a fila de prontos estava vazia (Todos dormindo)
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
    
    // 4. Promove o processo vencedor para a CPU
    current_pid = next_pid;
    curr_pcb = &pcb[current_pid]; 
    
    curr_pcb->state = STATE_RUNNING;
    
    if (curr_pcb->state == STATE_TERMINATED) {
        asm("INT CLI_INT");
        asm("INT HALT_INT");
    }
    return;
}
