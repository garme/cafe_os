#include "../user/usr_io.c"
#include "../user/usr_yield.c"
#include "../user/usr_fs.c"

/*
 * GUILIX minimal resident shell v1.3.7
 *
 * Comandos internos:
 *   la / LA  -> lista apps
 *   ld / LD  -> lista data
 *
 * Também aceita espaços depois do comando:
 *   la
 *   la
 *   la 
 *
 * Execução:
 *   - se o nome digitado tiver '/', executa exatamente como digitado;
 *   - se o nome digitado não tiver '/', prefixa apps/.
 *
 * Exemplos:
 *   HELLO.COV       -> apps/HELLO.COV
 *   apps/HELLO.COV  -> apps/HELLO.COV
 *   data/FILE.TXT   -> data/FILE.TXT
 */

int shell_cmd[40];

void puts(char* s) {
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

void nl() {
    print_char(13);
    print_char(10);
}

int wait_pid(int pid) {
    asm("LDA wait_pid_pid");
    asm("SOP PUSH_OP");
    asm("MOV 2");
    asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
    asm("STA sys_ret_val");
    return sys_ret_val;
}

void prompt() {
    print_char(62);
    print_char(32);
}

void read_line() {
    int i;
    int c;
    int done;

    i = 0;
    done = 0;

    while (done == 0) {
        c = read_char();

        if (c == 0) {
            yield();
        } else {
            if (c == 13) {
                done = 1;
            } else {
                if (c == 10) {
                    done = 1;
                } else {
                    if (c == 8) {
                        if (i > 0) {
                            i = i - 1;
                            print_char(8);
                            print_char(32);
                            print_char(8);
                        }
                    } else {
                        if (i < 39) {
                            shell_cmd[i] = c;
                            i = i + 1;
                            print_char(c);
                        }
                    }
                }
            }
        }
    }

    shell_cmd[i] = 0;
    nl();
}

int empty() {
    if (shell_cmd[0] == 0) {
        return 1;
    }

    return 0;
}

int letter_l(int c) {
    if (c == 108) {
        return 1;
    }

    if (c == 76) {
        return 1;
    }

    return 0;
}

int letter_a(int c) {
    if (c == 97) {
        return 1;
    }

    if (c == 65) {
        return 1;
    }

    return 0;
}

int letter_d(int c) {
    if (c == 100) {
        return 1;
    }

    if (c == 68) {
        return 1;
    }

    return 0;
}

int rest_spaces_or_end(int pos) {
    int i;
    int c;

    i = pos;
    c = shell_cmd[i];

    while (c != 0) {
        if (c != 32) {
            return 0;
        }

        i = i + 1;
        c = shell_cmd[i];
    }

    return 1;
}

int is_la() {
    if (letter_l(shell_cmd[0]) == 0) {
        return 0;
    }

    if (letter_a(shell_cmd[1]) == 0) {
        return 0;
    }

    return rest_spaces_or_end(2);
}

int is_ld() {
    if (letter_l(shell_cmd[0]) == 0) {
        return 0;
    }

    if (letter_d(shell_cmd[1]) == 0) {
        return 0;
    }

    return rest_spaces_or_end(2);
}

int has_slash() {
    int i;
    int c;

    i = 0;
    c = shell_cmd[i];

    while (c != 0) {
        if (c == 47) {
            return 1;
        }

        i = i + 1;
        c = shell_cmd[i];
    }

    return 0;
}

void send_from(int pos) {
    int i;
    int c;

    i = pos;

    while (shell_cmd[i] == 32) {
        i = i + 1;
    }

    c = shell_cmd[i];

    while (c != 0) {
        fs_send_byte(c);
        i = i + 1;
        c = shell_cmd[i];
    }

    fs_send_byte(0);
}

void list_apps() {
    fs_list("apps");

    if (fs_error() != 0) {
        puts("err");
        nl();
        return;
    }

    fs_print_rx();
}

void list_data() {
    fs_list("data");

    if (fs_error() != 0) {
        puts("err");
        nl();
        return;
    }

    fs_print_rx();
}

void send_exec_path() {
    fs_clear_tx();

    if (has_slash() == 0) {
        fs_send_byte(97);
        fs_send_byte(112);
        fs_send_byte(112);
        fs_send_byte(115);
        fs_send_byte(47);
    }

    send_from(0);
}

void do_exec() {
    int pid;
    int w;

    send_exec_path();
    pid = fs_sys_exec(4);

    if (pid < 0) {
        puts("err");
        nl();
        return;
    }

    w = wait_pid(pid);
}

void main() {
    fs_mount();

    puts("GUILIX");
    nl();

    while (1) {
        prompt();
        read_line();

        if (empty() == 1) {
            yield();
        } else {
            if (is_la() == 1) {
                list_apps();
            } else {
                if (is_ld() == 1) {
                    list_data();
                } else {
                    do_exec();
                }
            }
        }
    }
}
