#ifndef SYS_IO_C
#define SYS_IO_C

//----------------------------------------------------------------------
// --- Funções de I/O (Ring 0) ---
//----------------------------------------------------------------------
void kernel_print_char(int ascii_code) {
    asm("MOV 0");
    asm("ADD kernel_print_char_ascii_code");
    asm("INT OUT_INT");    // Acesso direto ao hardware liberado!
}

int kernel_read_char() {
    int val;
    asm("MOV 256");        // Porta 1 do teclado
    asm("INT IN_INT");
    asm("STA isr_tmp_ac"); 
    return isr_tmp_ac;
}



#endif
