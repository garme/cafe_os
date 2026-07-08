#ifndef USR_FS_C
#define USR_FS_C

#include "../user/usr_runtime.c"

/*
 * usr_fs.c - API de usuário para o disco virtual do CAFE OS/GUILIX.
 *
 * Compatibilidade:
 * - usa somente int, ponteiro char*, arrays por índice, while e asm();
 * - não usa struct, enum, malloc, switch, sizeof nem multiplicação;
 * - segue o ABI de syscall usado por usr_io.c e usr_yield.c;
 * - fs_sys_out = syscall 33;
 * - fs_sys_in  = syscall 34.
 *
 * Palavra de I/O:
 *   io_word = porta*256 + valor
 *
 * Para evitar multiplicação no compilador, as bases das portas já ficam
 * pré-calculadas como constantes globais mutáveis.
 */

/* Portas 64..79 */
int FS_CMD        = 16384;  /* 64 * 256 */
int FS_ARG0       = 16640;  /* 65 * 256 */
int FS_ARG1       = 16896;  /* 66 * 256 */
int FS_ARG2       = 17152;  /* 67 * 256 */
int FS_TX_BYTE    = 17408;  /* 68 * 256 */
int FS_RX_BYTE    = 17664;  /* 69 * 256 */
int FS_RESULT_LO  = 17920;  /* 70 * 256 */
int FS_RESULT_HI  = 18176;  /* 71 * 256 */
int FS_ERROR      = 18432;  /* 72 * 256 */
int FS_RX_COUNT_LO = 18688; /* 73 * 256 */
int FS_RX_COUNT_HI = 18944; /* 74 * 256 */
int FS_VERSION    = 19200;  /* 75 * 256 */

/* Comandos */
int FS_CMD_RESET      = 1;
int FS_CMD_MOUNT      = 2;
int FS_CMD_CLEAR_TX   = 3;
int FS_CMD_OPEN_READ  = 4;
int FS_CMD_OPEN_WRITE = 5;
int FS_CMD_CLOSE      = 6;
int FS_CMD_READ_BYTE  = 7;
int FS_CMD_WRITE_BYTE = 8;
int FS_CMD_LIST       = 9;
int FS_CMD_EXISTS     = 10;
int FS_CMD_DELETE     = 11;
int FS_CMD_READ_ALL   = 12;
int FS_CMD_MKDIR      = 13;

/* Erros */
int FS_OK = 0;
int FS_ERR_EOF = 9;

/* Temporários globais para evitar colisões de locais em compiladores simples. */
int fs_tmp_lo;
int fs_tmp_hi;
int fs_tmp_acc;
int fs_tmp_i;
int fs_tmp_c;
int fs_tmp_count;
int fs_tmp_fd;

int fs_sys_out(int io_word) {
    asm("LDA fs_sys_out_io_word");
    asm("SOP PUSH_OP");
    asm("MOV 33");
    asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
    asm("STA sys_ret_val");
    return sys_ret_val;
}

int fs_sys_in(int io_word) {
    asm("LDA fs_sys_in_io_word");
    asm("SOP PUSH_OP");
    asm("MOV 34");
    asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
    asm("STA sys_ret_val");
    return sys_ret_val;
}

void fs_command(int command) {
    fs_sys_out(FS_CMD + command);
}

void fs_reset() {
    fs_command(FS_CMD_RESET);
}

void fs_clear_tx() {
    fs_command(FS_CMD_CLEAR_TX);
}

void fs_set_arg0(int value) {
    fs_sys_out(FS_ARG0 + value);
}

void fs_set_arg1(int value) {
    fs_sys_out(FS_ARG1 + value);
}

void fs_set_arg2(int value) {
    fs_sys_out(FS_ARG2 + value);
}

void fs_send_byte(int value) {
    fs_sys_out(FS_TX_BYTE + value);
}

void fs_send_text(char* text) {
    fs_tmp_i = 0;
    fs_tmp_c = text[fs_tmp_i];

    while (fs_tmp_c != 0) {
        fs_send_byte(fs_tmp_c);
        fs_tmp_i = fs_tmp_i + 1;
        fs_tmp_c = text[fs_tmp_i];
    }

    fs_send_byte(0);
}

