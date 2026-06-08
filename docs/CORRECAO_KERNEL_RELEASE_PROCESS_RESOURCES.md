# Correção: kernel_release_process_resources não declarada

A função `kernel_release_process_resources()` foi movida para `kernel/sys_proc.c`, um módulo-base sempre incluído no kernel seletivo.

Motivo: `exit()`, `kill()`, `thread_exit()` e `sys_overlay.c` dependem de rotinas comuns de processo, mesmo quando a aplicação do usuário não usa `spawn()`.

Antes, essas rotinas estavam dentro de `sys_proc_spawn.c`; assim, ao compilar uma aplicação simples que usava apenas `print_char()` e `read_char()`, a IDE podia excluir `sys_proc_spawn.c`, deixando `kernel_release_process_resources()` e `create_process_ex()` invisíveis para o analisador semântico.

Arquitetura corrigida:

- `sys_proc.c`: primitivas comuns de processo; sempre incluído.
- `sys_proc_spawn.c`: apenas a syscall `spawn()`.
- `sys_proc_exit.c`, `sys_proc_kill.c`, `sys_thread_exit.c`: usam `kernel_release_process_resources()` definida em `sys_proc.c`.
- `sys_overlay.c`: usa `create_process_ex()` definida em `sys_proc.c`.
