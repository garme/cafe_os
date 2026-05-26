#ifndef USR_SYSCALLS_C
#define USR_SYSCALLS_C

// Agregador de compatibilidade. Para overlays menores, inclua apenas os módulos usados:
// usr_proc.c, usr_io.c, usr_stdio.c, usr_sync.c, usr_pipe.c, usr_shm.c,
// usr_msg.c, usr_signal.c, usr_thread.c.
#include "../user/usr_proc.c"
#include "../user/usr_sync.c"
#include "../user/usr_io.c"
#include "../user/usr_signal.c"
#include "../user/usr_stdio.c"
#include "../user/usr_pipe.c"
#include "../user/usr_shm.c"
#include "../user/usr_msg.c"
#include "../user/usr_thread.c"

#endif
