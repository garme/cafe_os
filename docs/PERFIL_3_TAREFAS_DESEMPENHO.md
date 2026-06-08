# Perfil 4K / 3 tarefas — CAFE OS

Este perfil mantém a restrição arquitetural original:

- 4K palavras para código (`CS`);
- 4K palavras para dados + heap + pilhas (`DS/SS`);
- máximo de 3 tarefas simultâneas (`MAX_PROCESSES = 3`);
- pilha padrão de 64 palavras por tarefa.

## Diferença entre `spawn()` e `thread_create()`

### `spawn(task_addr, priority)`

Cria um processo lógico:

- recebe PID próprio;
- possui estado próprio no PCB;
- possui pilha própria alocada no heap;
- pode ser esperado com `wait(pid)`;
- pode ser encerrado com `kill(pid, SIGKILL)`;
- não compartilha a pilha com o pai.

No modelo atual, como não há MMU e o limite de dados é de 4K, `spawn()` herda `CS/DS` do processo chamador. Assim, globais do overlay ainda pertencem ao mesmo segmento lógico. A separação forte de dados exigiria cópia/clonagem da área `.data`, o que consome heap e deve ser tratado como evolução futura.

### `thread_create(task_addr, priority)`

Cria uma thread leve:

- recebe PID próprio;
- possui pilha própria alocada no heap;
- compartilha o domínio de memória do pai (`mem_base`);
- compartilha intencionalmente globais do overlay;
- deve usar semáforos/mutex ao acessar dados compartilhados.

## Heap

O heap continua com 512 palavras. Cada pilha de 64 palavras consome 66 palavras reais, porque `malloc()` usa 2 palavras de cabeçalho.

Com 3 tarefas ativas:

```text
3 * (64 + 2) = 198 palavras de heap
```

Restam cerca de 314 palavras para memória compartilhada (`shmget`) e fragmentação.

## Otimização de desempenho

O kernel não chama mais `schedule()` em toda syscall. Syscalls leves como `print_char`, `read_char`, `get_signal`, `msg_send`, `msg_recv`, `shmget`, `signal` e `sigreturn` retornam diretamente ao processo atual.

Syscalls que bloqueiam/finalizam/cedem CPU marcam `kernel_need_resched = 1`.

O relógio lógico (`kernel_tick_update`) foi movido para o handler de timer, evitando que o tempo do sistema avance a cada caractere impresso.
