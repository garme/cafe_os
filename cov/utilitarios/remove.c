#include "../user/usr_io.c"
#include "../user/usr_yield.c"
#include "../user/usr_fs.c"

char rm_name[24];
char rm_path[32];
int rm_i;
int rm_c;

void rm_nl() {
    print_char(13);
    print_char(10);
}

void rm_puts(char* s) {
    rm_i = 0;
    rm_c = s[rm_i];

    while (rm_c != 0) {
        print_char(rm_c);
        rm_i = rm_i + 1;
        rm_c = s[rm_i];
    }
}

int rm_read_name() {
    int n;
    int done;

    n = 0;
    done = 0;

    while (done == 0) {
        rm_c = read_char();

        if (rm_c == 0) {
            yield();
        } else {
            if (rm_c == 13) {
                done = 1;
            } else {
                if (rm_c == 10) {
                    done = 1;
                } else {
                    if (rm_c == 8) {
                        if (n > 0) {
                            n = n - 1;
                            print_char(8);
                            print_char(32);
                            print_char(8);
                        }
                    } else {
                        if (n < 23) {
                            rm_name[n] = (char)rm_c;
                            n = n + 1;
                            print_char(rm_c);
                        }
                    }
                }
            }
        }
    }

    rm_name[n] = (char)0;
    rm_nl();
    return n;
}

void rm_make_path() {
    int i;
    int j;

    rm_path[0] = (char)47;
    rm_path[1] = (char)100;
    rm_path[2] = (char)97;
    rm_path[3] = (char)116;
    rm_path[4] = (char)97;
    rm_path[5] = (char)47;

    i = 0;
    j = 6;

    while (rm_name[i] != (char)0) {
        rm_path[j] = rm_name[i];
        i = i + 1;
        j = j + 1;
    }

    rm_path[j] = (char)0;
}

void main() {
    print_char(12);
    rm_puts("arquivo: ");

    if (rm_read_name() == 0) {
        return;
    }

    rm_make_path();
    fs_mount();
    fs_delete(rm_path);

    if (fs_error() == FS_OK) {
        rm_puts("OK");
    } else {
        print_char(63);
    }

    rm_nl();
}
