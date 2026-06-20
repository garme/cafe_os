#ifndef USR_NET_CORE_C
#define USR_NET_CORE_C
#include "../user/usr_runtime.c"

/*
 * Núcleo comum da API de rede do CAFE OS / GUILIX.
 *
 * Este arquivo contém somente:
 *   - ABI das syscalls 30/31;
 *   - registradores do periférico;
 *   - configuração IPv4/porta;
 *   - status, resultado e erro;
 *   - FIFOs TX/RX compartilhadas por TCP e UDP.
 *
 * Protocolos específicos ficam em:
 *   usr_net_tcp.c
 *   usr_net_udp.c
 */

/* ---------------------------- ABI de kernel ------------------------------- */
int net_sys_out(int io_word) {
    asm("LDA net_sys_out_io_word"); asm("SOP PUSH_OP");
    asm("MOV 30");                  asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
    asm("STA sys_ret_val");
    return sys_ret_val;
}

int net_sys_in(int io_word) {
    asm("LDA net_sys_in_io_word"); asm("SOP PUSH_OP");
    asm("MOV 31");                 asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
    asm("STA sys_ret_val");
    return sys_ret_val;
}

/* -------------------------- comandos genéricos ---------------------------- */
void net_command(int command) { net_sys_out(10240 + command); }
void net_reset()               { net_command(1); }
void net_poll()                { net_command(5); }
void net_close()               { net_command(6); }
void net_clear_tx()            { net_command(7); }
void net_clear_rx()            { net_command(8); }

/* ------------------------ seleção/configuração ---------------------------- */
void net_select_socket(int socket_id) { net_sys_out(10752 + socket_id); }
void net_set_ip0(int value)           { net_sys_out(12032 + value); }
void net_set_ip1(int value)           { net_sys_out(12288 + value); }
void net_set_ip2(int value)           { net_sys_out(12544 + value); }
void net_set_ip3(int value)           { net_sys_out(12800 + value); }
void net_set_port_low(int value)      { net_sys_out(13056 + value); }
void net_set_port_high(int value)     { net_sys_out(13312 + value); }
void net_set_backlog(int value)       { net_sys_out(15616 + value); }

int net_get_ip0()       { return net_sys_in(12032); }
int net_get_ip1()       { return net_sys_in(12288); }
int net_get_ip2()       { return net_sys_in(12544); }
int net_get_ip3()       { return net_sys_in(12800); }
int net_get_port_low()  { return net_sys_in(13056); }
int net_get_port_high() { return net_sys_in(13312); }

void net_configure_ipv4(int socket_id,
                        int ip0, int ip1, int ip2, int ip3,
                        int port_low, int port_high) {
    net_select_socket(socket_id);
    net_set_ip0(ip0);
    net_set_ip1(ip1);
    net_set_ip2(ip2);
    net_set_ip3(ip3);
    net_set_port_low(port_low);
    net_set_port_high(port_high);
}

/* ------------------------------- estado ----------------------------------- */
int net_status()       { return net_sys_in(10496); }
int net_result_low()   { return net_sys_in(11008); }
int net_result_high()  { return net_sys_in(11264); }
int net_error_low()    { return net_sys_in(11520); }
int net_error_high()   { return net_sys_in(11776); }
int net_version()      { return net_sys_in(15104); }
int net_max_sockets()  { return net_sys_in(15360); }
int net_socket_state() { return net_sys_in(15872); }

int net_result() {
    int result_lo_value;
    int result_hi_value;
    result_lo_value = net_result_low();
    result_hi_value = net_result_high();
    result_hi_value = result_hi_value * 256;
    return result_lo_value + result_hi_value;
}

int net_error() {
    int error_lo_value;
    int error_hi_value;
    error_lo_value = net_error_low();
    error_hi_value = net_error_high();
    error_hi_value = error_hi_value * 256;
    return error_lo_value + error_hi_value;
}

int net_is_connected() {
    int status;
    status = net_status();
    if ((status & 4) != 0) { return 1; }
    return 0;
}

int net_has_rx_or_accept() {
    int status;
    status = net_status();
    if ((status & 8) != 0) { return 1; }
    return 0;
}

int net_rx_available() { return net_has_rx_or_accept(); }

int net_has_error() {
    int status;
    status = net_status();
    if ((status & 32) != 0) { return 1; }
    return 0;
}

int net_would_block() {
    int status;
    status = net_status();
    if ((status & 128) != 0) { return 1; }
    return 0;
}

/* ------------------------------ transmissão ------------------------------- */
void net_send_byte(int value) { net_sys_out(13568 + value); }

void net_send_text(char* text) {
    int i;
    int c;
    i = 0;
    c = text[i];
    while (c != 0) {
        net_send_byte(c);
        i = i + 1;
        c = text[i];
    }
}

int net_tx_count() {
    int low;
    int high;
    low = net_sys_in(13824);
    high = net_sys_in(14080);
    high = high * 256;
    return low + high;
}

/* -------------------------------- recepção -------------------------------- */
int net_recv_byte() { return net_sys_in(14336); }

int net_rx_count() {
    int low;
    int high;
    low = net_sys_in(14592);
    high = net_sys_in(14848);
    high = high * 256;
    return low + high;
}

void net_close_socket(int socket_id) {
    net_select_socket(socket_id);
    net_close();
}

#endif
