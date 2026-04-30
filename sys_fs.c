// =======================================================
// sys_fs.c - Sistema de Arquivos Contíguo (Ring 0)
// =======================================================

int FS_BITMAP_SECTOR = 0;
int FS_DIR_START     = 1;
int FS_DIR_END       = 4;
int FS_DATA_START    = 5;

// Utilitário Otimizado com Ponteiros
void memcpy(int* dest, int* src, int size) {
    int i = 0;
    while(i < size) {
        *dest = *src;
        dest = dest + 1;
        src = src + 1;
        i = i + 1;
    }
}

void kernel_fs_format() {
    int s;
    int i;
    int* ptr;

    // Limpa o buffer rapidamente
    ptr = disk_io_buffer;
    i = 0;
    while(i < 32) {
        *ptr = 0;
        ptr = ptr + 1;
        i = i + 1;
    }
    
    disk_io_buffer[0] = 31; 
    kernel_disk_write_sector(FS_BITMAP_SECTOR);
    
    disk_io_buffer[0] = 0; 
    s = FS_DIR_START;
    while(s <= FS_DIR_END) {
        kernel_disk_write_sector(s);
        s = s + 1;
    }
}

// Leitura Otimizada com Ponteiros Diretos
int kernel_fs_read_block(int file_id, int block_offset, int* user_buffer) {
    int s;
    int i;
    int found = 0;
    int target_sector = -1;
    int* ptr;
    int status; 
    int c_id;   
    int s_sec;  
    int fsize;  
    
    s = FS_DIR_START;
    while(s <= FS_DIR_END && found == 0) {
        kernel_disk_read_sector(s);
        
        ptr = disk_io_buffer; // Ponteiro no início do setor lido
        i = 0;
        while(i < 8 && found == 0) {
            // Em vez de [i], [i+1], lemos sequencialmente e avançamos o ponteiro
            status = *ptr;     ptr = ptr + 1;
            c_id   = *ptr;     ptr = ptr + 1;
            s_sec  = *ptr;     ptr = ptr + 1;
            fsize  = *ptr;     ptr = ptr + 1;
            
            if (status == 1 && c_id == file_id && block_offset < fsize) {
                target_sector = s_sec + block_offset;
                found = 1;
            }
            i = i + 1;
        }
        s = s + 1;
    }

    if (found == 0) { return 0; } 

    kernel_disk_read_sector(target_sector);
    memcpy(user_buffer, disk_io_buffer, 32);
    return 1;
}

// Escrita Otimizada com Ponteiros Diretos
int kernel_fs_write_block(int file_id, int* user_buffer) {
    int s;
    int i;
    int dir_sector = -1;
    int entry_offset = -1;
    int* ptr;
    int status;
    int c_id;
    
    s = FS_DIR_START;
    while(s <= FS_DIR_END && dir_sector == -1) {
        kernel_disk_read_sector(s);
        
        ptr = disk_io_buffer;
        i = 0;
        while(i < 8 && dir_sector == -1) {
            status = *ptr;  ptr = ptr + 1;
            c_id   = *ptr;  ptr = ptr + 1;
            ptr = ptr + 2; // Pula start_sec e size
            
            if (status == 0 || c_id == file_id) { 
                dir_sector = s;
                // Calculamos o offset base deste arquivo no buffer (i * 4)
                entry_offset = i + i + i + i; 
            }
            i = i + 1;
        }
        s = s + 1;
    }
    
    if (dir_sector == -1) { return 0; } 

    int data_sector = FS_DATA_START + file_id;
    
    memcpy(disk_io_buffer, user_buffer, 32);
    kernel_disk_write_sector(data_sector);
    
    kernel_disk_read_sector(dir_sector);
    
    // Atualiza metadados apontando para o offset que salvamos
    ptr = disk_io_buffer + entry_offset;
    *ptr = 1;            ptr = ptr + 1; // Status
    *ptr = file_id;      ptr = ptr + 1; // ID
    *ptr = data_sector;  ptr = ptr + 1; // Start Sector
    *ptr = 1;                           // Size
    
    kernel_disk_write_sector(dir_sector);
    return 1;
}