int fs_status() {
    return fs_sys_in(FS_CMD);
}

int fs_error() {
    return fs_sys_in(FS_ERROR);
}

int fs_version() {
    return fs_sys_in(FS_VERSION);
}

int fs_join_u16(int lo, int hi) {
    /*
     * Evita hi * 256 para não puxar biblioteca de multiplicação
     * nem depender de shift no compilador.
     */
    fs_tmp_acc = lo;

    while (hi > 0) {
        fs_tmp_acc = fs_tmp_acc + 256;
        hi = hi - 1;
    }

    return fs_tmp_acc;
}

int fs_result() {
    fs_tmp_lo = fs_sys_in(FS_RESULT_LO);
    fs_tmp_hi = fs_sys_in(FS_RESULT_HI);
    return fs_join_u16(fs_tmp_lo, fs_tmp_hi);
}

int fs_rx_count() {
    fs_tmp_lo = fs_sys_in(FS_RX_COUNT_LO);
    fs_tmp_hi = fs_sys_in(FS_RX_COUNT_HI);
    return fs_join_u16(fs_tmp_lo, fs_tmp_hi);
}

int fs_recv_byte() {
    return fs_sys_in(FS_RX_BYTE);
}

int fs_mount() {
    fs_command(FS_CMD_MOUNT);
    return fs_result();
}

int fs_open_read(char* path) {
    fs_clear_tx();
    fs_send_text(path);
    fs_command(FS_CMD_OPEN_READ);
    return fs_result();
}

int fs_open_write(char* path) {
    fs_clear_tx();
    fs_send_text(path);
    fs_command(FS_CMD_OPEN_WRITE);
    return fs_result();
}

int fs_close(int fd) {
    fs_set_arg0(fd);
    fs_command(FS_CMD_CLOSE);
    return fs_result();
}

int fs_read_byte(int fd) {
    fs_set_arg0(fd);
    fs_command(FS_CMD_READ_BYTE);
    return fs_result();
}

int fs_write_byte(int fd, int value) {
    fs_set_arg0(fd);
    fs_set_arg1(value);
    fs_command(FS_CMD_WRITE_BYTE);
    return fs_result();
}

void fs_write_text(int fd, char* text) {
    fs_tmp_i = 0;
    fs_tmp_c = text[fs_tmp_i];

    while (fs_tmp_c != 0) {
        fs_write_byte(fd, fs_tmp_c);
        fs_tmp_i = fs_tmp_i + 1;
        fs_tmp_c = text[fs_tmp_i];
    }
}

int fs_read_all(char* path) {
    fs_clear_tx();
    fs_send_text(path);
    fs_command(FS_CMD_READ_ALL);
    return fs_result();
}

int fs_list(char* path) {
    fs_clear_tx();
    fs_send_text(path);
    fs_command(FS_CMD_LIST);
    return fs_result();
}

int fs_exists(char* path) {
    fs_clear_tx();
    fs_send_text(path);
    fs_command(FS_CMD_EXISTS);
    return fs_result();
}

int fs_delete(char* path) {
    fs_clear_tx();
    fs_send_text(path);
    fs_command(FS_CMD_DELETE);
    return fs_result();
}

int fs_mkdir(char* path) {
    fs_clear_tx();
    fs_send_text(path);
    fs_command(FS_CMD_MKDIR);
    return fs_result();
}

void fs_print_rx() {
    fs_tmp_count = fs_rx_count();

    while (fs_tmp_count > 0) {
        fs_tmp_c = fs_recv_byte();
        print_char(fs_tmp_c);
        fs_tmp_count = fs_rx_count();
    }
}

void fs_print_file(char* path) {
    fs_read_all(path);
    fs_print_rx();
}

int fs_sys_exec(int priority) {
    asm("LDA fs_sys_exec_priority");
    asm("SOP PUSH_OP");
    asm("MOV 35");
    asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
    asm("STA sys_ret_val");
    return sys_ret_val;
}

int fs_exec(char* path, int priority) {
    fs_clear_tx();
    fs_send_text(path);
    return fs_sys_exec(priority);
}

#endif
