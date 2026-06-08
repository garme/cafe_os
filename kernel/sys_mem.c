// =======================================================
// mm_heap.c - Gerenciador de Memória Dinâmica (First-Fit)
// =======================================================

int os_heap[512];
int HEAP_START;
int HEAP_SIZE = 512;

void init_heap() {
    ram[HEAP_START] = HEAP_SIZE;
    ram[HEAP_START + 1] = 1;
}

int malloc(int size) {
    int ptr;
    int needed_size;
    int block_size;
    int is_free;
    int remaining;
    int next_ptr;

    ptr = HEAP_START;
    needed_size = size;
    needed_size = needed_size + 2;

    while (ptr < (HEAP_START + HEAP_SIZE)) {
        block_size = ram[ptr];
        is_free = ram[ptr + 1];

        if (is_free == 1) {
            if (block_size >= needed_size) {
                ram[ptr + 1] = 0;
                remaining = block_size - needed_size;

                if (remaining > 2) {
                    ram[ptr] = needed_size;
                    next_ptr = ptr + needed_size;
                    ram[next_ptr] = remaining;
                    ram[next_ptr + 1] = 1;
                }

                return ptr + 2;
            }
        }

        ptr = ptr + block_size;
    }

    return 0;
}

void free(int ptr) {
    int header_ptr;

    if (ptr == 0) {
        return;
    }

    header_ptr = ptr - 2;
    ram[header_ptr + 1] = 1;
    kernel_defrag();
}

void kernel_defrag() {
    int ptr;
    int block_size;
    int is_free;
    int next_ptr;
    int next_is_free;
    int next_size;
    int merged;

    ptr = HEAP_START;

    while (ptr < (HEAP_START + HEAP_SIZE)) {
        block_size = ram[ptr];
        is_free = ram[ptr + 1];

        if (is_free == 1) {
            next_ptr = ptr + block_size;
            merged = 0;

            if (next_ptr < (HEAP_START + HEAP_SIZE)) {
                next_is_free = ram[next_ptr + 1];
                if (next_is_free == 1) {
                    next_size = ram[next_ptr];
                    ram[ptr] = block_size + next_size;
                    merged = 1;
                }
            }

            if (merged == 0) {
                ptr = next_ptr;
            }
        } else {
            ptr = ptr + block_size;
        }
    }
}
