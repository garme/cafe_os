# spawn() com clone de .data

Perfil mantido:

- máximo de 3 tarefas simultâneas;
- 4K palavras para código;
- 4K palavras para dados, heap e pilhas;
- pilha padrão de 64 palavras por tarefa.

## Semântica

`spawn(task_addr, priority)` cria um processo lógico com:

- PID próprio;
- pilha própria no heap;
- mesmo CS do pai, pois `task_addr` é um offset no código do mesmo overlay;
- nova cópia da área `.data` do pai;
- DS apontando para a cópia privada.

`thread_create(task_addr, priority)` cria uma thread com:

- PID próprio;
- pilha própria no heap;
- mesmo CS e mesmo DS do pai;
- compartilhamento intencional dos globais.

## Custo de heap

Para cada `spawn()`:

```text
custo = data_size + 2 + 64 + 2
      = data_size + 68 palavras
```

Para cada `thread_create()`:

```text
custo = 64 + 2 = 66 palavras
```

Com `HEAP_SIZE = 512`, o clone de `.data` deve permanecer pequeno. Aplicações com muitos globais
ou strings longas reduzem rapidamente o número de processos simultâneos.

## Liberação

Cada tarefa libera sempre sua própria pilha. A cópia privada de `.data` é liberada quando a última
tarefa que compartilha aquele `mem_base` termina. Isso evita liberar a `.data` enquanto ainda houver
threads do mesmo processo usando os globais.
