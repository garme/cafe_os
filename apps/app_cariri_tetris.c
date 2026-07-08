#include "../user/usr_io.c"
#include "../user/usr_yield.c"

/*
 * Cariri Tetris v1.1 final - correção do laço de limpeza de linhas
 * Overlay textual para CAFE OS / GUILIX.
 */

#define BOARD_W 10
#define BOARD_H 18
#define BOARD_TOP 3
#define BOARD_LEFT 3
#define HUD_LEFT 30
#define CONTROL_ROW 23
#define STATUS_ROW 24

#define COLOR_RESET 0
#define COLOR_RED 91
#define COLOR_GREEN 92
#define COLOR_YELLOW 93
#define COLOR_BLUE 94
#define COLOR_MAGENTA 95
#define COLOR_CYAN 96
#define COLOR_WHITE 97

#define T_0 0
#define T_1 4
#define T_2 8
#define T_3 12
#define T_4 15
#define T_5 25
#define T_6 32
#define T_7 57
#define T_8 69
#define T_9 73
#define T_10 77
#define T_11 82
#define T_12 92
#define T_13 104
#define T_14 112
#define T_15 127

int text_data[134] = {
    7003, 12874, 7003, 18432, 7003, 16178, 13676, 0, 7003, 16178, 13672, 0, 7003, 12875, 0, 17217,
    21065, 21065, 8276, 17748, 21065, 21280, 16975, 20308, 0, 17217, 21065, 21065, 8276, 17748, 21065, 21248,
    16687, 17440, 28015, 30309, 8279, 8295, 26994, 24864, 21280, 25701, 29539, 25888, 17747, 20545, 17231, 8291,
    24937, 8272, 8304, 24949, 29537, 8273, 8307, 24937, 0, 20594, 25971, 29545, 28526, 25888, 30061, 24864,
    29797, 25452, 24878, 11822, 0, 21315, 20306, 17696, 0, 19529, 20040, 16723, 8192, 18241, 19781, 8271,
    22085, 20992, 21024, 29285, 26990, 26979, 26977, 8316, 8273, 8307, 24937, 0, 21093, 29807, 29294, 24942,
    25711, 8289, 28448, 18261, 18764, 18776, 11822, 11776, 19529, 20040, 16672, 17231, 19792, 19525, 21569, 8448,
    20545, 21843, 16708, 20256, 11552, 20512, 25455, 28276, 26990, 30049, 8239, 8273, 8307, 24937, 0, 16975,
    16672, 20545, 21076, 18756, 16673, 0
};

int board[18];
int bit10[10] = {1,2,4,8,16,32,64,128,256,512};
int bit16[16] = {1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768};
int row_base[4] = {0,4,8,12};
int piece_base[7] = {0,4,8,12,16,20,24};

/* I, O, T, S, Z, J, L; quatro rotações por peça. */
int shape_masks[28] = {
    3840,17476,240,8738,
    1632,1632,1632,1632,
    1248,17984,3648,9760,
    1728,17952,1728,17952,
    3168,9792,3168,9792,
    3616,8800,2272,25664,
    3712,25120,736,17504
};

int piece_type;
int piece_rot;
int piece_x;
int piece_y;

int score;
int lines_total;
int drop_counter;
int drop_period;
int game_over;
int quit_game;
int paused;
int running;
int random_seed;
int current_color;
int last_key;

int g_i;
int g_j;
int g_k;
int g_r;
int g_c;
int g_mask;
int g_value;
int g_lines;
int g_pause;





void tx(int pos) {
    g_mask = text_data[pos];

    while (g_mask != 0) {
        g_value = g_mask >> 8;
        g_k = g_mask & 255;

        if (g_value != 0) {
            print_char(g_value);
        }

        if (g_k == 0) {
            return;
        }

        print_char(g_k);
        pos = pos + 1;
        g_mask = text_data[pos];
    }
}


void newline() {
    print_char(13);
    print_char(10);
}


void print_num3(int value) {
    g_value = 0;
    while (value >= 100) {
        value = value - 100;
        g_value = g_value + 1;
    }
    print_char(48 + g_value);

    g_value = 0;
    while (value >= 10) {
        value = value - 10;
        g_value = g_value + 1;
    }
    print_char(48 + g_value);
    print_char(48 + value);
}


void ansi_number(int value) {
    if (value >= 10) {
        g_value = 0;
        while (value >= 10) {
            value = value - 10;
            g_value = g_value + 1;
        }
        print_char(48 + g_value);
    }
    print_char(48 + value);
}


