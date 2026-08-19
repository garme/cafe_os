#include "../user/usr_io.c"
#include "../user/usr_yield.c"

/*
 * Cariri Invaders v2.1
 * Jogo ANSI para CAFE OS / GUILIX e CPU Cariri.
 *
 * Revisao visual/funcional:
 * - sprites de invasores com 3 caracteres e cores por linha;
 * - campo fechado 80x30 e HUD compacto;
 * - projeteis com leitura visual mais clara;
 * - pontuacao por classe de invasor;
 * - correcao do apagamento de sprites sem clobber de g_i.
 *
 * Projeto orientado às restrições da plataforma:
 * - renderização incremental por cursor ANSI;
 * - invasores representados por três máscaras de 10 bits;
 * - apenas um disparo do jogador e um disparo inimigo;
 * - sem framebuffer, heap, ponto flutuante ou biblioteca externa;
 * - textos compactados com dois caracteres por palavra de 16 bits.
 */

#define FIELD_LEFT 2
#define FIELD_RIGHT 79
#define FIELD_TOP 2
#define FIELD_BOTTOM 23
#define PLAYER_Y 21
#define ENEMY_COLS 10
#define ENEMY_ROWS 3
#define ENEMY_GAP 6
#define MAX_WAVE 5
#define CONTROL_ROW 25
#define STATUS_ROW 26

#define T_RESET 0
#define T_RED 3
#define T_GREEN 7
#define T_YELLOW 11
#define T_BLUE 15
#define T_MAGENTA 19
#define T_CYAN 23
#define T_WHITE 27
#define T_GRAY 31
#define T_HIDE 35
#define T_SHOW 39
#define T_HOME 43
#define T_TITLE 46
#define T_SCORE 177
#define T_WAVE 181
#define T_LIVES 185
#define T_CONTROLS 190
#define T_PAUSED 215
#define T_READY 230
#define T_WAVE_CLEAR 236
#define T_HIT 243
#define T_GAME_OVER 249
#define T_VICTORY 266
#define T_QUIT 282

int text_data[293] = {
    7003,12397,0,7003,14641,27904,0,7003,14642,27904,0,7003,14643,27904,0,7003,
    14644,27904,0,7003,14645,27904,0,7003,14646,27904,0,7003,14647,27904,0,7003,
    14640,27904,0,7003,16178,13676,0,7003,16178,13672,0,7003,18432,0,7003,14646,
    27936,8224,8224,8224,8224,8224,8224,8235,11565,11565,11565,11565,11565,11565,11565,11565,
    11565,11565,11565,11021,2592,8224,8224,8224,8224,8224,8224,8316,8224,8259,16722,18770,
    18720,18766,22081,17477,21075,8224,8224,31757,2592,8224,8224,8224,8224,8224,8224,8235,
    11565,11565,11565,11565,11565,11565,11565,11565,11565,11565,11565,11021,2587,23353,14189,8224,
    8224,8224,8224,8224,8224,8224,8224,8224,15425,15904,15437,15904,12119,23584,31574,32013,
    2587,23353,13165,8224,8224,8224,8224,16687,17440,28015,30309,8316,8275,20545,17221,8294,
    28519,28448,31776,20512,28769,30067,24864,31776,20768,29537,26893,2592,8224,8224,8224,8224,
    8224,8224,8224,8224,20594,25971,29545,28526,25888,30061,24864,29797,25452,24859,23344,27904,
    0,21315,20306,17696,0,8279,16726,17696,0,8268,18774,17747,8192,0,8257,12100,
    11594,12108,8301,28534,25970,8316,8275,20545,17221,8294,28519,28448,31776,20512,28769,30067,
    24864,31776,20768,29537,26994,8192,0,20545,21843,16708,20256,31776,20512,25455,28276,26990,
    30049,8316,8273,8307,24937,0,20594,25968,24946,25901,29541,0,20302,17473,8268,18765,
    20545,8448,0,16724,18766,18249,17487,8448,0,7003,14641,27946,10794,8263,16717,17696,
    20310,17746,8234,10794,7003,12397,3338,21039,20736,0,7003,14642,27946,10794,8278,18772,
    20306,18753,8480,10794,10779,23344,27917,2642,12113,0,22127,27764,24942,25711,8289,28448,
    18261,18764,18776,3338,0
};

