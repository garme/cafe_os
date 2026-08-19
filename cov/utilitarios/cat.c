#include "../user/usr_io.c"
#include "../user/usr_yield.c"
#include "../user/usr_fs.c"

char ct_name[24];
char ct_path[32];
int ct_i;
int ct_c;

void ct_nl() {
    print_char(13);
    print_char(10);
}

void ct_puts(char* s) {
    ct_i = 0;
    ct_c = s[ct_i];

    while (ct_c != 0) {
        print_char(ct_c);
        ct_i = ct_i + 1;
        ct_c = s[ct_i];
    }
}

int ct_read_name() {
    int n;
    int done;

    n = 0;
    done = 0;

    while (done == 0) {
        ct_c = read_char();

        if (ct_c == 0) {
            yield();
        } else {
            if (ct_c == 13) {
                done = 1;
            } else {
                if (ct_c == 10) {
                    done = 1;
                } else {
                    if (ct_c == 8) {
                        if (n > 0) {
                            n = n - 1;
                            print_char(8);
                            print_char(32);
                            print_char(8);
                        }
                    } else {
                        if (n < 23) {
                            ct_name[n] = (char)ct_c;
                            n = n + 1;
                            print_char(ct_c);
                        }
                    }
                }
            }
        }
    }

    ct_name[n] = (char)0;
    ct_nl();
    return n;
}

void ct_make_path() {
    int i;
    int j;

    ct_path[0] = (char)47;
    ct_path[1] = (char)100;
    ct_path[2] = (char)97;
    ct_path[3] = (char)116;
    ct_path[4] = (char)97;
    ct_path[5] = (char)47;

    i = 0;
    j = 6;

    while (ct_name[i] != (char)0) {
        ct_path[j] = ct_name[i];
        i = i + 1;
        j = j + 1;
    }

    ct_path[j] = (char)0;
}

void main() {
    print_char(12);
    ct_puts("arquivo: ");

    if (ct_read_name() == 0) {
        return;
    }

    ct_make_path();
    fs_mount();
    fs_read_all(ct_path);

    if (fs_error() == FS_OK) {
        fs_print_rx();
    } else {
        print_char(63);
        ct_nl();
    }
}
