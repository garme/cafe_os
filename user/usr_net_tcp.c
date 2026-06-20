#ifndef USR_NET_TCP_C
#define USR_NET_TCP_C
#include "../user/usr_net_core.c"

/* API TCP/IPv4 cliente e servidor. */

void net_connect_start() { net_command(3); }
void net_send()          { net_command(4); }
void net_bind_start()    { net_command(9); }
void net_listen_start()  { net_command(10); }
void net_accept_start()  { net_command(11); }

int net_socket_tcp() {
    net_command(2);
    return net_result();
}

void net_connect_ipv4(int socket_id,
                      int ip0, int ip1, int ip2, int ip3,
                      int port_low, int port_high) {
    net_configure_ipv4(socket_id, ip0, ip1, ip2, ip3, port_low, port_high);
    net_connect_start();
}

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

int net_accept(int server_socket) {
    int accepted;
    net_select_socket(server_socket);
    net_accept_start();
    accepted = net_result();
    return accepted;
}

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

void net_send_text_socket(int socket_id, char* text) {
    net_select_socket(socket_id);
    net_send_text(text);
    net_send();
}

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

#endif
