# SO Cariri reorganizado para Kernel + Overlays

Esta estrutura foi organizada para funcionar diretamente com a nova IDE/Compilador, sem passos manuais para gerar includes ou tabelas de overlays.

## Fluxo principal

### Compilar somente o kernel

1. Abra `KERNEL.c` na IDE.
2. Clique em `Kernel`.

Nesse modo, `kernel/sys_overlays.inc` usa um fallback vazio e nenhum processo de usuário é iniciado no boot.

### Compilar um overlay isolado

1. Abra um arquivo em `apps/`, por exemplo `apps/app_hello.c`.
2. Clique em `Overlay`.

Os overlays usam `main()` normal, como em C padrão.

### Compilar Kernel + Overlay

1. Abra `KERNEL.c` na IDE.
2. Clique em `Kernel+Overlay`.
3. Selecione um ou mais arquivos em `apps/`.
4. A IDE faz todo o restante automaticamente:
   - compila o kernel;
   - gera `kernel/sys_overlays.inc` virtual em memória;
   - compila cada overlay selecionado;
   - monta os overlays;
   - injeta as imagens no `.data` do ASM final;
   - gera o ASM monolítico final do SO.

Não execute script externo para gerar `sys_overlays.inc`. O arquivo físico é apenas fallback para compilar o kernel isolado.

## Estrutura

```text
SO/
├── KERNEL.c                  # arquivo de entrada do kernel na IDE
├── kernel/                   # núcleo do SO
│   ├── sys_main.c
│   ├── sys_core.h
│   ├── sys_sched_rr.c
│   ├── sys_mem.c
│   ├── sys_ipc.c
│   ├── sys_overlay.c
│   └── sys_overlays.inc      # fallback vazio; a IDE substitui em memória
├── user/                     # bibliotecas de user space para overlays
│   ├── usr_proc.c
│   ├── usr_io.c
│   ├── usr_stdio.c
│   ├── usr_sync.c
│   ├── usr_pipe.c
│   └── usr_syscalls.c
├── apps/                     # overlays/aplicações de usuário
│   ├── _template_minimal.c
│   ├── _template_stdio.c
│   ├── app_counter.c
│   └── app_hello.c
├── legacy/                   # fontes antigos preservados
├── docs/
└── build/
```

## Criar nova aplicação de usuário

Copie um template:

```bash
cp apps/_template_stdio.c apps/minha_app.c
```

Edite apenas `main()`:

```c
#include "../user/usr_stdio.c"
#include "../user/usr_proc.c"

void main() {
    printstr("Minha app\n");
    exit();
}
```

Para reduzir o tamanho do overlay, inclua apenas os módulos usados:

- ciclo de vida/processos: `../user/usr_proc.c`
- I/O char: `../user/usr_io.c`
- print/read formatado: `../user/usr_stdio.c`
- semáforo/mutex: `../user/usr_sync.c`
- pipe: `../user/usr_pipe.c`
- shared memory: `../user/usr_shm.c`
- mensagens: `../user/usr_msg.c`
- sinais: `../user/usr_signal.c`
- threads: `../user/usr_thread.c`

`../user/usr_syscalls.c` continua existindo como agregador de compatibilidade, mas gera overlays maiores.

## Rede TCP cliente/servidor

A biblioteca `user/usr_net.c` oferece cliente e servidor TCP usando somente duas syscalls de baixo nível (`30` e `31`). O kernel seletivo inclui `kernel/sys_net.c` apenas quando um overlay usa rede.

A versão atual usa a porta privada **63** para selecionar um contexto de registradores por PID. Antes de cada `IN`/`OUT`, o kernel informa o processo atual ao periférico. Isso impede que cliente e servidor troquem acidentalmente o registrador `SOCKET`, o endereço remoto ou os resultados de comandos.

Exemplos:

- `apps/app_net_server.c`: servidor de eco em `127.0.0.1:8081`;
- `apps/app_net_client.c`: cliente pareado para o servidor acima;
- `apps/app_net_client_host.c`: cliente para o servidor externo em `127.0.0.1:8080`;
- `apps/_template_network_client.c`;
- `apps/_template_network_server.c`.

Para testar os dois overlays no mesmo CompSim, selecione primeiro o servidor e depois o cliente. A IDE exibe o perfil detectado, as linhas ASM, o uso dos segmentos de 4096 palavras e um aviso quando a margem fica abaixo de 512 palavras.

Consulte `../docs/README_REDE_SO.md` e `build/RELATORIO_IMPACTO_REDE_4K.md`.
