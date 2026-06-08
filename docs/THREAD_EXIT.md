# `thread_exit()` no CAFE_OS

## Objetivo

`thread_exit()` encerra explicitamente a thread chamadora sem encerrar o processo lógico que criou o domínio de memória.

Ela foi adicionada como syscall `30`.

## Diferença para `exit()`

| Chamada | Uso recomendado | Efeito |
|---|---|---|
| `exit()` | Processo/tarefa principal | Encerra a tarefa atual como processo lógico |
| `thread_exit()` | Funções executadas por `thread_create()` | Encerra apenas a thread chamadora |

Em ambos os casos, o kernel libera a pilha própria da tarefa. A diferença importante é conceitual: `thread_exit()` valida `is_thread == 1`; se for chamada por um processo normal, retorna `-1` e não mata o processo por engano.

## Recursos liberados

A thread possui pilha própria (`stack_mem`), alocada no heap. Ao terminar, o kernel libera essa pilha.

A área `.data`/`mem_base` normalmente é compartilhada com o processo pai. Ela não é liberada prematuramente; o kernel só libera uma `.data` alocada no heap quando não há mais nenhuma tarefa viva compartilhando o mesmo `mem_base`.

## Uso em user space

```c
#include "../user/usr_thread.c"

void minha_thread() {
    while (1) {
        // trabalho da thread
        break;
    }
    thread_exit();
}
```

Se a função da thread simplesmente executar `return`, o comportamento depende do frame inicial da tarefa e pode cair em retorno inválido. Por isso, para threads com fim natural, use sempre `thread_exit()`.
