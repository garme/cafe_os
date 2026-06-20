# thread_exit

`thread_exit()` encerra somente uma tarefa criada por `thread_create()`, libera sua pilha e acorda processos em `wait(tid)`. Nesta versão a syscall é **32**, pois 30 e 31 pertencem ao driver genérico de rede (`net_out` e `net_in`).
