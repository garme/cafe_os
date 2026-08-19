#include "../user/usr_io.c"
#include "../user/usr_fs.c"

void main() {
    print_char(12);
    fs_mount();
    fs_list("/data");

    if (fs_error() == FS_OK) {
        fs_print_rx();
    } else {
        print_char(63);
        print_char(13);
        print_char(10);
    }
}
