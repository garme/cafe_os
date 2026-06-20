#ifndef USR_NET_UDP_C
#define USR_NET_UDP_C
#include "../user/usr_net_core.c"

/* API UDP/IPv4 orientada a datagramas. */

int net_udp_socket() {
    net_command(12);
    return net_result();
}

int net_udp_bind_ipv4(int socket_id,
                      int ip0, int ip1, int ip2, int ip3,
                      int port_low, int port_high) {
    net_configure_ipv4(socket_id, ip0, ip1, ip2, ip3, port_low, port_high);
    net_command(13);
    if (net_has_error() == 1) { return -1; }
    return net_result();
}

/*
 * Envia o datagrama acumulado na FIFO TX ao destino informado.
 * Retorna a quantidade de bytes enviada ou -1 em erro.
 */
int net_udp_sendto_ipv4(int socket_id,
                        int ip0, int ip1, int ip2, int ip3,
                        int port_low, int port_high) {
    net_configure_ipv4(socket_id, ip0, ip1, ip2, ip3, port_low, port_high);
    net_command(14);
    if (net_has_error() == 1) { return -1; }
    return net_result();
}

/*
 * Move o próximo datagrama para a FIFO RX.
 * Retorna:
 *   >0 : tamanho do datagrama;
 *    0 : datagrama UDP de tamanho zero;
 *   -1 : ainda não há datagrama ou ocorreu erro.
 *
 * Consulte net_has_error() para distinguir erro real de WOULD_BLOCK.
 */
int net_udp_recvfrom(int socket_id) {
    int size;
    net_select_socket(socket_id);
    net_command(15);
    size = net_result();
    if (size == 65535) { return -1; }
    return size;
}

int net_udp_wait_datagram(int socket_id, int max_polls) {
    int i;
    int size;
    i = 0;
    while (i < max_polls) {
        net_select_socket(socket_id);
        net_poll();
        size = net_udp_recvfrom(socket_id);
        if (size >= 0) { return size; }
        if (net_has_error() == 1) { return -1; }
        i = i + 1;
    }
    return -2;
}

/* Metadados do último datagrama retirado por net_udp_recvfrom(). */
int net_udp_sender_ip0()       { return net_get_ip0(); }
int net_udp_sender_ip1()       { return net_get_ip1(); }
int net_udp_sender_ip2()       { return net_get_ip2(); }
int net_udp_sender_ip3()       { return net_get_ip3(); }
int net_udp_sender_port_low()  { return net_get_port_low(); }
int net_udp_sender_port_high() { return net_get_port_high(); }

void net_udp_close(int socket_id) { net_close_socket(socket_id); }

#endif
