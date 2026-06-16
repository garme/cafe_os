#ifndef SYS_KERNEL_INCLUDES_INC
#define SYS_KERNEL_INCLUDES_INC

// Fallback para compilação Kernel isolada: inclui o kernel completo.
// No modo Kernel+Overlay, a IDE substitui este arquivo por uma versão seletiva em memória.
#include "kernel/sys_mem.c"
#include "kernel/sys_ipc.c"
#include "kernel/sys_overlay.c"
#include "kernel/sys_net.c"

#endif
