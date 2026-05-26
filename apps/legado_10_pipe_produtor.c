#include "../user/usr_printstr.c"
#include "../user/usr_sync.c"
#include "../user/usr_pipe.c"

void main() {
    write_pipe(79);
    write_pipe(108);
    write_pipe(97);
    write_pipe(32);
    write_pipe(67);
    write_pipe(97);
    write_pipe(114);
    write_pipe(105);
    write_pipe(114);
    write_pipe(105);
    write_pipe(33);
    write_pipe(10);
    write_pipe(0);

    sem_lock();
    printstr("P:F\n");
    sem_unlock();
    exit();
}
