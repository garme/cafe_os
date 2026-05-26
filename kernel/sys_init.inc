#ifndef SYS_INIT_INC
#define SYS_INIT_INC

// Fallback para compilação Kernel isolada: inicializa todos os serviços disponíveis.
void init_kernel_services() {
    init_ipc_shm();
    init_ipc_mailbox();
}

#endif
