#ifndef SYS_MUTEX_C
#define SYS_MUTEX_C

int MUTEX_STATE = 0;

int kernel_mutex_trylock() {
    if (MUTEX_STATE == 0) {
        MUTEX_STATE = 1;
        return 1;
    }
    return 0;
}

void kernel_mutex_unlock() {
    MUTEX_STATE = 0;
}

#endif
