#include "../user/usr_net_tcp.c"
#include "../user/usr_printstr.c"
#include "../user/usr_print_char.c"
#include "../user/usr_sync.c"

int socket_id;
int connected;
int available;
int received;
int startup_delay;

void net_client_log(char* text) {
    sem_lock();
    printstr(text);
    sem_unlock();
}

void main() {
    // Dá ao overlay servidor tempo para executar bind() e listen().
    startup_delay = 0;
    while (startup_delay < 20) {
        startup_delay = startup_delay + 1;
        yield();
    }

    net_client_log("NET CLIENT: iniciando\n");

    socket_id = net_socket_tcp();
    if (socket_id >= 0) {
        // Servidor Guilix: 127.0.0.1:8081; low=145, high=31.
        net_connect_ipv4(socket_id, 127, 0, 0, 1, 145, 31);
        connected = net_wait_connected_socket(socket_id, 300);

        if (connected == 1) {
            net_client_log("NET CLIENT: conectado\n");
            net_send_text_socket(socket_id, "OLA DO CLIENTE GUILIX\n");

            available = net_wait_rx_socket(socket_id, 600);
            if (available > 0) {
                sem_lock();
                printstr("NET CLIENT RX: ");
                net_select_socket(socket_id);
                while (net_rx_available() == 1) {
                    received = net_recv_byte();
                    print_char(received);
                }
                sem_unlock();
            } else {
                net_client_log("NET CLIENT: sem resposta\n");
            }
            net_close_socket(socket_id);
        } else {
            net_client_log("NET CLIENT: falha ao conectar\n");
        }
    } else {
        net_client_log("NET CLIENT: sem socket\n");
    }

    exit();
}