int bit_table[10] = {1,2,4,8,16,32,64,128,256,512};

int player_x;
int old_player_x;
int lives;
int score;
int wave;
int paused;
int quit_game;
int game_state;
int running;

int shot_active;
int shot_x;
int shot_y;

int enemy_shot_active;
int enemy_shot_x;
int enemy_shot_y;

int enemy_masks[3];
int enemy_cols_x[10];
int enemy_y;
int enemy_dir;
int enemy_tick;
int enemy_period;
int enemy_fire_tick;

int frame_counter;
int random_seed;
int current_color;
int last_key;

/* temporários globais para reduzir BSS local e prólogos */
int g_i;
int g_j;
int g_k;
int g_v;
int g_a;
int g_b;
int g_w;
int g_pause;


void tx(int pos) {
    g_w = text_data[pos];

    while (g_w != 0) {
        g_a = g_w >> 8;
        g_b = g_w & 255;

        if (g_a != 0) {
            print_char(g_a);
        }

        if (g_b == 0) {
            return;
        }

        print_char(g_b);
        pos = pos + 1;
        g_w = text_data[pos];
    }
}

void set_color(int color_pos) {
    if (current_color != color_pos) {
        tx(color_pos);
        current_color = color_pos;
    }
}

void cls() {
    /* ESC[2J + ESC[H: independente do tratamento de form-feed do host. */
    print_char(27);
    print_char(91);
    print_char(50);
    print_char(74);
    tx(T_HOME);
}

void nl() {
    print_char(13);
    print_char(10);
}

void repeat_char(int c, int count) {
    g_i = 0;
    while (g_i < count) {
        print_char(c);
        g_i = g_i + 1;
    }
}

