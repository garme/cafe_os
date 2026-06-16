#include "../user/usr_net.c"
#include "../user/usr_yield.c"
#include "../user/usr_exit.c"

void main() {
    int server_socket;
    int client_socket;

    server_socket = net_socket_tcp();
    if (server_socket >= 0) {
        // 0.0.0.0:8081 -> low=145, high=31.
        if (net_bind_ipv4(server_socket, 0, 0, 0, 0, 145, 31) >= 0) {
            if (net_listen_socket(server_socket, 2) == 0) {
                client_socket = -1;
                while (client_socket < 0) {
                    client_socket = net_accept(server_socket);
                    yield();
                }
                net_send_text_socket(client_socket, "Hello from Guilix server\n");
                net_close_socket(client_socket);
            }
        }
        net_close_socket(server_socket);
    }
    exit();
}
