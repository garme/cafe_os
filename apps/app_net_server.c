#include "../user/usr_net_tcp.c"
#include "../user/usr_printstr.c"
#include "../user/usr_print_char.c"
#include "../user/usr_sync.c"

int server_socket;
int client_socket;
int bind_result;
int available;
int received;
int failed;

void net_server_log(char* text) {
    sem_lock();
    printstr(text);
    sem_unlock();
}

void main() {
    failed = 0;
    server_socket = net_socket_tcp();
    if (server_socket < 0) {
        net_server_log("NET SERVER: sem socket\n");
        failed = 1;
    }

    if (failed == 0) {
        // 127.0.0.1:8081; low=145, high=31.
        bind_result = net_bind_ipv4(server_socket, 127, 0, 0, 1, 145, 31);
        if (bind_result < 0) {
            net_server_log("NET SERVER: bind falhou\n");
            failed = 1;
        }
    }

    if (failed == 0) {
        if (net_listen_socket(server_socket, 2) < 0) {
            net_server_log("NET SERVER: listen falhou\n");
            failed = 1;
        }
    }

    if (failed == 0) {
        net_server_log("NET SERVER: ouvindo 8081\n");
        client_socket = -1;
        while (client_socket < 0) {
            client_socket = net_accept(server_socket);
            if (net_has_error() == 1) {
                failed = 1;
                client_socket = 0;
            } else {
                yield();
            }
        }
    }

    if (failed == 0) {
        net_server_log("NET SERVER: cliente aceito\n");
        available = 0;
        while (available == 0) {
            available = net_wait_rx_socket(client_socket, 40);
            yield();
        }

        if (available > 0) {
            sem_lock();
            printstr("NET SERVER RX: ");
            net_select_socket(client_socket);
            while (net_rx_available() == 1) {
                received = net_recv_byte();
                print_char(received);
                net_send_byte(received);
            }
            net_send();
            sem_unlock();
        }

        net_close_socket(client_socket);
        net_close_socket(server_socket);
        net_server_log("NET SERVER: encerrado\n");
    }

    exit();
}
