#ifndef SYS_OVERLAYS_INC
#define SYS_OVERLAYS_INC

// Fallback vazio para compilação do kernel isolado.
//
// No modo Kernel+Overlay, a IDE/Compilador NÃO usa este conteúdo físico.
// Ela gera automaticamente um sys_overlays.inc virtual em memória com os
// overlays selecionados na janela de seleção.
//
// Fluxo esperado:
//   1. Abra KERNEL.c na IDE.
//   2. Clique em Kernel+Overlay.
//   3. Selecione um ou mais arquivos em apps/.
//   4. A IDE gera boot_overlays() automaticamente.

void boot_overlays() {
    // Nenhum overlay no modo Kernel isolado.
}

#endif
