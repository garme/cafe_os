# Clone de dados em spawn

`spawn()` aloca pilha própria e clona a área `.data` do processo pai. O filho mantém o mesmo segmento de código, recebe novo DS e não altera as variáveis globais do pai.