void ansi_color(int color) {
    if (current_color == color) {
        return;
    }

    print_char(27);
    print_char(91);
    ansi_number(color);
    print_char(109);
    current_color = color;
}


void cursor_pos(int row, int col) {
    print_char(27);
    print_char(91);
    ansi_number(row);
    print_char(59);
    ansi_number(col);
    print_char(72);
}


void clear_screen() {
    print_char(12);
    tx(T_0);
}


void hide_cursor() {
    tx(T_1);
}


void show_cursor() {
    tx(T_2);
}


void clear_line(int row) {
    cursor_pos(row, 1);
    tx(T_3);
}


void repeat_char(int c, int count) {
    g_i = 0;
    while (g_i < count) {
        print_char(c);
        g_i = g_i + 1;
    }
}


void cooperative_delay(int steps) {
    g_pause = 0;
    while (g_pause < steps) {
        yield();
        g_pause = g_pause + 1;
    }
}


void drain_input() {
    last_key = read_char();
    while (last_key != 0) {
        last_key = read_char();
    }
}


int wait_key() {
    drain_input();
    last_key = read_char();

    while (last_key == 0) {
        yield();
        last_key = read_char();
    }

    return last_key;
}


void boot_probe() {
    tx(T_4);
    newline();
}


void show_title() {
    show_cursor();
    clear_screen();
    current_color = -1;
    boot_probe();
    ansi_color(COLOR_CYAN);
    tx(T_5);
    newline();
    ansi_color(COLOR_WHITE);
    tx(T_6);
    newline();
    ansi_color(COLOR_YELLOW);
    tx(T_7);
    ansi_color(COLOR_RESET);
    wait_key();
}


void draw_border() {
    ansi_color(COLOR_CYAN);

    g_i = 0;
    while (g_i <= BOARD_H) {
        cursor_pos(BOARD_TOP + g_i, BOARD_LEFT);
        print_char(124);
        cursor_pos(BOARD_TOP + g_i, BOARD_LEFT + BOARD_W + BOARD_W + 1);
        print_char(124);
        g_i = g_i + 1;
    }

    cursor_pos(BOARD_TOP + BOARD_H, BOARD_LEFT);
    print_char(43);
    repeat_char(45, BOARD_W + BOARD_W);
    print_char(43);

    cursor_pos(CONTROL_ROW, 2);
    ansi_color(COLOR_WHITE);
    tx(T_6);
}


void clear_status() {
    clear_line(STATUS_ROW);
}


void status_text(int text, int color) {
    clear_status();
    cursor_pos(STATUS_ROW, 2);
    ansi_color(color);
    tx(text);
}


void draw_hud() {
    cursor_pos(BOARD_TOP, HUD_LEFT);
    ansi_color(COLOR_WHITE);
    tx(T_8);
    ansi_color(COLOR_YELLOW);
    print_num3(score);
    cursor_pos(BOARD_TOP + 2, HUD_LEFT);
    ansi_color(COLOR_WHITE);
    tx(T_9);
    ansi_color(COLOR_GREEN);
    print_num3(lines_total);
}


void draw_cell(int x, int y, int filled, int color) {
    cursor_pos(BOARD_TOP + y, BOARD_LEFT + 1 + x + x);

    if (filled != 0) {
        ansi_color(color);
        print_char(91);
        print_char(93);
    } else {
        print_char(32);
        print_char(32);
    }
}


int valid_position(int type, int rot, int px, int py) {
    g_mask = shape_masks[piece_base[type] + rot];
    g_i = 0;

    while (g_i < 4) {
        g_j = 0;

        while (g_j < 4) {
            g_k = row_base[g_i] + g_j;
            if ((g_mask & bit16[g_k]) != 0) {
                g_c = px + g_j;
                g_r = py + g_i;

                if (g_c < 0) {
                    return 0;
                }

                if (g_c >= BOARD_W) {
                    return 0;
                }

                if (g_r >= BOARD_H) {
                    return 0;
                }

                if (g_r >= 0) {
                    if ((board[g_r] & bit10[g_c]) != 0) {
                        return 0;
                    }
                }
            }

            g_j = g_j + 1;
        }

        g_i = g_i + 1;
    }

    return 1;
}


