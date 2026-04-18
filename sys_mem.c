// =======================================================
// mm_heap.c - Gerenciador de Memória Dinâmica (First-Fit)
// =======================================================

// Força o compilador a reservar 1000 posições de memória
int os_heap[1000];

int HEAP_START;
int HEAP_SIZE  = 1000;  // Tamanho total do Heap

// Inicializa o grande bloco de memória livre
void init_heap() {
    // O cabeçalho ocupa 2 palavras: [TAMANHO, ESTADO_LIVRE]
    ram[HEAP_START] = HEAP_SIZE; // Tamanho total do bloco inicial
    ram[HEAP_START + 1] = 1;     // 1 = Livre, 0 = Ocupado
}

// O famoso Malloc! Retorna um ponteiro para a memória alocada
int malloc(int size) {
    // --- DECLARAÇÕES NO TOPO DA FUNÇÃO ---
    int ptr;
    int needed_size;
    int block_size;
    int is_free;
    int remaining;
    int next_ptr;
    // -------------------------------------

    ptr = HEAP_START;
    needed_size = size;
    needed_size = needed_size + 2; // Tamanho pedido + 2 palavras de cabeçalho
    
    while (ptr < (HEAP_START + HEAP_SIZE)) {
        block_size = ram[ptr];
        is_free = ram[ptr + 1];
        
        // Se o bloco está livre e tem espaço suficiente
        if (is_free == 1) {
            if (block_size >= needed_size) {
                // Aloca o bloco (marca como ocupado)
                ram[ptr + 1] = 0; 
                
                remaining = block_size - needed_size;
                
                // Se sobrar espaço suficiente para formar outro bloco, fatiamos!
                if (remaining > 2) {
                    ram[ptr] = needed_size; // Encurta o bloco atual
                    
                    // Cria o cabeçalho do novo bloco livre logo a seguir
                    next_ptr = ptr + needed_size;
                    ram[next_ptr] = remaining;
                    ram[next_ptr + 1] = 1; // Livre
                }
                
                // Retorna o endereço logo após o cabeçalho (área útil para o utilizador)
                return ptr + 2; 
            }
        }
        
        // Salta para o próximo bloco usando a matemática de ponteiros
        ptr = ptr + block_size;
    }
    
    return 0; // Erro: Out of Memory (OOM)
}

// Libera a memória alocada
void free(int ptr) {
    // Declarações no topo
    int header_ptr;
    
    // Recua 2 posições para encontrar o cabeçalho e marca como livre
    header_ptr = ptr - 2;
    ram[header_ptr + 1] = 1; 
}
