# Liberação de recursos de processos e threads

O kernel centraliza a liberação em `kernel_release_process_resources()`. Cada tarefa possui pilha própria (`stack_mem`). Processos criados por `spawn()` possuem cópia privada da área de dados; threads compartilham a área de dados do pai, mas nunca a pilha. A área compartilhada só é liberada quando a última tarefa viva que a referencia termina.
