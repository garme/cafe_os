#ifndef SYS_PROC_C
#define SYS_PROC_C

// Agregador de compatibilidade. Para kernel pequeno, use sys_kernel_includes.inc gerado pela IDE.
// sys_proc_spawn.c vem antes porque define create_process_ex() e
// kernel_release_process_resources(), usados por exit/kill/thread/overlay.
#include "kernel/sys_wakeup.c"
#include "kernel/sys_proc_spawn.c"
#include "kernel/sys_proc_exit.c"
#include "kernel/sys_proc_wait.c"
#include "kernel/sys_proc_kill.c"
#include "kernel/sys_proc_sleep.c"

#endif
