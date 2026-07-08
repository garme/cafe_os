#include "../user/usr_io.c"
#include "../user/usr_yield.c"

void p(char* s) {
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

void main() {
    p("\r\n[HELLO.COV] Programa carregado do disco virtual.\r\n");
    p("[HELLO.COV] Overlay dinamico executado com sucesso.\r\n");
    yield();
}
