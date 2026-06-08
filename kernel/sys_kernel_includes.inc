#ifndef SYS_KERNEL_INCLUDES_INC
#define SYS_KERNEL_INCLUDES_INC

// Fallback para compilacao Kernel isolada: inclui o conjunto completo
// necessario ao dispatcher completo em kernel/sys_dispatch.inc.
//
// No modo Kernel+Overlay, a IDE substitui este arquivo por uma versao
// seletiva em memoria contendo apenas os modulos necessarios aos overlays.
#include "kernel/sys_mem.c"
#include "kernel/sys_wakeup.c"
#include "kernel/sys_proc.c"
#include "kernel/sys_proc_exit.c"
#include "kernel/sys_proc_wait.c"
#include "kernel/sys_proc_kill.c"
#include "kernel/sys_proc_sleep.c"
#include "kernel/sys_proc_spawn.c"
#include "kernel/sys_overlay.c"
#include "kernel/sys_io.c"
#include "kernel/sys_sem.c"
#include "kernel/sys_mutex.c"
#include "kernel/sys_pipe.c"
#include "kernel/sys_shm.c"
#include "kernel/sys_msg.c"
#include "kernel/sys_signal.c"
#include "kernel/sys_thread.c"
#include "kernel/sys_thread_exit.c"

#endif
