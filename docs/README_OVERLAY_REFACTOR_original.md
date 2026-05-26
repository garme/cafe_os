# Refactoring Cariri/GIBÃO: kernel + overlays

## O que mudou

1. **IDE/compilador**
   - Botões: `Full`, `Kernel`, `Overlay`, `Kernel+Overlays`.
   - `CodeGen(target="overlay")` encerra `main()` com syscall `exit`, não com `HALT`.
   - `Semantic(required_entry="main")` mantém o padrão C para overlays.
   - `cariri_overlay_builder.py` permite build por terminal.

2. **User space menor**
   - `usr_syscalls.c` virou agregador compatível.
   - Novos módulos:
     - `usr_proc.c`: yield/exit/wait/kill/sleep/alarm/pause/spawn legado
     - `usr_io.c`: print_char/read_char
     - `usr_stdio.c`: printstr/printint/readint/readstr
     - `usr_sync.c`: semáforo/mutex
     - `usr_pipe.c`, `usr_shm.c`, `usr_msg.c`, `usr_signal.c`, `usr_thread.c`
   - Overlays novos devem incluir só o necessário.

3. **Kernel menor/contextualizado**
   - `sys_ipc.c` virou agregador compatível.
   - Novos módulos: `sys_shm.c`, `sys_pipe.c`, `sys_sync.c`, `sys_proc.c`, `sys_signal.c`, `sys_io.c`, `sys_msg.c`, `sys_thread.c`, `sys_overlay.c`.

4. **Assembler**
   - Novo `export_overlay_image()` e `export_overlay_initd(label)`.
   - Exporta text/data sem padding de 4 KiB e bss como tamanho.

5. **CPU**
   - Nova interrupção privilegiada `CTXSW_INT = 27`.
   - Entrada de trap/timer/fault troca para `CS=0`, `DS=4096`, `SS=4096`.
   - `CTXSW` restaura atomimente `PC, CS, DS, SS, SP, AC, FLAGS` a partir de bloco no DS do kernel.

## Uso recomendado

### Overlay mínimo

```c
#include "usr_stdio.c"
#include "usr_proc.c"

int counter;

void main() {
    counter = 0;
    while (1) {
        printstr("APP ");
        printint(counter);
        print_char(10);
        counter = counter + 1;
        sleep(5);
    }
}
```

### Kernel base

Use `sys_main_overlay.c`, não `sys_main_legacy.c`.

### Build por terminal

```bash
python3 IDE_CompiladorC/build_tools/cariri_overlay_builder.py \
    SO/kernel/core/sys_main_overlay.c \
    SO/examples/overlays/app_counter_overlay.c \
    > SO/examples/build_outputs/final_os_generated.asm
```

## Observação importante

A execução de overlay está implementada como **overlay in-place**: o texto do overlay é executado do bloco injetado em `.data`, e `DS` aponta para a área de dados/bss daquele overlay. Para múltiplas instâncias independentes do mesmo overlay, o próximo passo é copiar `text/data/bss` para um slot de overlay por processo antes de chamar `create_process_overlay()`.