void draw_piece_at(int type, int rot, int px, int py, int visible) {
    g_mask = shape_masks[piece_base[type] + rot];
    g_i = 0;

    while (g_i < 4) {
        g_j = 0;

        while (g_j < 4) {
            g_k = row_base[g_i] + g_j;
            if ((g_mask & bit16[g_k]) != 0) {
                g_c = px + g_j;
                g_r = py + g_i;

                if (g_r >= 0) {
                    if (visible != 0) {
                        draw_cell(g_c, g_r, 1, COLOR_MAGENTA);
                    } else {
                        draw_cell(g_c, g_r, 0, COLOR_RESET);
                    }
                }
            }

            g_j = g_j + 1;
        }

        g_i = g_i + 1;
    }
}


void draw_board() {
    g_i = 0;

    while (g_i < BOARD_H) {
        g_j = 0;

        while (g_j < BOARD_W) {
            if ((board[g_i] & bit10[g_j]) != 0) {
                draw_cell(g_j, g_i, 1, COLOR_BLUE);
            } else {
                draw_cell(g_j, g_i, 0, COLOR_RESET);
            }

            g_j = g_j + 1;
        }

        g_i = g_i + 1;
    }
}


void random_next() {
    random_seed = random_seed + 73 + score + lines_total;

    while (random_seed > 250) {
        random_seed = random_seed - 251;
    }
}


int random_piece() {
    random_next();
    g_value = random_seed;

    while (g_value >= 7) {
        g_value = g_value - 7;
    }

    return g_value;
}


void spawn_piece() {
    piece_type = random_piece();
    piece_rot = 0;
    piece_x = 3;
    piece_y = 0;
    draw_hud();

    if (valid_position(piece_type, piece_rot, piece_x, piece_y) == 0) {
        game_over = 1;
        return;
    }

    draw_piece_at(piece_type, piece_rot, piece_x, piece_y, 1);
}


void lock_piece() {
    g_mask = shape_masks[piece_base[piece_type] + piece_rot];
    g_i = 0;

    while (g_i < 4) {
        g_j = 0;

        while (g_j < 4) {
            g_k = row_base[g_i] + g_j;
            if ((g_mask & bit16[g_k]) != 0) {
                g_c = piece_x + g_j;
                g_r = piece_y + g_i;

                if (g_r >= 0) {
                    board[g_r] = board[g_r] | bit10[g_c];
                }
            }

            g_j = g_j + 1;
        }

        g_i = g_i + 1;
    }
}


int row_full(int row) {
    if (board[row] == 1023) {
        return 1;
    }

    return 0;
}


void remove_row(int row) {
    g_i = row;

    while (g_i > 0) {
        board[g_i] = board[g_i - 1];
        g_i = g_i - 1;
    }

    board[0] = 0;
}


void clear_complete_lines() {
    /*
     * Nunca use while (g_i >= 0) na Cariri.
     * As palavras são de 16 bits; 0 - 1 vira 65535 e o laço não termina.
     *
     * O contador começa em BOARD_H e decrementa no início da iteração.
     * Assim a linha 0 também é verificada, mas o laço termina quando g_i == 0.
     *
     * remove_row() usa g_i internamente; por isso salvamos a linha em g_k
     * antes da chamada e restauramos o ponto de varredura depois.
     */
    g_lines = 0;
    g_i = BOARD_H;

    while (g_i > 0) {
        g_i = g_i - 1;

        if (row_full(g_i) != 0) {
            g_k = g_i;
            remove_row(g_i);
            g_lines = g_lines + 1;

            /*
             * Reexamina a mesma altura no próximo passo, porque a linha de
             * cima acabou de descer para esta posição.
             */
            g_i = g_k + 1;
        }
    }

    if (g_lines > 0) {
        lines_total = lines_total + g_lines;
        score = score + g_lines + g_lines + g_lines;

        drop_period = drop_period - g_lines;
        if (drop_period < 5) {
            drop_period = 5;
        }

        status_text(T_13, COLOR_GREEN);
        draw_board();
        draw_hud();
        cooperative_delay(5);
        clear_status();
    }
}


void move_piece(int dx) {
    if (valid_position(piece_type, piece_rot, piece_x + dx, piece_y) != 0) {
        draw_piece_at(piece_type, piece_rot, piece_x, piece_y, 0);
        piece_x = piece_x + dx;
        draw_piece_at(piece_type, piece_rot, piece_x, piece_y, 1);
    }
}


