# Catálogo de aplicações do CAFE OS / GUILIX

Este diretório reúne aplicações atuais, exemplos de rede, modelos e as tarefas históricas convertidas para overlays. Todos os arquivos `legado_*.c` possuem `void main()` e podem ser selecionados diretamente no modo **Kernel+Overlay** da IDE.

## Aplicações básicas

| Arquivo | Recurso principal |
|---|---|
| `app_hello.c` | saída simples e término |
| `app_counter.c` | laço e saída numérica |
| `legado_19_shell.c` | teclado, terminal, edição de linha e comandos interativos |

## Rede TCP e UDP

| Arquivo | Recurso principal |
|---|---|
| `app_net_client.c` | cliente TCP local |
| `app_net_server.c` | servidor TCP de eco |
| `app_net_server_loop.c` | servidor TCP persistente |
| `app_net_client_host.c` | cliente TCP para serviço do host |
| `app_net_echo.c` | exemplo TCP de eco |
| `app_net_udp_client.c` | cliente UDP |
| `app_net_udp_server.c` | servidor UDP de eco |

## Aplicações legadas convertidas

| Grupo | Arquivos | Recursos demonstrados |
|---:|---|---|
| 01 | `legado_01_counter_a.c`, `legado_01_counter_b.c` | escalonamento e concorrência |
| 02 | `legado_02_mutex_a.c`, `legado_02_mutex_b.c` | mutex |
| 03 | `legado_03_semaphore_a.c`, `legado_03_semaphore_b.c` | semáforo |
| 04 | `legado_04_exit_a.c`, `legado_04_exit_b.c` | término de processo |
| 05 | `legado_05_wait_a.c`, `legado_05_wait_b.c` | `wait(pid)` |
| 06 | `legado_06_kill_a.c`, `legado_06_kill_b.c` | `kill()` e `SIGKILL` |
| 07 | `legado_07_signal_a.c`, `legado_07_signal_b.c` | handlers, `SIGTERM` e `sigreturn()` |
| 08 | `legado_08_pause_a.c`, `legado_08_pause_b.c` | `pause()`, `SIGCONT` e espera |
| 09 | `legado_09_sleep_lebre.c`, `legado_09_sleep_tartaruga.c` | `sleep()` e temporização |
| 10 | `legado_10_pipe_produtor.c`, `legado_10_pipe_consumidor.c` | pipe produtor–consumidor |
| 11 | `legado_11_shm_a.c`, `legado_11_shm_b.c` | memória compartilhada |
| 12 | `legado_12_spawn.c` | criação dinâmica com `spawn()` |
| 13 | `legado_13_spawn_loop.c` | sucessivas criações e esperas |
| 14 | `legado_14_msg_spawn.c` | mensageria e processo criado dinamicamente |
| 15 | `legado_15_thread_inc_dec.c` | duas threads e estado compartilhado |
| 16 | `legado_16_keyboard_echo.c` | teclado e vídeo |
| 17 | `legado_17_thread_prod_cons.c` | threads produtor/consumidor |
| 19 | `legado_19_shell.c` | mini shell interativo |

## Ordem de seleção e PIDs

Nos testes formados por dois overlays, selecione os arquivos na ordem indicada na tabela. O primeiro overlay recebe PID 0 e o segundo recebe PID 1. Essa ordem é relevante para os testes de `wait`, `kill` e sinais.

## Fontes históricas originais

As versões anteriores à conversão estão preservadas em:

```text
SO/legacy/original_tasks/
SO/legacy/original_tasks_normalized/
```

A primeira pasta conserva os nomes dos arquivos recebidos. A segunda contém uma seleção normalizada de `usr_tasks_01.c` a `usr_tasks_17.c`.

## Validação

O teste reproduzível é:

```bash
cd <raiz-do-pacote>
PYTHONPATH=IDE_CompiladorC python3 tests/test_legacy_apps_and_resources.py
```

Foram validados 29 overlays legados e 20 cenários representativos de Kernel+Overlay. O relatório detalhado é gravado em `SO/build/legacy_resources_regression.json`.

- `legado_18_thread_exit.c`: término explícito de thread e `wait(tid)`.
