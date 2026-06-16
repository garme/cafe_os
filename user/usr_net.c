#ifndef USR_NET_C
#define USR_NET_C
#include "../user/usr_runtime.c"

// ===============================================================
// API TCP/IPv4 não bloqueante do CAFE OS / Guilix
//
// Backend: periférico Network do CompSim, portas 40..62.
// O acesso IN/OUT é sempre mediado pelo kernel (syscalls 30 e 31).
// A API oferece operações de cliente e servidor sem bloquear o host.
// ===============================================================

// -------------------------- ABI interna --------------------------
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

// --------------------------- comandos ---------------------------
void net_reset()         { net_sys_out(10241); }
void net_connect_start() { net_sys_out(10243); }
void net_send()          { net_sys_out(10244); }
void net_poll()          { net_sys_out(10245); }
void net_close()         { net_sys_out(10246); }
void net_clear_tx()      { net_sys_out(10247); }
void net_clear_rx()      { net_sys_out(10248); }
void net_bind_start()    { net_sys_out(10249); }
void net_listen_start()  { net_sys_out(10250); }
void net_accept_start()  { net_sys_out(10251); }

// Cria um socket TCP e retorna o identificador 0..3.
int net_socket_tcp() {
    net_sys_out(10242);
    return net_result();
}

// ------------------------ configuração --------------------------
void net_select_socket(int socket_id) { net_sys_out(10752 + socket_id); }
void net_set_ip0(int value)            { net_sys_out(12032 + value); }
void net_set_ip1(int value)            { net_sys_out(12288 + value); }
void net_set_ip2(int value)            { net_sys_out(12544 + value); }
void net_set_ip3(int value)            { net_sys_out(12800 + value); }
void net_set_port_low(int value)       { net_sys_out(13056 + value); }
void net_set_port_high(int value)      { net_sys_out(13312 + value); }
void net_set_backlog(int value)        { net_sys_out(15616 + value); }

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

// ---------------------------- estado ----------------------------
int net_status()       { return net_sys_in(10496); }
int net_result_low()   { return net_sys_in(11008); }
int net_result_high()  { return net_sys_in(11264); }
int net_error_low()    { return net_sys_in(11520); }
int net_error_high()   { return net_sys_in(11776); }
int net_version()      { return net_sys_in(15104); }
int net_max_sockets()  { return net_sys_in(15360); }
int net_socket_state() { return net_sys_in(15872); }

int net_result() {
    int lo_value;
    int hi_value;
    lo_value = net_result_low();
    hi_value = net_result_high();
    hi_value = hi_value * 256;
    lo_value = lo_value + hi_value;
    return lo_value;
}

int net_error() {
    int lo_value;
    int hi_value;
    lo_value = net_error_low();
    hi_value = net_error_high();
    hi_value = hi_value * 256;
    lo_value = lo_value + hi_value;
    return lo_value;
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

// Retorna 1 quando o socket selecionado possui ao menos um byte em RX.
// Usa o bit RX_AVAILABLE do periférico; isso evita depender da montagem
// aritmética do contador de 16 bits no caminho de espera.
int net_rx_available() {
    return net_has_rx_or_accept();
}

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

// -------------------------- cliente TCP -------------------------
void net_connect_ipv4(int socket_id,
                      int ip0, int ip1, int ip2, int ip3,
                      int port_low, int port_high) {
    net_configure_ipv4(socket_id, ip0, ip1, ip2, ip3, port_low, port_high);
    net_connect_start();
}

// Retorna 1 conectado, -1 erro e 0 timeout.
int net_wait_connected(int max_polls) {
    int i;
    i = 0;
    while (i < max_polls) {
        net_poll();
        if (net_is_connected() == 1) { return 1; }
        if (net_has_error() == 1) { return -1; }
        i = i + 1;
    }
    return 0;
}

int net_wait_connected_socket(int socket_id, int max_polls) {
    net_select_socket(socket_id);
    return net_wait_connected(max_polls);
}

// -------------------------- servidor TCP ------------------------
// Para escutar em todas as interfaces, use IP 0.0.0.0.
// O resultado de bind é a porta efetiva; isso permite port_low=0,
// port_high=0 para solicitar uma porta efêmera ao sistema hospedeiro.
int net_bind_ipv4(int socket_id,
                  int ip0, int ip1, int ip2, int ip3,
                  int port_low, int port_high) {
    net_configure_ipv4(socket_id, ip0, ip1, ip2, ip3, port_low, port_high);
    net_bind_start();
    if (net_has_error() == 1) { return -1; }
    return net_result();
}

int net_listen_socket(int socket_id, int backlog) {
    net_select_socket(socket_id);
    net_set_backlog(backlog);
    net_listen_start();
    if (net_has_error() == 1) { return -1; }
    return 0;
}

// Retorna o novo socket conectado ou -1 quando ainda não há cliente.
int net_accept(int server_socket) {
    int accepted;
    net_select_socket(server_socket);
    net_accept_start();
    accepted = net_result();
    return accepted;
}

// Retorna socket aceito, -1 em erro e -2 em timeout.
int net_wait_accept(int server_socket, int max_polls) {
    int i;
    int accepted;
    i = 0;
    while (i < max_polls) {
        net_select_socket(server_socket);
        net_poll();
        accepted = net_accept(server_socket);
        if (accepted >= 0) { return accepted; }
        if (net_has_error() == 1) { return -1; }
        i = i + 1;
    }
    return -2;
}

// ------------------------ transmissão ---------------------------
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

void net_send_text_socket(int socket_id, char* text) {
    net_select_socket(socket_id);
    net_send_text(text);
    net_send();
}

int net_tx_count() {
    int low;
    int high;
    low = net_sys_in(13824);
    high = net_sys_in(14080);
    high = high * 256;
    low = low + high;
    return low;
}

// -------------------------- recepção ----------------------------
int net_recv_byte() { return net_sys_in(14336); }

int net_rx_count() {
    int low;
    int high;
    low = net_sys_in(14592);
    high = net_sys_in(14848);
    high = high * 256;
    low = low + high;
    return low;
}

// Retorna 1 quando há dados, -1 em erro ou 0 em timeout.
int net_wait_rx(int max_polls) {
    int i;
    i = 0;
    while (i < max_polls) {
        net_poll();
        if (net_rx_available() == 1) { return 1; }
        if (net_has_error() == 1) { return -1; }
        i = i + 1;
    }
    return 0;
}

int net_wait_rx_socket(int socket_id, int max_polls) {
    net_select_socket(socket_id);
    return net_wait_rx(max_polls);
}

void net_close_socket(int socket_id) {
    net_select_socket(socket_id);
    net_close();
}

#endif
