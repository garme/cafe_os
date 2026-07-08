#include "../user/usr_io.c"
#include "../user/usr_yield.c"
#include "../user/usr_fs.c"

void puts2(char* text) {
    int i;
    int c;

    i = 0;
    c = text[i];

    while (c != 0) {
        print_char(c);
        i = i + 1;
        c = text[i];
    }
}

void nl2() {
    print_char(13);
    print_char(10);
}

void print_digit2(int value) {
    if (value < 0) {
        print_char(45);
        value = 0 - value;
    }

    if (value >= 10) {
        print_char(48 + 9);
        return;
    }

    print_char(48 + value);
}

void fail2(char* msg) {
    puts2("ERRO: ");
    puts2(msg);
    puts2(" codigo ");
    print_digit2(fs_error());
    nl2();
}

void main() {
    int fd;
    int c;

    print_char(12);
    puts2("FS DEMO v0.2");
    nl2();

    fs_mount();
    if (fs_error() != 0) {
        fail2("mount");
        return;
    }

    puts2("mount OK v");
    print_digit2(fs_version());
    nl2();

    fs_mkdir("/data");

    fd = fs_open_write("/data/hello.txt");
    if (fs_error() != 0) {
        fail2("open_write");
        return;
    }

    fs_write_text(fd, "CAFE OS escreveu no disco virtual.\r\n");
    fs_write_text(fd, "O backend atual e Python; depois sera SD.\r\n");
    fs_close(fd);

    puts2("arquivo gravado");
    nl2();

    fd = fs_open_read("/data/hello.txt");
    if (fs_error() != 0) {
        fail2("open_read");
        return;
    }

    puts2("conteudo:");
    nl2();

    fs_read_byte(fd);
    while (fs_error() != FS_ERR_EOF) {
        c = fs_result();
        print_char(c);
        fs_read_byte(fd);
    }
    fs_close(fd);

    nl2();
    puts2("list /data:");
    nl2();
    fs_list("/data");
    fs_print_rx();

    nl2();
    puts2("FS DEMO concluido.");
    nl2();
}
