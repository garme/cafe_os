#ifndef SYS_FS_C
#define SYS_FS_C

/*
 * sys_fs.c v1.4 — Overlay dinâmico residente com DMA
 *
 * Modelo:
 *   - há uma única janela de overlay dinâmico no DS do kernel;
 *   - o tamanho da janela é FS_DYN_SLOT_WORDS;
 *   - o .COV é carregado pelo Disk via DMA diretamente na RAM;
 *   - depois do DMA, o kernel chama kernel_spawn_overlay();
 *   - o ciclo de vida continua igual ao overlay estático:
 *       data_is_heap = 0
 *       stack_mem é gerenciado pelo fluxo normal
 *       a imagem residente não é heap
 *
 * Requer Disk com:
 *   CMD_LOAD_COV_DMA = 21
 *   portas 80..84 no .csd
 */

int FS_IO_WORD_MIN = 16384;    /* 64 * 256 */
int FS_IO_WORD_MAX = 21759;    /* 84 * 256 + 255 */
int FS_CONTEXT_WORD = 20224;   /* 79 * 256 */

int FS_CMD_WORD = 16384;       /* 64 * 256 */
int FS_RESULT_LO_WORD = 17920; /* 70 * 256 */
int FS_RESULT_HI_WORD = 18176; /* 71 * 256 */
int FS_ERROR_WORD = 18432;     /* 72 * 256 */

/* PIO legado, mantido reservado no Disk. */
int FS_COV_WORD_LO = 19456;    /* 76 * 256 */
int FS_COV_WORD_HI = 19712;    /* 77 * 256 */

/* DMA */
int FS_DMA_DEST_LO_WORD = 20480;   /* 80 * 256 */
int FS_DMA_DEST_HI_WORD = 20736;   /* 81 * 256 */
int FS_DMA_LIMIT_LO_WORD = 20992;  /* 82 * 256 */
int FS_DMA_LIMIT_HI_WORD = 21248;  /* 83 * 256 */
int FS_DMA_STATUS_WORD = 21504;    /* 84 * 256 */

int FS_CMD_LOAD_COV_DMA = 21;

int FS_COV_MAGIC = 51966;
int FS_COV_VERSION = 2;

/*
 * Limite oficial da janela dinâmica.
 *
 * O total do .COV deve ser:
 *   6 + code_size + data_size <= FS_DYN_SLOT_WORDS
 */
int FS_DYN_SLOT_WORDS = 1536;
int FS_DYN_SLOT_COUNT = 1;

int fs_dyn_overlay_pool[1536];

int fs_dyn_slot_used;
int fs_dyn_slot_pid;
int fs_dyn_slot_size;
int fs_dyn_slot_base;
int fs_dyn_slot_end;

int kernel_fs_result;
int kernel_fs_context_word;
int kernel_fs_tmp_lo;
int kernel_fs_tmp_hi;
int kernel_fs_tmp_acc;
int kernel_fs_tmp_i;
int kernel_fs_tmp_word;
int kernel_fs_tmp_priority;
int kernel_fs_tmp_pid;
int kernel_fs_tmp_cs;
int kernel_fs_tmp_ds;
int kernel_fs_dma_dest;

void kernel_fs_select_context() {
    kernel_fs_context_word = FS_CONTEXT_WORD + current_pid;
    asm("LDA kernel_fs_context_word");
    asm("INT OUT_INT");
}

int kernel_fs_join_u16(int lo, int hi) {
    kernel_fs_tmp_acc = lo;

    while (hi > 0) {
        kernel_fs_tmp_acc = kernel_fs_tmp_acc + 256;
        hi = hi - 1;
    }

    return kernel_fs_tmp_acc;
}

void kernel_fs_split_out_u16(int lo_word_base, int hi_word_base, int value) {
    kernel_fs_tmp_hi = 0;

    while (value >= 256) {
        value = value - 256;
        kernel_fs_tmp_hi = kernel_fs_tmp_hi + 1;
    }

    kernel_fs_tmp_lo = value;

    kernel_fs_out(lo_word_base + kernel_fs_tmp_lo);
    kernel_fs_out(hi_word_base + kernel_fs_tmp_hi);
}

int kernel_fs_out(int io_word) {
    if (io_word < FS_IO_WORD_MIN) {
        return -1;
    }

    if (io_word > FS_IO_WORD_MAX) {
        return -1;
    }

    kernel_fs_select_context();
    asm("LDA kernel_fs_out_io_word");
    asm("INT OUT_INT");
    return 0;
}

int kernel_fs_in(int io_word) {
    if (io_word < FS_IO_WORD_MIN) {
        return -1;
    }

    if (io_word > FS_IO_WORD_MAX) {
        return -1;
    }

    kernel_fs_select_context();
    asm("LDA kernel_fs_in_io_word");
    asm("INT IN_INT");
    asm("STA kernel_fs_result");
    return kernel_fs_result;
}

int kernel_fs_get_error() {
    return kernel_fs_in(FS_ERROR_WORD);
}

