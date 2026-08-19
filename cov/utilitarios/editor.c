#include "../user/usr_io.c"
#include "../user/usr_yield.c"
#include "../user/usr_fs.c"

#define NAME_MAX 18
#define LINE_MAX 64

char ed_name[19];
char ed_path[25];
int ed_line[64];

int ed_i;
int ed_c;
int ed_len;
int ed_fd;
int ed_done;

void ed_nl() {
    print_char(13);
    print_char(10);
}

void ed_puts(char* s) {
    ed_i = 0;
    ed_c = s[ed_i];

    while (ed_c != 0) {
        print_char(ed_c);
        ed_i = ed_i + 1;
        ed_c = s[ed_i];
    }
}

int ed_read_name() {
    int n;
    int done;

    n = 0;
    done = 0;

    while (done == 0) {
        ed_c = read_char();

        if (ed_c == 0) {
            yield();
        } else {
            if (ed_c == 13) {
                done = 1;
            } else {
                if (ed_c == 10) {
                    done = 1;
                } else {
                    if (ed_c == 8) {
                        if (n > 0) {
                            n = n - 1;
                            print_char(8);
                            print_char(32);
                            print_char(8);
                        }
                    } else {
                        if (n < NAME_MAX) {
                            ed_name[n] = (char)ed_c;
                            n = n + 1;
                            print_char(ed_c);
                        }
                    }
                }
            }
        }
    }

    ed_name[n] = (char)0;
    ed_nl();
    return n;
}

void ed_make_path() {
    int i;
    int j;

    ed_path[0] = (char)47;
    ed_path[1] = (char)100;
    ed_path[2] = (char)97;
    ed_path[3] = (char)116;
    ed_path[4] = (char)97;
    ed_path[5] = (char)47;

    i = 0;
    j = 6;

    while (ed_name[i] != (char)0) {
        ed_path[j] = ed_name[i];
        i = i + 1;
        j = j + 1;
    }

    ed_path[j] = (char)0;
}

int ed_flush_line(int newline) {
    int i;

    i = 0;

    while (i < ed_len) {
        fs_write_byte(ed_fd, ed_line[i]);

        if (fs_error() != FS_OK) {
            return 0;
        }

        i = i + 1;
    }

    if (newline != 0) {
        fs_write_byte(ed_fd, 13);

        if (fs_error() != FS_OK) {
            return 0;
        }

        fs_write_byte(ed_fd, 10);

        if (fs_error() != FS_OK) {
            return 0;
        }
    }

    ed_len = 0;
    return 1;
}

void main() {
    print_char(12);
    ed_puts("ED arquivo: ");

    if (ed_read_name() == 0) {
        return;
    }

    ed_make_path();

    fs_mount();
    fs_mkdir("/data");
    ed_fd = fs_open_write(ed_path);

    if (fs_error() != FS_OK) {
        ed_puts("ERRO");
        ed_nl();
        return;
    }

    ed_puts("ESC salva e sai");
    ed_nl();

    ed_len = 0;
    ed_done = 0;

    while (ed_done == 0) {
        ed_c = read_char();

        if (ed_c == 0) {
            yield();
        } else {
            if (ed_c == 27) {
                if (ed_flush_line(0) == 0) {
                    ed_puts("ERRO");
                    ed_nl();
                }

                ed_done = 1;
            } else {
                if (ed_c == 13) {
                    if (ed_flush_line(1) == 0) {
                        ed_puts("ERRO");
                        ed_nl();
                        ed_done = 1;
                    } else {
                        ed_nl();
                    }
                } else {
                    if (ed_c == 10) {
                        yield();
                    } else {
                        if (ed_c == 8) {
                            if (ed_len > 0) {
                                ed_len = ed_len - 1;
                                print_char(8);
                                print_char(32);
                                print_char(8);
                            }
                        } else {
                            if (ed_len < LINE_MAX) {
                                ed_line[ed_len] = ed_c;
                                ed_len = ed_len + 1;
                                print_char(ed_c);
                            }
                        }
                    }
                }
            }
        }
    }

    fs_close(ed_fd);
    ed_nl();

    if (fs_error() == FS_OK) {
        ed_puts("SALVO");
    } else {
        ed_puts("ERRO");
    }

    ed_nl();
}
