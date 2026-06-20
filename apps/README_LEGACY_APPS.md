# Tarefas antigas convertidas para overlays

Este pacote converte `usr_tasks_1.c` até `usr_tasks_17.c` para o novo modelo de aplicação de usuário por overlay.

## Uso rápido

1. Copie todos os arquivos de `apps/` para `SO/apps/`.
2. Abra a IDE.
3. Abra `SO/KERNEL.c`.
4. Clique em `Kernel+Overlay`.
5. Selecione o overlay ou o par de overlays conforme `docs/README_TESTES.md`.

## Patch opcional necessário para spawn/thread

Para testar os overlays que usam `spawn()` ou `thread_create()`, substitua `SO/kernel/sys_proc_spawn.c` pelo arquivo em `kernel_patches/sys_proc_spawn.c`.

Isso corrige a herança de `CS`/`DS` para processos criados a partir de funções dentro de um overlay.

- `legado_18_thread_exit.c`: término explícito de thread e `wait(tid)`.
