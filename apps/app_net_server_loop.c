#include "../user/usr_net_tcp.c"
#include "../user/usr_printstr.c"
#include "../user/usr_print_char.c"
#include "../user/usr_sync.c"

int server_socket;
int client_socket;
int bind_result;
int available;
int received;
int server_ready;
int restart_server;
int connection_done;
int socket_state;
int retry_i;
int tx_wait;
int last_was_cr;

/*
 * O terminal VGA precisa de CR + LF para retornar à coluna zero.
 */
void net_server_newline() {
    print_char(13);
    print_char(10);
}

/*
 * As mensagens não devem conter '\n'. Esta rotina acrescenta CR + LF.
 */
void net_server_log(char* text) {
    sem_lock();
    printstr(text);
    net_server_newline();
    sem_unlock();
}

/*
 * Pequena espera cooperativa entre tentativas de recriar o listener.
 * Evita um laço agressivo caso a porta esteja temporariamente ocupada.
 */
void net_server_retry_delay() {
    retry_i = 0;
    while (retry_i < 50) {
        yield();
        retry_i = retry_i + 1;
    }
}

/*
 * Normaliza somente a saída VGA:
 *
 *   LF      -> CR + LF
 *   CR      -> CR + LF
 *   CR + LF -> uma única quebra visual
 *
 * O eco TCP continua usando o byte original recebido.
 */
void net_server_print_received(int c) {
    if (c == 13) {
        net_server_newline();
        last_was_cr = 1;
    } else {
        if (c == 10) {
            if (last_was_cr == 0) {
                net_server_newline();
            }
            last_was_cr = 0;
        } else {
            print_char(c);
            last_was_cr = 0;
        }
    }
}

void main() {
    server_socket = -1;
    client_socket = -1;

    /*
     * O servidor nunca encerra voluntariamente. Se o listener falhar,
     * ele é fechado e recriado no laço externo.
     */
    while (1) {
        server_ready = 0;

        while (server_ready == 0) {
            server_socket = net_socket_tcp();

            if (server_socket < 0) {
                net_server_log("NET SERVER: sem socket; tentando novamente");
                net_server_retry_delay();
            } else {
                /* 0.0.0.0:8081; low=145, high=31. */
                bind_result = net_bind_ipv4(
                    server_socket,
                    0, 0, 0, 0,
                    145, 31
                );

                if (bind_result < 0) {
                    net_server_log("NET SERVER: bind falhou; tentando novamente");
                    net_close_socket(server_socket);
                    server_socket = -1;
                    net_server_retry_delay();
                } else {
                    if (net_listen_socket(server_socket, 2) < 0) {
                        net_server_log("NET SERVER: listen falhou; tentando novamente");
                        net_close_socket(server_socket);
                        server_socket = -1;
                        net_server_retry_delay();
                    } else {
                        server_ready = 1;
                    }
                }
            }
        }

        net_server_log("NET SERVER: ouvindo 8081");
        restart_server = 0;

        /*
         * Enquanto o listener estiver válido, atende clientes em sequência.
         */
        while (restart_server == 0) {
            client_socket = -1;
            net_server_log("NET SERVER: aguardando cliente");

            while (client_socket < 0) {
                client_socket = net_accept(server_socket);

                if (client_socket < 0) {
                    if (net_has_error() == 1) {
                        net_server_log("NET SERVER: accept falhou; reiniciando listener");
                        restart_server = 1;
                        client_socket = 0;
                    } else {
                        yield();
                    }
                }
            }

            if (restart_server == 0) {
                net_server_log("NET SERVER: cliente aceito");
                connection_done = 0;
                available = 0;

                /*
                 * Aguarda o primeiro bloco. Também detecta fechamento remoto,
                 * evitando ficar preso para sempre quando o cliente desconecta
                 * sem enviar dados.
                 */
                while (connection_done == 0) {
                    available = net_wait_rx_socket(client_socket, 40);

                    if (available > 0) {
                        connection_done = 1;
                    } else {
                        if (available < 0) {
                            net_server_log("NET SERVER: erro ao receber");
                            connection_done = 1;
                        } else {
                            net_select_socket(client_socket);
                            socket_state = net_socket_state();

                            if (socket_state == 6) {
                                net_server_log("NET SERVER: cliente fechou sem dados");
                                connection_done = 1;
                            } else {
                                if (socket_state == 7) {
                                    net_server_log("NET SERVER: socket do cliente em erro");
                                    connection_done = 1;
                                } else {
                                    yield();
                                }
                            }
                        }
                    }
                }

                if (available > 0) {
                    net_select_socket(client_socket);
                    last_was_cr = 0;
                    received = 0;

                    /*
                     * Prefixo e dados ficam na mesma região crítica para que
                     * outras tarefas não misturem caracteres no vídeo.
                     */
                    sem_lock();
                    printstr("NET SERVER RX: ");

                    while (net_rx_available() == 1) {
                        received = net_recv_byte();
                        net_server_print_received(received);
                        net_send_byte(received);
                    }

                    if (received != 13) {
                        if (received != 10) {
                            net_server_newline();
                        }
                    }

                    sem_unlock();

                    /*
                     * Solicita o envio e dá tempo para a FIFO TX esvaziar antes
                     * de fechar a conexão não bloqueante.
                     */
                    net_send();
                    tx_wait = 0;

                    while (net_tx_count() > 0) {
                        net_poll();
                        yield();
                        tx_wait = tx_wait + 1;

                        if (tx_wait >= 100) {
                            /* Força a saída do laço sem encerrar o servidor. */
                            net_clear_tx();
                        }
                    }

                    net_server_log("NET SERVER: resposta enviada");
                }

                net_close_socket(client_socket);
                client_socket = -1;
                net_server_log("NET SERVER: cliente encerrado");
            }
        }

        if (server_socket >= 0) {
            net_close_socket(server_socket);
            server_socket = -1;
        }

        net_server_retry_delay();
    }
}
