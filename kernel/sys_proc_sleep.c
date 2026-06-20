#ifndef SYS_PROC_SLEEP_C
#define SYS_PROC_SLEEP_C
void kernel_sleep(int ticks_to_sleep) { curr_pcb->wakeup_tick = system_ticks + ticks_to_sleep; curr_pcb->state = STATE_SLEEPING; kernel_need_resched = 1; }
void kernel_alarm(int ticks) { if (ticks == 0) { curr_pcb->alarm_tick = 0; } else { curr_pcb->alarm_tick = system_ticks + ticks; } }
void kernel_pause() { curr_pcb->state = STATE_PAUSED; kernel_need_resched = 1; }
#endif
