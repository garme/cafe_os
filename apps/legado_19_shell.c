#include "../user/usr_io.c"
#include "../user/usr_yield.c"
#include "../user/usr_exit.c"

/*
 * legado_19_shell.c
 *
 * Mini shell interativo para CAFE OS / GUILIX.
 *
 * Contrato de I/O:
 *   - read_char() retorna 0 quando nao ha tecla disponivel.
 *   - ENTER pode chegar como CR=13 ou LF=10.
 *   - BACKSPACE pode chegar como 8 ou 127.
 *   - print_char() envia bytes ao terminal de video.
 *   - FF=12 solicita limpeza total da tela.
 *
 * Este app foi escrito de forma simples para caber bem como overlay
 * e funcionar tanto no simulador quanto no export ESP32 VGA/PS2.
 */

int SHELL_MAX_LINE = 63;

int line[64];
int line_len;

int shell_i;
int shell_c;

void sh_puts(char* s) {
    int i;
    int c;

    i = 0;
    c = s[i];

    while (c != 0) {
        print_char(c);
        i = i + 1;
        c = s[i];
    }
}

void sh_newline() {
    print_char(13);
    print_char(10);
}

void sh_prompt() {
    sh_puts("$ ");
}

int sh_streq(char* s) {
    int i;
    int a;
    int b;

    i = 0;
    a = line[i];
    b = s[i];

    while (a != 0) {
        if (a != b) {
            return 0;
        }

        i = i + 1;
        a = line[i];
        b = s[i];
    }

    if (b != 0) {
        return 0;
    }

    return 1;
}

int sh_startswith(char* s) {
    int i;
    int b;

    i = 0;
    b = s[i];

    while (b != 0) {
        if (line[i] != b) {
            return 0;
        }

        i = i + 1;
        b = s[i];
    }

    return 1;
}

void sh_print_from(int pos) {
    int i;
    int c;

    i = pos;
    c = line[i];

    while (c != 0) {
        print_char(c);
        i = i + 1;
        c = line[i];
    }
}

void sh_clear() {
    /*
     * O byte FF=12 e o comando de limpeza do terminal CompSim.
     * O simulador desktop ja o interpreta. O firmware VGA/PS2 deve
     * intercepta-lo e executar Terminal.clear().
     *
     * Nao envie quebras de linha depois do FF: o prompt seguinte
     * deve aparecer diretamente no canto superior esquerdo.
     */
    print_char(12);
}

void sh_help() {
    sh_puts("Comandos disponiveis:");
    sh_newline();

    sh_puts(" help mostra esta ajuda");
    sh_newline();

    sh_puts(" ver mostra a versao do shell");
    sh_newline();

    sh_puts(" about mostra informacoes do CAFE OS");
    sh_newline();

    sh_puts(" uname mostra a plataforma simulada");
    sh_newline();

    sh_puts(" mem mostra o perfil de memoria");
    sh_newline();

    sh_puts(" ps mostra uma tabela simples de tarefas");
    sh_newline();

    sh_puts(" echo TEXTO imprime TEXTO");
    sh_newline();

    sh_puts(" clear limpa a tela");
    sh_newline();

    sh_puts(" exit encerra o shell");
    sh_newline();

    sh_puts("Easter eggs: cafe, cariri, sudo, sl, matrix, fortune");
    sh_newline();

    sh_puts("Extras: chrome, photoshop, coreldraw");
    sh_newline();
}

void sh_about() {
    sh_puts("CAFE OS / GUILIX");
    sh_newline();

    sh_puts("Configurable And Flexible Environment Operating System");
    sh_newline();

    sh_puts("Kernel fixo + apps de usuario em overlays.");
    sh_newline();
}

void sh_mem() {
    sh_puts("Perfil conservador:");
    sh_newline();

    sh_puts(" CS : 4K palavras para codigo");
    sh_newline();

    sh_puts(" DS/SS : 4K palavras para dados, heap e pilhas");
    sh_newline();

    sh_puts(" tarefas: maximo 3");
    sh_newline();

    sh_puts(" heap : 512 palavras");
    sh_newline();
}

void sh_ps() {
    sh_puts("PID TIPO ESTADO");
    sh_newline();

    sh_puts("0 overlay RUNNING");
    sh_newline();

    sh_puts("1 processo opcional");
    sh_newline();

    sh_puts("2 thread opcional");
    sh_newline();
}

void sh_sl() {
    sh_puts(" ==== ________");
    sh_newline();

    sh_puts(" _D _| |_______/ \\__");
    sh_newline();

    sh_puts(" |(_)--- | HACKING CAFE |");
    sh_newline();

    sh_puts(" / O-O-O /");
    sh_newline();
}

