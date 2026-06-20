#include "../user/usr_net_udp.c"
#include "../user/usr_printstr.c"
#include "../user/usr_print_char.c"
#include "../user/usr_yield.c"
#include "../user/usr_exit.c"

int udp_server_socket;
int udp_packet_size;
int udp_received;
int udp_index;
int udp_sender0;
int udp_sender1;
int udp_sender2;
int udp_sender3;
int udp_sender_port_low_value;
int udp_sender_port_high_value;

void udp_server_newline() {
    print_char(13);
    print_char(10);
}

void main() {
    udp_server_socket = net_udp_socket();

    if (udp_server_socket < 0) {
        printstr("UDP SERVER: sem socket");
        udp_server_newline();
        exit();
    }

    /* 0.0.0.0:8082; low=146, high=31. */
    if (net_udp_bind_ipv4(
            udp_server_socket,
            0, 0, 0, 0,
            146, 31
        ) < 0) {
        printstr("UDP SERVER: bind falhou");
        udp_server_newline();
        net_udp_close(udp_server_socket);
        exit();
    }

    printstr("UDP SERVER: ouvindo 8082");
    udp_server_newline();

    while (1) {
        udp_packet_size = net_udp_recvfrom(udp_server_socket);

        if (udp_packet_size < 0) {
            if (net_has_error() == 1) {
                printstr("UDP SERVER: erro de recepcao");
                udp_server_newline();
                net_udp_close(udp_server_socket);
                exit();
            }
            yield();
        } else {
            /* Salva o remetente antes de configurar o destino do eco. */
            udp_sender0 = net_udp_sender_ip0();
            udp_sender1 = net_udp_sender_ip1();
            udp_sender2 = net_udp_sender_ip2();
            udp_sender3 = net_udp_sender_ip3();
            udp_sender_port_low_value = net_udp_sender_port_low();
            udp_sender_port_high_value = net_udp_sender_port_high();

            printstr("UDP SERVER RX: ");
            udp_index = 0;
            while (udp_index < udp_packet_size) {
                udp_received = net_recv_byte();
                print_char(udp_received);
                net_send_byte(udp_received);
                udp_index = udp_index + 1;
            }
            udp_server_newline();

            net_udp_sendto_ipv4(
                udp_server_socket,
                udp_sender0,
                udp_sender1,
                udp_sender2,
                udp_sender3,
                udp_sender_port_low_value,
                udp_sender_port_high_value
            );
        }
    }
}
