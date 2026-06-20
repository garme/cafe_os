#include "../user/usr_net_udp.c"
#include "../user/usr_yield.c"
#include "../user/usr_exit.c"

void main() {
    int socket_id;
    socket_id = net_udp_socket();
    if (socket_id >= 0) {
        /* Configure bind/sendto/recvfrom conforme a aplicação. */
        net_udp_close(socket_id);
    }
    exit();
}
