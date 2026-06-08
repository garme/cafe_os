#ifndef SYS_IPC_C
#define SYS_IPC_C

// Agregador de compatibilidade do kernel completo.
#include "kernel/sys_shm.c"
#include "kernel/sys_pipe.c"
#include "kernel/sys_sync.c"
#include "kernel/sys_proc.c"
#include "kernel/sys_signal.c"
#include "kernel/sys_io.c"
#include "kernel/sys_msg.c"
#include "kernel/sys_thread.c"
#include "kernel/sys_thread_exit.c"

#endif
