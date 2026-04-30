// --- sys_disk.c ---
int disk_io_buffer[32]; // Buffer de DMA dinâmico
int io_buffer_addr;

// Globais cacheadas para economizar instruções
int disk_cmd_low;
int disk_cmd_high;

void init_disk_subsystem() {
    asm("MOV disk_io_buffer");
    asm("STA io_buffer_addr");
    
    int low;
    int high;
    
    low = io_buffer_addr & 255;
    disk_cmd_low = 7936 | low;     // 7936 = Porta 31 << 8

    high = io_buffer_addr >> 8;
    high = high & 255;
    disk_cmd_high = 8448 | high;   // 8448 = Porta 33 << 8
}

void kernel_disk_read_sector(int sector) {
    int cmd_sec;
    int cmd_read;
    
    cmd_sec = 7680 | sector;       // 7680 = Porta 30 << 8
    cmd_read = 8192 | 1;           // 8192 = Porta 32 << 8

    asm("LDA kernel_disk_read_sector_cmd_sec");  asm("INT OUT_INT"); 
    asm("LDA disk_cmd_low");                     asm("INT OUT_INT");
    asm("LDA disk_cmd_high");                    asm("INT OUT_INT");
    asm("LDA kernel_disk_read_sector_cmd_read"); asm("INT OUT_INT");
}

void kernel_disk_write_sector(int sector) {
    int cmd_sec;
    int cmd_write;
    
    cmd_sec = 7680 | sector;
    cmd_write = 8192 | 2;

    asm("LDA kernel_disk_write_sector_cmd_sec");   asm("INT OUT_INT"); 
    asm("LDA disk_cmd_low");                       asm("INT OUT_INT");
    asm("LDA disk_cmd_high");                      asm("INT OUT_INT");
    asm("LDA kernel_disk_write_sector_cmd_write"); asm("INT OUT_INT");
}
