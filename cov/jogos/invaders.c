#include "../user/usr_io.c"
#include "../user/usr_yield.c"

/*
 * INVADERS.COV v2
 * Janela alvo: 1536 palavras.
 *
 * A/D move, ESP atira, Q sai.
 */

#define W 18
#define H 8

int en[18];
int px;
int sx;
int sy;
int shot;
int dir;
int delay;
int score;
int key;
int i;
int y;
int alive;
int hit;

void nl() {
    print_char(13);
    print_char(10);
}

void esc() {
    print_char(27);
    print_char(91);
}

void color(int c) {
    esc();
    print_char(c);
    print_char(109);
}

void hide() {
    esc();
    print_char(63);
    print_char(50);
    print_char(53);
    print_char(108);
}

void show() {
    esc();
    print_char(63);
    print_char(50);
    print_char(53);
    print_char(104);
}

void number(int n) {
    int t;

    if (n >= 10) {
        t = 0;
        while (n >= 10) {
            n = n - 10;
            t = t + 1;
        }
        print_char(48 + t);
    }
    print_char(48 + n);
}

void frame() {
    print_char(12);

    color(96);
    print_char(73); print_char(78); print_char(86); print_char(65);
    print_char(68); print_char(69); print_char(82); print_char(83);
    color(97);
    print_char(32); print_char(83); print_char(67); print_char(79);
    print_char(82); print_char(69); print_char(32);
    color(93);
    number(score);
    nl();

    color(97);
    print_char(43);
    i = 0;
    while (i < W) {
        print_char(45);
        i = i + 1;
    }
    print_char(43);
    nl();

    y = 0;
    while (y < H) {
        color(97);
        print_char(124);

        i = 0;
        while (i < W) {
            hit = 0;

            if (y == 1) {
                if (en[i] != 0) {
                    color(91);
                    print_char(87);
                    hit = 1;
                }
            }

            if (shot != 0) {
                if (i == sx) {
                    if (y == sy) {
                        color(93);
                        print_char(124);
                        hit = 1;
                    }
                }
            }

            if (y == H - 1) {
                if (i == px) {
                    color(92);
                    print_char(65);
                    hit = 1;
                }
            }

            if (hit == 0) {
                print_char(32);
            }

            i = i + 1;
        }

        color(97);
        print_char(124);
        nl();
        y = y + 1;
    }

    print_char(43);
    i = 0;
    while (i < W) {
        print_char(45);
        i = i + 1;
    }
    print_char(43);
}

void main() {
    i = 0;
    while (i < W) {
        en[i] = 1;
        i = i + 1;
    }

    px = 8;
    shot = 0;
    dir = 1;
    delay = 0;
    score = 0;
    alive = W;

    hide();

    while (alive > 0) {
        key = read_char();

        if (key == 97) {
            if (px > 0) {
                px = px - 1;
            }
        } else {
            if (key == 100) {
                if (px < W - 1) {
                    px = px + 1;
                }
            } else {
                if (key == 32) {
                    if (shot == 0) {
                        shot = 1;
                        sx = px;
                        sy = H - 2;
                    }
                } else {
                    if (key == 113) {
                        alive = 0;
                    }
                }
            }
        }

        if (shot != 0) {
            sy = sy - 1;

            if (sy == 1) {
                if (en[sx] != 0) {
                    en[sx] = 0;
                    alive = alive - 1;
                    score = score + 1;
                }
                shot = 0;
            }
        }

        delay = delay + 1;
        if (delay >= 10) {
            delay = 0;

            if (dir == 1) {
                if (en[W - 1] != 0) {
                    dir = 0 - 1;
                }
            } else {
                if (en[0] != 0) {
                    dir = 1;
                }
            }

            if (dir == 1) {
                i = W;
                while (i > 1) {
                    i = i - 1;
                    en[i] = en[i - 1];
                }
                en[0] = 0;
            } else {
                i = 0;
                while (i < W - 1) {
                    en[i] = en[i + 1];
                    i = i + 1;
                }
                en[W - 1] = 0;
            }
        }

        frame();
        yield();
        yield();
    }

    show();
    color(0);
    print_char(12);
}
