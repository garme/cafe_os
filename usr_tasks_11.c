#include "usr_syscalls.c"

int my_file_buffer[32];

int success;

naked void task_a() {
    int success;

    // 1. Formatar
    fs_format();

    // 2. Gravar apenas a primeira palavra
    my_file_buffer[0] = 777;
    success = fs_write(1, my_file_buffer);

    // 3. Sabotar RAM (Limpar buffer)
    my_file_buffer[0] = 0;

    // 4. Ler do disco
    success = fs_read(1, my_file_buffer);

    // 5. Validar (Imprime o valor recuperado e encerra)
    printint(my_file_buffer[0]); // Deve imprimir 777
    
    exit();
}
