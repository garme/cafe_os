#include "../user/usr_io.c"
#include "../user/usr_yield.c"
#include "../user/usr_fs.c"

void puts_loader(char* s) {
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

void nl_loader() {
    print_char(13);
    print_char(10);
}

void print_digit_loader(int value) {
    /*
     * Mantido o nome antigo para não alterar o resto da demo,
     * mas agora imprime inteiro assinado até 999.
     */
    int h;
    int t;
    int u;
    int started;

    if (value < 0) {
        print_char(45);
        value = 0 - value;
    }

    if (value >= 1000) {
        print_char(57);
        print_char(57);
        print_char(57);
        return;
    }

    h = 0;
    while (value >= 100) {
        value = value - 100;
        h = h + 1;
    }

    t = 0;
    while (value >= 10) {
        value = value - 10;
        t = t + 1;
    }

    u = value;
    started = 0;

    if (h > 0) {
        print_char(48 + h);
        started = 1;
    }

    if (started != 0) {
        print_char(48 + t);
    } else {
        if (t > 0) {
            print_char(48 + t);
            started = 1;
        }
    }

    print_char(48 + u);
}

void main() {
    int pid;

    print_char(12);
    puts_loader("FS EXEC DEMO v0.6.6");
    nl_loader();

    fs_mount();

    if (fs_error() != 0) {
        puts_loader("mount falhou");
        nl_loader();
        return;
    }

    puts_loader("mount OK v");
    print_digit_loader(fs_version());
    nl_loader();

    puts_loader("ls /:");
    nl_loader();
    fs_list("/");
    fs_print_rx();

    puts_loader("exec /HELLO.COV");
    nl_loader();

    /*
     * Importante:
     * Se fs_exec() cria o processo com sucesso, o programa filho também
     * começa a escrever no vídeo. Se o pai imprimir o PID ao mesmo tempo,
     * as mensagens se misturam caractere por caractere, pois print_char é
     * syscall e o escalonador pode alternar processos entre chamadas.
     *
     * Portanto:
     * - sucesso: o pai fica silencioso e deixa o HELLO.COV imprimir;
     * - erro: o pai imprime o código, pois nenhum filho foi criado.
     */
    pid = fs_exec("/HELLO.COV", 4);

    if (pid < 0) {
        puts_loader("fs_exec erro pid=");
        print_digit_loader(pid);
        nl_loader();
    }

    while (1) {
        yield();
    }
}