void rotate_piece() {
    g_value = piece_rot + 1;
    if (g_value >= 4) {
        g_value = 0;
    }

    if (valid_position(piece_type, g_value, piece_x, piece_y) != 0) {
        draw_piece_at(piece_type, piece_rot, piece_x, piece_y, 0);
        piece_rot = g_value;
        draw_piece_at(piece_type, piece_rot, piece_x, piece_y, 1);
    }
}


int drop_one() {
    if (valid_position(piece_type, piece_rot, piece_x, piece_y + 1) != 0) {
        draw_piece_at(piece_type, piece_rot, piece_x, piece_y, 0);
        piece_y = piece_y + 1;
        draw_piece_at(piece_type, piece_rot, piece_x, piece_y, 1);
        return 1;
    }

    draw_piece_at(piece_type, piece_rot, piece_x, piece_y, 0);
    lock_piece();
    draw_piece_at(piece_type, piece_rot, piece_x, piece_y, 1);
    clear_complete_lines();
    spawn_piece();
    return 0;
}


void hard_drop() {
    draw_piece_at(piece_type, piece_rot, piece_x, piece_y, 0);

    while (valid_position(piece_type, piece_rot, piece_x, piece_y + 1) != 0) {
        piece_y = piece_y + 1;
    }

    lock_piece();
    draw_piece_at(piece_type, piece_rot, piece_x, piece_y, 1);
    clear_complete_lines();
    spawn_piece();
}


void pause_game() {
    paused = 1;
    status_text(T_14, COLOR_YELLOW);

    while (paused != 0) {
        last_key = read_char();

        if (last_key >= 65) {
            if (last_key <= 90) {
                last_key = last_key + 32;
            }
        }

        if (last_key == 112) {
            paused = 0;
        } else {
            if (last_key == 113) {
                quit_game = 1;
                paused = 0;
            } else {
                yield();
            }
        }
    }

    clear_status();
}


void handle_input() {
    last_key = read_char();

    if (last_key >= 65) {
        if (last_key <= 90) {
            last_key = last_key + 32;
        }
    }

    if (last_key == 97 || last_key == 106) {
        move_piece(-1);
    } else {
        if (last_key == 100 || last_key == 108) {
            move_piece(1);
        } else {
            if (last_key == 119 || last_key == 105) {
                rotate_piece();
            } else {
                if (last_key == 115 || last_key == 107) {
                    drop_one();
                } else {
                    if (last_key == 32) {
                        hard_drop();
                    } else {
                        if (last_key == 112) {
                            pause_game();
                        } else {
                            if (last_key == 113) {
                                quit_game = 1;
                            }
                        }
                    }
                }
            }
        }
    }
}


void reset_game() {
    g_i = 0;
    while (g_i < BOARD_H) {
        board[g_i] = 0;
        g_i = g_i + 1;
    }

    score = 0;
    lines_total = 0;
    drop_counter = 0;
    drop_period = 20;
    game_over = 0;
    quit_game = 0;
    paused = 0;
    random_seed = 17;

    hide_cursor();
    clear_screen();
    current_color = -1;
    draw_border();
    draw_board();
    spawn_piece();
    status_text(T_15, COLOR_YELLOW);
    cooperative_delay(5);
    clear_status();
}


void play_game() {
    while (game_over == 0) {
        if (quit_game != 0) {
            return;
        }

        handle_input();
        drop_counter = drop_counter + 1;

        if (drop_counter >= drop_period) {
            drop_counter = 0;
            drop_one();
        }

        cooperative_delay(2);
    }
}


int end_screen() {
    show_cursor();
    clear_screen();
    current_color = -1;
    ansi_color(COLOR_RED);
    tx(T_10);
    newline();
    ansi_color(COLOR_WHITE);
    tx(T_8);
    print_num3(score);
    newline();
    tx(T_11);

    while (1 != 0) {
        last_key = wait_key();
        if (last_key >= 65) {
            if (last_key <= 90) {
                last_key = last_key + 32;
            }
        }
        if (last_key == 114) {
            return 1;
        }
        if (last_key == 113) {
            return 0;
        }
    }

    return 0;
}


void main() {
    running = 1;
    current_color = -1;

    while (running != 0) {
        show_title();
        reset_game();
        play_game();

        if (quit_game != 0) {
            running = 0;
        } else {
            if (end_screen() == 0) {
                running = 0;
            }
        }
    }

    show_cursor();
    clear_screen();
    ansi_color(COLOR_RESET);
    tx(T_12);
    newline();
}
