#include "../user/usr_net.c"
#include "../user/usr_printstr.c"
#include "../user/usr_print_char.c"
#include "../user/usr_exit.c"

int socket_id;
int connected;
int available;
int received;

void main() {
    printstr("NET CLIENT: iniciando\n");

    socket_id = net_socket_tcp();
    if (socket_id >= 0) {
        // 127.0.0.1:8080; low=144, high=31.
        net_connect_ipv4(socket_id, 127, 0, 0, 1, 144, 31);
        connected = net_wait_connected_socket(socket_id, 300);

        if (connected == 1) {
            printstr("NET CLIENT: conectado\n");
            net_send_text_socket(socket_id, "OLA DO GUILIX\n");

            available = net_wait_rx_socket(socket_id, 600);
            if (available > 0) {
                printstr("NET CLIENT RX: ");
                while (net_rx_available() == 1) {
                    received = net_recv_byte();
                    print_char(received);
                }
            } else {
                printstr("NET CLIENT: sem resposta\n");
            }
            net_close_socket(socket_id);
        } else {
            printstr("NET CLIENT: falha ao conectar\n");
        }
    } else {
        printstr("NET CLIENT: sem socket\n");
    }

    exit();
}