void pause_ticks(int ticks) {
    /*
     * Compatibilidade máxima: não depende da syscall sleep.
     * Cada yield atravessa o dispatcher e o escalonador do GUILIX.
     */
    g_pause = 0;
    while (g_pause < ticks) {
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
    /* Não descarte a primeira tecla já recebida pelo FIFO do simulador. */
    last_key = 0;
    while (last_key == 0) {
        last_key = read_char();
    }
    return last_key;
}

void print_small(int value) {
    if (value >= 10) {
        g_v = 0;
        while (value >= 10) {
            value = value - 10;
            g_v = g_v + 1;
        }
        print_char(48 + g_v);
    }
    print_char(48 + value);
}

void print_score(int value) {
    g_v = 0;
    while (value >= 1000) {
        value = value - 1000;
        g_v = g_v + 1;
    }
    print_char(48 + g_v);

    g_v = 0;
    while (value >= 100) {
        value = value - 100;
        g_v = g_v + 1;
    }
    print_char(48 + g_v);

    g_v = 0;
    while (value >= 10) {
        value = value - 10;
        g_v = g_v + 1;
    }
    print_char(48 + g_v);
    print_char(48 + value);
}

void cursor_pos(int row, int col) {
    print_char(27);
    print_char(91);
    print_small(row);
    print_char(59);
    print_small(col);
    print_char(72);
}

void draw_frame() {
    current_color = -1;
    set_color(T_CYAN);

    cursor_pos(FIELD_TOP, FIELD_LEFT);
    print_char(43);
    repeat_char(45, 76);
    print_char(43);

    g_i = FIELD_TOP + 1;
    while (g_i < FIELD_BOTTOM) {
        cursor_pos(g_i, FIELD_LEFT);
        print_char(124);
        cursor_pos(g_i, FIELD_RIGHT);
        print_char(124);
        g_i = g_i + 1;
    }

    cursor_pos(FIELD_BOTTOM, FIELD_LEFT);
    print_char(43);
    repeat_char(45, 76);
    print_char(43);

    cursor_pos(CONTROL_ROW, 2);
    set_color(T_GRAY);
    tx(T_CONTROLS);
}

void clear_status_line() {
    cursor_pos(STATUS_ROW, 1);
    print_char(27);
    print_char(91);
    print_char(50);
    print_char(75);
}

void status_text(int text_pos, int color_pos) {
    clear_status_line();
    set_color(color_pos);
    tx(text_pos);
}

void draw_hud() {
    cursor_pos(1, 2);
    set_color(T_WHITE);
    tx(T_SCORE);
    set_color(T_YELLOW);
    print_score(score);
    set_color(T_WHITE);
    tx(T_WAVE);
    set_color(T_CYAN);
    print_small(wave);
    print_char(47);
    print_small(MAX_WAVE);
    set_color(T_WHITE);
    tx(T_LIVES);
    set_color(T_GREEN);
    print_small(lives);
    repeat_char(32, 12);
}

void draw_player_at(int x, int c) {
    cursor_pos(PLAYER_Y, x - 1);
    if (c == 32) {
        repeat_char(32, 3);
    } else {
        set_color(T_GREEN);
        print_char(60);
        print_char(65);
        print_char(62);
    }
}

void draw_player() {
    if (old_player_x != player_x) {
        draw_player_at(old_player_x, 32);
        draw_player_at(player_x, 65);
        old_player_x = player_x;
    }
}

int enemy_alive(int row, int col) {
    if ((enemy_masks[row] & bit_table[col]) != 0) {
        return 1;
    }
    return 0;
}

void kill_enemy(int row, int col) {
    enemy_masks[row] = enemy_masks[row] & (65535 - bit_table[col]);
}

void erase_enemy_grid(int base_y) {
    g_i = 0;
    while (g_i < ENEMY_ROWS) {
        g_j = 0;
        while (g_j < ENEMY_COLS) {
            if (enemy_alive(g_i, g_j) != 0) {
                cursor_pos(base_y + (g_i + g_i), enemy_cols_x[g_j] - 1);
                print_char(32);
                print_char(32);
                print_char(32);
            }
            g_j = g_j + 1;
        }
        g_i = g_i + 1;
    }
}

void draw_enemy_sprite(int row, int x) {
    cursor_pos(enemy_y + (row + row), x - 1);

    if (row == 0) {
        set_color(T_MAGENTA);
        print_char(60);
        print_char(77);
        print_char(62);
        return;
    }

    if (row == 1) {
        set_color(T_CYAN);
        print_char(47);
        print_char(87);
        print_char(92);
        return;
    }

    set_color(T_YELLOW);
    print_char(123);
    print_char(86);
    print_char(125);
}

void draw_enemy_grid() {
    g_i = 0;
    while (g_i < ENEMY_ROWS) {
        g_j = 0;
        while (g_j < ENEMY_COLS) {
            if (enemy_alive(g_i, g_j) != 0) {
                draw_enemy_sprite(g_i, enemy_cols_x[g_j]);
            }
            g_j = g_j + 1;
        }
        g_i = g_i + 1;
    }
}

int enemies_remaining() {
    return enemy_masks[0] | enemy_masks[1] | enemy_masks[2];
}

void draw_shot(int x, int y, int c, int color_pos) {
    cursor_pos(y, x);
    if (c != 32) {
        set_color(color_pos);
    }
    print_char(c);
}

void explosion(int x, int y) {
    draw_shot(x, y, 42, T_YELLOW);
    pause_ticks(1);
    draw_shot(x, y, 43, T_WHITE);
    pause_ticks(1);
    draw_shot(x, y, 32, T_RESET);
}

void reset_wave() {
    enemy_masks[0] = 1023;
    enemy_masks[1] = 1023;
    enemy_masks[2] = 1023;

    g_i = 0;
    g_a = 10;
    while (g_i < ENEMY_COLS) {
        enemy_cols_x[g_i] = g_a;
        g_a = g_a + ENEMY_GAP;
        g_i = g_i + 1;
    }

    enemy_y = 4;
    enemy_dir = 1;
    enemy_tick = 0;
    enemy_fire_tick = 0;

    enemy_period = 11 - wave;
    if (enemy_period < 4) {
        enemy_period = 4;
    }

    shot_active = 0;
    enemy_shot_active = 0;
    player_x = 40;
    old_player_x = player_x;

    cls();
    draw_frame();
    draw_hud();
    draw_enemy_grid();
    draw_player_at(player_x, 65);
    status_text(T_READY, T_YELLOW);
    pause_ticks(8);
    clear_status_line();
}

void fire_player() {
    if (shot_active == 0) {
        shot_active = 1;
        shot_x = player_x;
        shot_y = PLAYER_Y - 1;
        draw_shot(shot_x, shot_y, 124, T_YELLOW);
    }
}

void update_player_shot() {
    if (shot_active == 0) {
        return;
    }

    draw_shot(shot_x, shot_y, 32, T_RESET);
    shot_y = shot_y - 1;

    if (shot_y <= FIELD_TOP) {
        shot_active = 0;
        return;
    }

    g_i = 0;
    while (g_i < ENEMY_ROWS) {
        g_j = 0;
        while (g_j < ENEMY_COLS) {
            if (enemy_alive(g_i, g_j) != 0) {
                g_a = enemy_cols_x[g_j];
                g_b = enemy_y + (g_i + g_i);

                if (shot_x >= g_a - 1) {
                    if (shot_x <= g_a + 1) {
                        if (shot_y == g_b) {
                            kill_enemy(g_i, g_j);
                            shot_active = 0;

                            if (g_i == 0) {
                                score = score + 15;
                            } else {
                                if (g_i == 1) {
                                    score = score + 10;
                                } else {
                                    score = score + 5;
                                }
                            }

                            cursor_pos(g_b, g_a - 1);
                            repeat_char(32, 3);
                            explosion(g_a, g_b);
                            draw_hud();
                            return;
                        }
                    }
                }
            }
            g_j = g_j + 1;
        }
        g_i = g_i + 1;
    }

    draw_shot(shot_x, shot_y, 124, T_YELLOW);
}

void random_next() {
    random_seed = random_seed + 73 + frame_counter + wave;
    while (random_seed > 250) {
        random_seed = random_seed - 251;
    }
}

void spawn_enemy_shot() {
    if (enemy_shot_active != 0) {
        return;
    }

    random_next();
    g_j = random_seed;
    while (g_j >= ENEMY_COLS) {
        g_j = g_j - ENEMY_COLS;
    }

    enemy_shot_active = 1;
    enemy_shot_x = enemy_cols_x[g_j];
    enemy_shot_y = enemy_y + 5;
    draw_shot(enemy_shot_x, enemy_shot_y, 118, T_RED);
}

void lose_life() {
    explosion(player_x, PLAYER_Y);
    draw_player_at(player_x, 32);
    lives = lives - 1;
    draw_hud();
    status_text(T_HIT, T_RED);
    pause_ticks(8);
    clear_status_line();

    enemy_shot_active = 0;
    player_x = 40;
    old_player_x = player_x;
    draw_player_at(player_x, 65);

    if (lives <= 0) {
        game_state = 1;
    }
}

void update_enemy_shot() {
    if (enemy_shot_active == 0) {
        return;
    }

    draw_shot(enemy_shot_x, enemy_shot_y, 32, T_RESET);
    enemy_shot_y = enemy_shot_y + 1;

    if (enemy_shot_y >= FIELD_BOTTOM) {
        enemy_shot_active = 0;
        return;
    }

    if (enemy_shot_y == PLAYER_Y) {
        if (enemy_shot_x >= player_x - 1) {
            if (enemy_shot_x <= player_x + 1) {
                enemy_shot_active = 0;
                lose_life();
                return;
            }
        }
    }

    draw_shot(enemy_shot_x, enemy_shot_y, 118, T_RED);
}

void update_enemies() {
    enemy_tick = enemy_tick + 1;
    if (enemy_tick < enemy_period) {
        return;
    }
    enemy_tick = 0;

    erase_enemy_grid(enemy_y);

    if (enemy_dir > 0) {
        if (enemy_cols_x[9] >= 75) {
            enemy_dir = -1;
            enemy_y = enemy_y + 1;
        } else {
            g_i = 0;
            while (g_i < ENEMY_COLS) {
                enemy_cols_x[g_i] = enemy_cols_x[g_i] + 1;
                g_i = g_i + 1;
            }
        }
    } else {
        if (enemy_cols_x[0] <= 5) {
            enemy_dir = 1;
            enemy_y = enemy_y + 1;
        } else {
            g_i = 0;
            while (g_i < ENEMY_COLS) {
                enemy_cols_x[g_i] = enemy_cols_x[g_i] - 1;
                g_i = g_i + 1;
            }
        }
    }

    draw_enemy_grid();

    if (enemy_y + 4 >= PLAYER_Y - 1) {
        game_state = 1;
    }
}

void pause_game() {
    paused = 1;
    status_text(T_PAUSED, T_YELLOW);

    while (paused != 0) {
        last_key = read_char();

        if (last_key >= 65) {
            if (last_key <= 90) {
                last_key = last_key + 32;
            }
        }

        switch (last_key) {
            case 112:
                paused = 0;
                break;
            case 113:
                quit_game = 1;
                paused = 0;
                break;
            default:
                yield();
                break;
        }
    }

    clear_status_line();
}

void handle_input() {
    last_key = read_char();

    if (last_key >= 65) {
        if (last_key <= 90) {
            last_key = last_key + 32;
        }
    }

    switch (last_key) {
        case 97:
        case 106:
            if (player_x > 4) {
                player_x = player_x - 1;
            }
            break;

        case 100:
        case 108:
            if (player_x < 77) {
                player_x = player_x + 1;
            }
            break;

        case 32:
            fire_player();
            break;

        case 112:
            pause_game();
            break;

        case 113:
            quit_game = 1;
            break;

        default:
            break;
    }

    draw_player();
}

void new_game() {
    score = 0;
    wave = 1;
    lives = 3;
    paused = 0;
    quit_game = 0;
    game_state = 0;
    frame_counter = 0;
    random_seed = 17;
    reset_wave();
}

void play_game() {
    while (game_state == 0) {
        if (quit_game != 0) {
            return;
        }

        handle_input();
        update_player_shot();
        update_enemy_shot();
        update_enemies();

        enemy_fire_tick = enemy_fire_tick + 1;
        if (enemy_fire_tick >= 18) {
            enemy_fire_tick = 0;
            spawn_enemy_shot();
        }

        if (enemies_remaining() == 0) {
            status_text(T_WAVE_CLEAR, T_GREEN);
            pause_ticks(8);

            if (wave >= MAX_WAVE) {
                game_state = 2;
            } else {
                wave = wave + 1;
                reset_wave();
            }
        }

        frame_counter = frame_counter + 1;
        pause_ticks(2);
    }
}

void show_title() {
    tx(T_SHOW);
    cls();
    current_color = -1;
    tx(T_TITLE);
    wait_key();
    tx(T_HIDE);
}

int end_screen() {
    cls();
    current_color = -1;

    cursor_pos(5, 20);
    if (game_state == 2) {
        tx(T_VICTORY);
    } else {
        tx(T_GAME_OVER);
    }

    cursor_pos(12, 30);
    tx(T_SCORE);
    print_score(score);

    last_key = 0;

    while (last_key != 114) {
        if (last_key == 113) {
            return 0;
        }

        last_key = wait_key();

        if (last_key >= 65) {
            if (last_key <= 90) {
                last_key = last_key + 32;
            }
        }
    }

    return 1;
}

void main() {
    running = 1;
    current_color = -1;

    while (running != 0) {
        show_title();
        new_game();
        play_game();

        if (quit_game != 0) {
            running = 0;
        } else {
            if (end_screen() == 0) {
                running = 0;
            }
        }
    }

    cls();
    tx(T_RESET);
    tx(T_SHOW);
    tx(T_QUIT);
}