void sh_matrix() {
    sh_puts("01001011 01000101 01010010 01001110 01000101 01001100");
    sh_newline();

    sh_puts("00110011 00110010 00110000 00110000 01000011 01000001");
    sh_newline();

    sh_puts("Wake up, Cariri...");
    sh_newline();
}

void sh_fortune() {
    sh_puts("fortune: todo bug de kernel quer virar feature.");
    sh_newline();
}

void sh_cafe() {
    sh_puts("Cafe servido. Escalonador acordado.");
    sh_newline();
}

void sh_cariri() {
    sh_puts("Cariri CPU online. Modo usuario respeitado.");
    sh_newline();
}

void sh_sudo() {
    sh_puts("sudo: permissao negada. Tente compilar o kernel.");
    sh_newline();
}

void sh_chrome() {
    sh_puts("Chrome abriu 1 aba e consumiu toda a RAM.");
    sh_newline();
}

void sh_photoshop() {
    sh_puts("Photoshop em modo texto: filtro ASCII aplicado.");
    sh_newline();
}

void sh_coreldraw() {
    sh_puts("CorelDRAW abriu o CDR de 1998. Fontes ausentes.");
    sh_newline();
}

void sh_banner() {
    sh_puts("CAFE Shell v0.2");
    sh_newline();

    sh_puts("Digite 'help' para listar comandos.");
    sh_newline();
}

void sh_unknown() {
    sh_puts("comando nao encontrado: ");
    sh_print_from(0);
    sh_newline();

    sh_puts("digite 'help'");
    sh_newline();
}

void sh_handle_command() {
    if (line_len == 0) {
        return;
    }

    if (sh_streq("help")) {
        sh_help();
        return;
    }

    if (sh_streq("ver")) {
        sh_puts("CAFE Shell v0.2 / overlay userland");
        sh_newline();
        return;
    }

    if (sh_streq("about")) {
        sh_about();
        return;
    }

    if (sh_streq("uname")) {
        sh_puts("cariri-cpu cafe-os guilix overlay");
        sh_newline();
        return;
    }

    if (sh_streq("mem")) {
        sh_mem();
        return;
    }

    if (sh_streq("ps")) {
        sh_ps();
        return;
    }

    if (sh_startswith("echo ")) {
        sh_print_from(5);
        sh_newline();
        return;
    }

    if (sh_streq("clear")) {
        sh_clear();
        return;
    }

    if (sh_streq("cafe")) {
        sh_cafe();
        return;
    }

    if (sh_streq("cariri")) {
        sh_cariri();
        return;
    }

    if (sh_streq("sudo")) {
        sh_sudo();
        return;
    }

    if (sh_streq("sl")) {
        sh_sl();
        return;
    }

    if (sh_streq("matrix")) {
        sh_matrix();
        return;
    }

    if (sh_streq("fortune")) {
        sh_fortune();
        return;
    }

    if (sh_streq("chrome")) {
        sh_chrome();
        return;
    }

    if (sh_streq("photoshop")) {
        sh_photoshop();
        return;
    }

    if (sh_streq("coreldraw")) {
        sh_coreldraw();
        return;
    }

    if (sh_streq("exit")) {
        sh_puts("bye.");
        sh_newline();
        exit();
        return;
    }

    sh_unknown();
}

void sh_backspace() {
    if (line_len > 0) {
        line_len = line_len - 1;
        line[line_len] = 0;

        print_char(8);
        print_char(32);
        print_char(8);
    }
}

void sh_accept_char(int c) {
    if (line_len < SHELL_MAX_LINE) {
        line[line_len] = c;
        line_len = line_len + 1;
        line[line_len] = 0;
        print_char(c);
    }
}

void main() {
    line_len = 0;
    line[0] = 0;

    sh_banner();
    sh_prompt();

    while (1) {
        shell_c = read_char();

        if (shell_c == 0) {
            yield();
        } else {
            if (shell_c == 13) {
                sh_newline();
                line[line_len] = 0;
                sh_handle_command();

                line_len = 0;
                line[0] = 0;
                sh_prompt();
            } else {
                if (shell_c == 10) {
                    sh_newline();
                    line[line_len] = 0;
                    sh_handle_command();

                    line_len = 0;
                    line[0] = 0;
                    sh_prompt();
                } else {
                    if (shell_c == 8) {
                        sh_backspace();
                    } else {
                        if (shell_c == 127) {
                            sh_backspace();
                        } else {
                            sh_accept_char(shell_c);
                        }
                    }
                }
            }
        }
    }
}
