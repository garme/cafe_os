#include "../user/usr_io.c"
#include "../user/usr_yield.c"
#include "../user/usr_fs.c"

char cp_src_name[24];
char cp_dst_name[24];
char cp_src_path[32];
char cp_dst_path[32];

int cp_i;
int cp_c;

void cp_nl() {
    print_char(13);
    print_char(10);
}

void cp_puts(char* s) {
    cp_i = 0;
    cp_c = s[cp_i];

    while (cp_c != 0) {
        print_char(cp_c);
        cp_i = cp_i + 1;
        cp_c = s[cp_i];
    }
}

int cp_read_name(char* dst) {
    int n;
    int done;

    n = 0;
    done = 0;

    while (done == 0) {
        cp_c = read_char();

        if (cp_c == 0) {
            yield();
        } else {
            if (cp_c == 13) {
                done = 1;
            } else {
                if (cp_c == 10) {
                    done = 1;
                } else {
                    if (cp_c == 8) {
                        if (n > 0) {
                            n = n - 1;
                            print_char(8);
                            print_char(32);
                            print_char(8);
                        }
                    } else {
                        if (n < 23) {
                            dst[n] = (char)cp_c;
                            n = n + 1;
                            print_char(cp_c);
                        }
                    }
                }
            }
        }
    }

    dst[n] = (char)0;
    cp_nl();
    return n;
}

void cp_make_path(char* dst, char* name) {
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

    cp_puts("origem: ");
    if (cp_read_name(cp_src_name) == 0) {
        return;
    }

    cp_puts("destino: ");
    if (cp_read_name(cp_dst_name) == 0) {
        return;
    }

    cp_make_path(cp_src_path, cp_src_name);
    cp_make_path(cp_dst_path, cp_dst_name);

    fs_mount();
    src = fs_open_read(cp_src_path);

    if (fs_error() != FS_OK) {
        print_char(63);
        cp_nl();
        return;
    }

    dst = fs_open_write(cp_dst_path);

    if (fs_error() != FS_OK) {
        fs_close(src);
        print_char(63);
        cp_nl();
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
        cp_puts("OK");
    } else {
        fs_delete(cp_dst_path);
        print_char(63);
    }

    cp_nl();
}
