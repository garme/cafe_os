# Overlays convertidos do modelo antigo de tarefas

Copie os arquivos de `apps/` para a pasta `SO/apps/` do pacote atual da IDE/SO.
Na IDE, abra `SO/KERNEL.c`, clique em `Kernel+Overlay` e selecione os overlays indicados.

## Mapeamento e ordem de seleção

| Teste antigo | Overlays novos | Ordem de seleção |
|---|---|---|
| usr_tasks_1 | legado_01_counter_a.c, legado_01_counter_b.c | A depois B |
| usr_tasks_2 | legado_02_mutex_a.c, legado_02_mutex_b.c | A depois B |
| usr_tasks_3 | legado_03_semaphore_a.c, legado_03_semaphore_b.c | A depois B |
| usr_tasks_4 | legado_04_exit_a.c, legado_04_exit_b.c | A depois B |
| usr_tasks_5 | legado_05_wait_a.c, legado_05_wait_b.c | A deve ser PID 0, B deve ser PID 1 |
| usr_tasks_6 | legado_06_kill_a.c, legado_06_kill_b.c | A deve ser PID 0, B deve ser PID 1 |
| usr_tasks_7 | legado_07_signal_a.c, legado_07_signal_b.c | A deve ser PID 0, B deve ser PID 1 |
| usr_tasks_8 | legado_08_pause_a.c, legado_08_pause_b.c | A deve ser PID 0, B deve ser PID 1 |
| usr_tasks_9 | legado_09_sleep_lebre.c, legado_09_sleep_tartaruga.c | Lebre depois Tartaruga |
| usr_tasks_10 | legado_10_pipe_produtor.c, legado_10_pipe_consumidor.c | Produtor depois Consumidor |
| usr_tasks_11 | legado_11_shm_a.c, legado_11_shm_b.c | A depois B |
| usr_tasks_12 | legado_12_spawn.c | apenas este overlay |
| usr_tasks_13 | legado_13_spawn_loop.c | apenas este overlay |
| usr_tasks_14 | legado_14_msg_spawn.c | apenas este overlay |
| usr_tasks_15 | legado_15_thread_inc_dec.c | apenas este overlay |
| usr_tasks_16 | legado_16_keyboard_echo.c | apenas este overlay |
| usr_tasks_17 | legado_17_thread_prod_cons.c | apenas este overlay |

## Observações importantes

1. Os arquivos foram convertidos para o padrão novo: cada aplicação de usuário tem `void main()`.
2. Os arquivos antigos com `task_a()` e `task_b()` viraram overlays separados quando eram processos independentes.
3. Testes que dependem de PID fixo preservam a lógica antiga usando a ordem de seleção dos overlays. Se A precisa ser PID 0 e B PID 1, selecione A antes de B na IDE.
4. Os testes `spawn` e `thread_create` precisam do patch `kernel_patches/sys_proc_spawn.c`, porque filhos criados a partir de uma função dentro do overlay precisam herdar `CS` e `DS` do processo chamador.
5. Recomenda-se RAM de 8192 linhas ou maior para o modelo com MPU + overlays.
