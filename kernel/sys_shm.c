#ifndef SYS_SHM_C
#define SYS_SHM_C

//----------------------------------------------------------------------
// --- IPC: Memória Compartilhada (Shared Memory) ---
//----------------------------------------------------------------------

// Vamos permitir até 5 blocos de memória compartilhada simultâneos
int shm_keys[5];
int shm_addrs[5];
int shm_count = 0;

void init_ipc_shm() {
    int i = 0;
    while(i < 5) {
        shm_keys[i] = 0;
        shm_addrs[i] = 0;
        i = i + 1;
    }
}

// O Handler do Kernel para alocar/recuperar a memória
int kernel_shmget(int key, int size) {
    int i = 0;
    int ptr;
    
    // 1. Busca se a chave já existe
    while(i < shm_count) {
        if (shm_keys[i] == key) {
            return shm_addrs[i]; // Já existe! Devolve o mesmo ponteiro
        }
        i = i + 1;
    }
    
    // 2. Se não existe e tem espaço na tabela, aloca memória nova
    if (shm_count < 5) {
        ptr = malloc(size);
        if (ptr != 0) {
            shm_keys[shm_count] = key;
            shm_addrs[shm_count] = ptr;
            shm_count = shm_count + 1;
            return ptr;
        }
    }
    
    return 0; // Erro: Tabela cheia ou falta de RAM
}



#endif
