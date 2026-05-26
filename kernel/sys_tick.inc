#ifndef SYS_TICK_INC
#define SYS_TICK_INC

// Fallback completo. Kernel+Overlay substitui por versão seletiva em memória.
void kernel_tick_update() {
    int i;
    struct PCB_Struct *p;

    system_ticks = system_ticks + 1;
    i = 0;
    p = &pcb[0];
    while(i < MAX_PROCESSES) {
        if (p->state != STATE_TERMINATED) {
            if (p->state == STATE_SLEEPING) {
                if (system_ticks >= p->wakeup_tick) {
                    p->state = STATE_READY;
                }
            }
            if (p->alarm_tick > 0) {
                if (system_ticks >= p->alarm_tick) {
                    p->pending_signal = 14;
                    p->alarm_tick = 0;
                }
            }
        }
        p = p + 1;
        i = i + 1;
    }
}

#endif
