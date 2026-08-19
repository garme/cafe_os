#include "../user/usr_io.c"
#include "../user/usr_yield.c"
#include "../user/usr_fs_shell_min.c"

/*
 * GUILIX shell residente mínimo.
 *
 * Entrada:
 *   HELLO.COV -> apps/HELLO.COV
 *
 * Removidos:
 *   la, ld, listagem, caminhos completos, banner, mensagens,
 *   espaços finais, conversão de caixa e edição por Backspace.
 */

int sh_cmd[24];
int sh_n;
int sh_c;
int sh_pid;

int sh_wait(int pid) {
    asm("LDA sh_wait_pid");
    asm("SOP PUSH_OP");
    asm("MOV 2");
    asm("SOP PUSH_OP");
    asm("INT SYSCALL_INT");
    asm("STA sys_ret_val");
    return sys_ret_val;
}

void main() {
    fs_shell_mount();

    while (1) {
        print_char(62);
        print_char(32);

        sh_n = 0;
        sh_c = 0;

        while (sh_c != 13) {
            sh_c = read_char();

            if (sh_c == 0) {
                yield();
            } else {
                if (sh_c == 10) {
                    sh_c = 13;
                } else {
                    if (sh_c != 13) {
                        if (sh_n < 23) {
                            sh_cmd[sh_n] = sh_c;
                            sh_n = sh_n + 1;
                            print_char(sh_c);
                        }
                    }
                }
            }
        }

        sh_cmd[sh_n] = 0;
        print_char(13);
        print_char(10);

        if (sh_n > 0) {
            fs_shell_begin_exec();

            fs_shell_put(97);
            fs_shell_put(112);
            fs_shell_put(112);
            fs_shell_put(115);
            fs_shell_put(47);

            sh_c = 0;
            while (sh_c < sh_n) {
                fs_shell_put(sh_cmd[sh_c]);
                sh_c = sh_c + 1;
            }

            fs_shell_put(0);
            sh_pid = fs_shell_exec(4);

            if (sh_pid >= 0) {
                sh_wait(sh_pid);
            } else {
                print_char(63);
                print_char(13);
                print_char(10);
            }
        }
    }
}
