#include "../user/usr_io.c"

void main() {
    while(1) {
        print_char(read_char());
    }
}
