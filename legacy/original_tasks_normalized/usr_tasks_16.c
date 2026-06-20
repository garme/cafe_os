#include "usr_syscalls.c"


int c;

naked void task_a() {

    while(1){
        
        print_char(read_char());
    
    }
}
