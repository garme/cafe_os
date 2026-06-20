#include "../user/usr_net_tcp.c"
#include "../user/usr_exit.c"

void main() {
    int socket_id;

    socket_id = net_socket_tcp();
    if (socket_id >= 0) {
        // 127.0.0.1:8080 -> low=144, high=31.
        net_connect_ipv4(socket_id, 127, 0, 0, 1, 144, 31);
        if (net_wait_connected_socket(socket_id, 300) == 1) {
            net_send_text_socket(socket_id, "Hello from Guilix\n");
            net_close_socket(socket_id);
        }
    }
    exit();
}
