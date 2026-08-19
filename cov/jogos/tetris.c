#include "../user/usr_io.c"
#include "../user/usr_yield.c"

/*
 * TETRIS.COV v2
 * Domino horizontal/vertical, placar e moldura.
 *
 * A/D move, W gira, S desce, ESP queda, Q sai.
 */

#define W 8
#define H 14

int board[14];
int bits[8] = {1,2,4,8,16,32,64,128};
int x;
int y;
int rot;
int key;
int tick;
int over;
int i;
int j;
int cell;
int can;
int score;
int lines;
int drop;

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

void num(int n) {
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

int valid(int nx, int ny, int nr) {
    if (nx < 0) {
        return 0;
    }

    if (nr == 0) {
        if (nx >= W - 1) {
            return 0;
        }
        if (ny >= H) {
            return 0;
        }
        if ((board[ny] & bits[nx]) != 0) {
            return 0;
        }
        if ((board[ny] & bits[nx + 1]) != 0) {
            return 0;
        }
    } else {
        if (nx >= W) {
            return 0;
        }
        if (ny >= H - 1) {
            return 0;
        }
        if ((board[ny] & bits[nx]) != 0) {
            return 0;
        }
        if ((board[ny + 1] & bits[nx]) != 0) {
            return 0;
        }
    }

    return 1;
}

void draw() {
    print_char(12);

    color(96);
    print_char(84); print_char(69); print_char(84); print_char(82);
    print_char(73); print_char(83);
    color(97);
    print_char(32); print_char(83); print_char(61);
    color(93); num(score);
    color(97); print_char(32); print_char(76); print_char(61);
    color(92); num(lines);
    nl();

    color(97);
    print_char(43);
    i = 0;
    while (i < W) {
        print_char(45);
        print_char(45);
        i = i + 1;
    }
    print_char(43);
    nl();

    i = 0;
    while (i < H) {
        color(97);
        print_char(124);

        j = 0;
        while (j < W) {
            cell = 0;

            if ((board[i] & bits[j]) != 0) {
                cell = 1;
            }

            if (rot == 0) {
                if (i == y) {
                    if (j == x) {
                        cell = 2;
                    }
                    if (j == x + 1) {
                        cell = 2;
                    }
                }
            } else {
                if (j == x) {
                    if (i == y) {
                        cell = 2;
                    }
                    if (i == y + 1) {
                        cell = 2;
                    }
                }
            }

            if (cell == 1) {
                color(94);
                print_char(91);
                print_char(93);
            } else {
                if (cell == 2) {
                    color(93);
                    print_char(91);
                    print_char(93);
                } else {
                    print_char(32);
                    print_char(32);
                }
            }

            j = j + 1;
        }

        color(97);
        print_char(124);
        nl();
        i = i + 1;
    }

    print_char(43);
    i = 0;
    while (i < W) {
        print_char(45);
        print_char(45);
        i = i + 1;
    }
    print_char(43);
}

void lock_piece() {
    if (rot == 0) {
        board[y] = board[y] | bits[x];
        board[y] = board[y] | bits[x + 1];
    } else {
        board[y] = board[y] | bits[x];
        board[y + 1] = board[y + 1] | bits[x];
    }

    score = score + 1;

    i = H;
    while (i > 0) {
        i = i - 1;

        if (board[i] == 255) {
            j = i;
            while (j > 0) {
                board[j] = board[j - 1];
                j = j - 1;
            }

            board[0] = 0;
            lines = lines + 1;
            score = score + 5;
            i = i + 1;
        }
    }

    x = 3;
    y = 0;
    rot = 0;

    if (valid(x, y, rot) == 0) {
        over = 1;
    }
}

void step_down() {
    if (valid(x, y + 1, rot) != 0) {
        y = y + 1;
    } else {
        lock_piece();
    }
}

void main() {
    i = 0;
    while (i < H) {
        board[i] = 0;
        i = i + 1;
    }

    x = 3;
    y = 0;
    rot = 0;
    tick = 0;
    over = 0;
    score = 0;
    lines = 0;

    hide();

    while (over == 0) {
        key = read_char();

        if (key == 97) {
            if (valid(x - 1, y, rot) != 0) {
                x = x - 1;
            }
        } else {
            if (key == 100) {
                if (valid(x + 1, y, rot) != 0) {
                    x = x + 1;
                }
            } else {
                if (key == 119) {
                    if (rot == 0) {
                        can = 1;
                    } else {
                        can = 0;
                    }

                    if (valid(x, y, can) != 0) {
                        rot = can;
                    }
                } else {
                    if (key == 115) {
                        tick = 20;
                    } else {
                        if (key == 32) {
                            drop = 1;
                            while (drop != 0) {
                                if (valid(x, y + 1, rot) != 0) {
                                    y = y + 1;
                                } else {
                                    drop = 0;
                                }
                            }
                            lock_piece();
                        } else {
                            if (key == 113) {
                                over = 1;
                            }
                        }
                    }
                }
            }
        }

        tick = tick + 1;
        if (tick >= 20) {
            tick = 0;
            step_down();
        }

        draw();
        yield();
    }

    show();
    color(0);
    print_char(12);
}