int kernel_fs_get_result() {
    kernel_fs_tmp_lo = kernel_fs_in(FS_RESULT_LO_WORD);
    kernel_fs_tmp_hi = kernel_fs_in(FS_RESULT_HI_WORD);
    return kernel_fs_join_u16(kernel_fs_tmp_lo, kernel_fs_tmp_hi);
}

void kernel_fs_dyn_set_base() {
    asm("MOV fs_dyn_overlay_pool");
    asm("STA fs_dyn_slot_base");
    fs_dyn_slot_end = fs_dyn_slot_base + fs_dyn_slot_size;
}

int kernel_fs_dyn_pcb_uses_slot(int pid) {
    if (pcb[pid].state == STATE_TERMINATED) {
        return 0;
    }

    kernel_fs_tmp_cs = pcb[pid].cs - KERNEL_DS;
    kernel_fs_tmp_ds = pcb[pid].ds - KERNEL_DS;

    if (kernel_fs_tmp_cs >= fs_dyn_slot_base) {
        if (kernel_fs_tmp_cs < fs_dyn_slot_end) {
            return 1;
        }
    }

    if (kernel_fs_tmp_ds >= fs_dyn_slot_base) {
        if (kernel_fs_tmp_ds < fs_dyn_slot_end) {
            return 1;
        }
    }

    return 0;
}

void kernel_fs_dyn_gc() {
    if (fs_dyn_slot_used == 0) {
        return;
    }

    kernel_fs_dyn_set_base();

    kernel_fs_tmp_i = 0;

    while (kernel_fs_tmp_i < MAX_PROCESSES) {
        if (kernel_fs_dyn_pcb_uses_slot(kernel_fs_tmp_i) == 1) {
            return;
        }

        kernel_fs_tmp_i = kernel_fs_tmp_i + 1;
    }

    fs_dyn_slot_used = 0;
    fs_dyn_slot_pid = -1;
    fs_dyn_slot_size = 0;
    fs_dyn_slot_end = fs_dyn_slot_base;
}

int kernel_fs_exec(int priority) {
    /*
     * Retornos:
     *   -2   count/result <= 0
     *   -3   COV maior que a janela dinâmica
     *   -4   magic inválido após DMA
     *   -5   versão inválida após DMA
     *   -6   slot ainda ocupado
     *   -8   kernel_spawn_overlay() falhou
     *   -101..-199 erro vindo do Disk: -(100 + disk_error)
     *
     * Erros novos do Disk:
     *   -112 DMA indisponível
     *   -113 destino DMA fora da RAM
     */
    kernel_fs_tmp_priority = priority;

    kernel_fs_dyn_gc();

    if (fs_dyn_slot_used != 0) {
        return -6;
    }

    /*
     * Calcula o offset da pool no DS.
     */
    fs_dyn_slot_size = FS_DYN_SLOT_WORDS;
    kernel_fs_dyn_set_base();

    /*
     * Destino físico da DMA:
     *   endereço físico = KERNEL_DS + offset da pool no DS
     */
    kernel_fs_dma_dest = KERNEL_DS + fs_dyn_slot_base;

    /*
     * Informa ao Disk:
     *   destino físico
     *   limite da janela
     */
    kernel_fs_split_out_u16(FS_DMA_DEST_LO_WORD, FS_DMA_DEST_HI_WORD, kernel_fs_dma_dest);
    kernel_fs_split_out_u16(FS_DMA_LIMIT_LO_WORD, FS_DMA_LIMIT_HI_WORD, FS_DYN_SLOT_WORDS);

    /*
     * O path já está no TX, enviado por usr_fs.c.
     */
    kernel_fs_out(FS_CMD_WORD + FS_CMD_LOAD_COV_DMA);

    kernel_fs_tmp_word = kernel_fs_get_error();

    if (kernel_fs_tmp_word != 0) {
        fs_dyn_slot_size = 0;
        return 0 - (100 + kernel_fs_tmp_word);
    }

    kernel_fs_tmp_word = kernel_fs_get_result();

    if (kernel_fs_tmp_word <= 0) {
        fs_dyn_slot_size = 0;
        return -2;
    }

    if (kernel_fs_tmp_word > FS_DYN_SLOT_WORDS) {
        fs_dyn_slot_size = 0;
        return -3;
    }

    /*
     * Agora a janela contém exatamente a imagem compacta carregada por DMA.
     */
    fs_dyn_slot_size = kernel_fs_tmp_word;
    kernel_fs_dyn_set_base();

    if (fs_dyn_overlay_pool[0] != FS_COV_MAGIC) {
        fs_dyn_slot_size = 0;
        return -4;
    }

    if (fs_dyn_overlay_pool[1] != FS_COV_VERSION) {
        fs_dyn_slot_size = 0;
        return -5;
    }

    kernel_fs_tmp_pid = kernel_spawn_overlay(fs_dyn_slot_base, kernel_fs_tmp_priority);

    if (kernel_fs_tmp_pid < 0) {
        fs_dyn_slot_size = 0;
        return -8;
    }

    fs_dyn_slot_used = 1;
    fs_dyn_slot_pid = kernel_fs_tmp_pid;

    kernel_need_resched = 1;

    return kernel_fs_tmp_pid;
}

#endif
