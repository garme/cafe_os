#include "../user/usr_net_udp.c"
#include "../user/usr_printstr.c"
#include "../user/usr_print_char.c"
#include "../user/usr_yield.c"
#include "../user/usr_exit.c"

int udp_socket;
int udp_size;
int udp_i;
int udp_c;

void udp_newline() {
    print_char(13);
    print_char(10);
}

void main() {
    udp_socket = net_udp_socket();

    if (udp_socket < 0) {
        printstr("UDP CLIENT: sem socket");
        udp_newline();
        exit();
    }

    net_select_socket(udp_socket);
    net_send_text("PING UDP DO GUILIX");

    /* 127.0.0.1:8082; low=146, high=31. */
    if (net_udp_sendto_ipv4(
            udp_socket,
            127, 0, 0, 1,
            146, 31
        ) < 0) {
        printstr("UDP CLIENT: envio falhou");
        udp_newline();
        net_udp_close(udp_socket);
        exit();
    }

    printstr("UDP CLIENT: datagrama enviado");
    udp_newline();

    udp_size = -1;
    while (udp_size < 0) {
        udp_size = net_udp_recvfrom(udp_socket);
        if (udp_size < 0) {
            if (net_has_error() == 1) {
                printstr("UDP CLIENT: recepcao falhou");
                udp_newline();
                net_udp_close(udp_socket);
                exit();
            }
            yield();
        }
    }

    printstr("UDP CLIENT RX: ");
    udp_i = 0;
    while (udp_i < udp_size) {
        udp_c = net_recv_byte();
        print_char(udp_c);
        udp_i = udp_i + 1;
    }
    udp_newline();

    net_udp_close(udp_socket);
    exit();
}
