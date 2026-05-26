#ifndef USR_STDIO_C
#define USR_STDIO_C

#include "../user/usr_print_char.c"
#include "../user/usr_read_char.c"
#include "../user/usr_printstr.c"
#include "../user/usr_printint.c"

int readint() {
    int val;
    int c;
    int reading;
    int tmp;

    val = 0;
    reading = 1;

    while (reading == 1) {
        c = read_char();
        if (c == 0) {
            asm("MOV 0"); asm("SOP PUSH_OP"); asm("MOV 9"); asm("SOP PUSH_OP"); asm("INT SYSCALL_INT");
        } else {
            if (c == 10) {
                reading = 0;
            } else {
                tmp = val + val;
                val = tmp + tmp;
                val = val + val;
                val = val + tmp + (c - 48);
            }
        }
    }
    return val;
}

void readstr(char* buffer) {
    int c;
    int i;
    int reading;
    
    i = 0;
    reading = 1;
    
    while (reading == 1) {
        c = read_char();
        if (c == 0) {
            asm("MOV 0"); asm("SOP PUSH_OP"); asm("MOV 9"); asm("SOP PUSH_OP"); asm("INT SYSCALL_INT");
        } else {
            if (c == 10) {
                buffer[i] = (char) 0;
                reading = 0;
            } else {
                buffer[i] = (char) c;
                i = i + 1;
            }
        }
    }
}

#endif
