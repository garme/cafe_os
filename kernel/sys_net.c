#ifndef SYS_NET_C
#define SYS_NET_C

// ===============================================================
// Driver de rede do CAFE OS / Guilix
//
// Portas lógicas do periférico: 40..62.
// Porta privada do kernel: 63 (seleção do contexto/PID).
//
// Antes de cada IN/OUT, o kernel informa o PID atual ao periférico.
// O dispositivo restaura então SOCKET, IP, PORT, RESULT, ERROR e
// demais registradores virtuais daquele processo. Os overlays podem
// compartilhar o periférico sem trocar acidentalmente o socket ou
// os parâmetros de outro processo.
// ===============================================================

int NET_IO_WORD_MIN = 10240;
int NET_IO_WORD_MAX = 16127;
int NET_CONTEXT_WORD = 16128;
int kernel_net_result;
int kernel_net_context_word;

void kernel_net_select_context() {
    kernel_net_context_word = NET_CONTEXT_WORD + current_pid;
    asm("LDA kernel_net_context_word");
    asm("INT OUT_INT");
}

int kernel_net_out(int io_word) {
    if (io_word < NET_IO_WORD_MIN || io_word > NET_IO_WORD_MAX) {
        return -1;
    }

    kernel_net_select_context();
    asm("LDA kernel_net_out_io_word");
    asm("INT OUT_INT");
    return 0;
}

int kernel_net_in(int io_word) {
    if (io_word < NET_IO_WORD_MIN || io_word > NET_IO_WORD_MAX) {
        return -1;
    }

    kernel_net_select_context();
    asm("LDA kernel_net_in_io_word");
    asm("INT IN_INT");
    asm("STA kernel_net_result");
    return kernel_net_result;
}

#endif
