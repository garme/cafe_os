#include "usr_syscalls.c"

int cont_a;
int cont_b;

naked void task_a() {
    cont_a = 0;
    while(1) {
        cont_a = cont_a + 1;
        printint(cont_a);
        print_space();
    }
}

naked void task_b() {
    cont_b = 0;
    while(1) {
        cont_b = cont_b + 1;
        printint(cont_b);
        print_space();
    }
}
