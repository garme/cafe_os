#ifndef SYS_MSG_C
#define SYS_MSG_C

//----------------------------------------------------------------------
// --- IPC: Filas de Mensagens (VERSÃO SIMPLISTA / ESPARTANA) ---
//----------------------------------------------------------------------

int ipc_mailbox[3]; // 0 significa "Vazio"

void init_ipc_mailbox() {
    ipc_mailbox[0] = 0; 
    ipc_mailbox[1] = 0;
    ipc_mailbox[2] = 0;
}

// Retorna 1 (Sucesso) ou 0 (Caixa cheia/Erro)
int kernel_msg_send(int target_pid, int msg) {
    if (target_pid < 0 || target_pid >= MAX_PROCESSES) { return 0; }
    if (ipc_mailbox[target_pid] != 0) { return 0; }
    
    ipc_mailbox[target_pid] = msg;
    return 1;
}

// Retorna o valor lido ou 0 se a caixa estiver vazia
int kernel_msg_recv() {
    int msg;
    msg = ipc_mailbox[current_pid];
    
    if (msg == 0) {
        return 0; // Vazia
    }
    
    ipc_mailbox[current_pid] = 0; // Esvazia a caixa
    return msg;
}


#endif
