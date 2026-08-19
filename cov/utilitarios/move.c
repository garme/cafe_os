#include "../user/usr_io.c"
#include "../user/usr_yield.c"
#include "../user/usr_fs.c"

char mv_src_name[24];
char mv_dst_name[24];
char mv_src_path[32];
char mv_dst_path[32];

int mv_i;
int mv_c;

void mv_nl() {
    print_char(13);
    print_char(10);
}

void mv_puts(char* s) {
    mv_i = 0;
    mv_c = s[mv_i];

    while (mv_c != 0) {
        print_char(mv_c);
        mv_i = mv_i + 1;
        mv_c = s[mv_i];
    }
}

int mv_read_name(char* dst) {
    int n;
    int done;

    n = 0;
    done = 0;

    while (done == 0) {
        mv_c = read_char();

        if (mv_c == 0) {
            yield();
        } else {
            if (mv_c == 13) {
                done = 1;
            } else {
                if (mv_c == 10) {
                    done = 1;
                } else {
                    if (mv_c == 8) {
                        if (n > 0) {
                            n = n - 1;
                            print_char(8);
                            print_char(32);
                            print_char(8);
                        }
                    } else {
                        if (n < 23) {
                            dst[n] = (char)mv_c;
                            n = n + 1;
                            print_char(mv_c);
                        }
                    }
                }
            }
        }
    }

    dst[n] = (char)0;
    mv_nl();
    return n;
}

void mv_make_path(char* dst, char* name) {
    int i;
    int j;

    dst[0] = (char)47;
    dst[1] = (char)100;
    dst[2] = (char)97;
    dst[3] = (char)116;
    dst[4] = (char)97;
    dst[5] = (char)47;

    i = 0;
    j = 6;

    while (name[i] != (char)0) {
        dst[j] = name[i];
        i = i + 1;
        j = j + 1;
    }

    dst[j] = (char)0;
}

void main() {
    int src;
    int dst;
    int value;
    int err;

    print_char(12);

    mv_puts("origem: ");
    if (mv_read_name(mv_src_name) == 0) {
        return;
    }

    mv_puts("destino: ");
    if (mv_read_name(mv_dst_name) == 0) {
        return;
    }

    mv_make_path(mv_src_path, mv_src_name);
    mv_make_path(mv_dst_path, mv_dst_name);

    fs_mount();
    src = fs_open_read(mv_src_path);

    if (fs_error() != FS_OK) {
        print_char(63);
        mv_nl();
        return;
    }

    dst = fs_open_write(mv_dst_path);

    if (fs_error() != FS_OK) {
        fs_close(src);
        print_char(63);
        mv_nl();
        return;
    }

    err = FS_OK;

    while (err == FS_OK) {
        value = fs_read_byte(src);
        err = fs_error();

        if (err == FS_OK) {
            fs_write_byte(dst, value);
            err = fs_error();
        }
    }

    fs_close(src);
    fs_close(dst);

    if (err == FS_ERR_EOF) {
        fs_delete(mv_src_path);

        if (fs_error() == FS_OK) {
            mv_puts("OK");
        } else {
            print_char(63);
        }
    } else {
        fs_delete(mv_dst_path);
        print_char(63);
    }

    mv_nl();
}
