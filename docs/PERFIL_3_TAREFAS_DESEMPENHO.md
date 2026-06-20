# Perfil de três tarefas

O perfil conservador mantém `MAX_PROCESSES = 3`, pilhas de 64 palavras e heap de 512 palavras dentro do segmento de dados de 4K. O kernel usa `kernel_need_resched` para evitar chamadas ao escalonador após syscalls leves.
