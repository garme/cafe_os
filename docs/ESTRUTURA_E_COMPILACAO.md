# Estrutura e compilação

## Entrada do kernel

Abra `KERNEL.c` na IDE. Ele inclui `kernel/sys_main.c` e preserva os includes relativos.

## Kernel isolado

Use o botão `Kernel`.

## Overlay isolado

Abra um arquivo de `apps/` e use o botão `Overlay`.

## Kernel + overlays

Use somente a IDE:

1. Abra `KERNEL.c`.
2. Clique em `Kernel+Overlay`.
3. Selecione os overlays em `apps/`.

A IDE gera automaticamente o include virtual `kernel/sys_overlays.inc` com a função `boot_overlays()` correspondente aos overlays selecionados. O arquivo físico `kernel/sys_overlays.inc` é apenas fallback vazio para permitir compilar o kernel sozinho.
