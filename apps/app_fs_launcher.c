#include "../user/usr_io.c"
#include "../user/usr_yield.c"
#include "../user/usr_fs.c"

void puts_l(char* s) {
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

void nl_l() {
    print_char(13);
    print_char(10);
}

void print_int_l(int value) {
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


int wait_pid_l(int pid) {
    asm("LDA wait_pid_l_pid");
    asm("SOP PUSH_OP");
    asm("MOV 2");
    asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
    asm("STA sys_ret_val");
    return sys_ret_val;
}

void delay_l(int ticks) {
    while (ticks > 0) {
        yield();
        ticks = ticks - 1;
    }
}

int get_key_l() {
    int c;

    c = 0;

    while (c == 0) {
        c = read_char();
        yield();
    }

    return c;
}

void show_menu_l() {
    nl_l();
    puts_l("=== FS LAUNCHER v0.8 ===");
    nl_l();
    puts_l("1 - executar HELLO.COV");
    nl_l();
    puts_l("2 - executar COUNT.COV");
    nl_l();
    puts_l("3 - executar STORY.COV");
    nl_l();
    puts_l("L - listar /");
    nl_l();
    puts_l("Q - sair");
    nl_l();
    puts_l("> ");
}

void run_l(char* path) {
    int pid;

    puts_l("exec ");
    puts_l(path);
    nl_l();

    pid = fs_exec(path, 4);

    if (pid < 0) {
        puts_l("fs_exec erro pid=");
        print_int_l(pid);
        nl_l();
        return;
    }

    /*
     * v0.7.1:
     * Espera o programa carregado terminar antes de redesenhar o menu.
     * Isso evita interleaving de saída entre pai e filho no terminal.
     */
    wait_pid_l(pid);
}


void list_root_l() {
    puts_l("ls /:");
    nl_l();
    fs_list("/");
    fs_print_rx();
}

void main() {
    int c;

    print_char(12);
    puts_l("FS LAUNCHER v0.8");
    nl_l();

    fs_mount();

    if (fs_error() != 0) {
        puts_l("mount falhou erro=");
        print_int_l(fs_error());
        nl_l();
        return;
    }

    puts_l("mount OK v");
    print_int_l(fs_version());
    nl_l();

    while (1) {
        show_menu_l();
        c = get_key_l();
        print_char(c);
        nl_l();

        if (c == 49) {
            run_l("/HELLO.COV");
        } else {
            if (c == 50) {
                run_l("/COUNT.COV");
            } else {
                if (c == 51) {
                    run_l("/STORY.COV");
                } else {
                    if (c == 76) {
                        list_root_l();
                    } else {
                        if (c == 108) {
                            list_root_l();
                        } else {
                            if (c == 81) {
                                puts_l("saindo");
                                nl_l();
                                return;
                            } else {
                                if (c == 113) {
                                    puts_l("saindo");
                                    nl_l();
                                    return;
                                } else {
                                    puts_l("opcao invalida");
                                    nl_l();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
