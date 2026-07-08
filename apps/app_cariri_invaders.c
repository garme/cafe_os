#include "../user/usr_io.c"
#include "../user/usr_yield.c"

/*
 * Cariri Invaders v1.6
 * Jogo textual para CAFE OS / GUILIX e CPU Cariri.
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

#define T_RESET 0
#define T_RED 3
#define T_GREEN 6
#define T_YELLOW 9
#define T_BLUE 12
#define T_MAGENTA 15
#define T_CYAN 18
#define T_WHITE 21
#define T_HIDE 24
#define T_SHOW 28
#define T_HOME 32
#define T_TITLE 34
#define T_SCORE 161
#define T_WAVE 165
#define T_LIVES 169
#define T_CONTROLS 174
#define T_PAUSED 197
#define T_READY 212
#define T_WAVE_CLEAR 219
#define T_HIT 227
#define T_GAME_OVER 235
#define T_VICTORY 272
#define T_QUIT 311

int text_data[324] = {
    7003, 12397, 0, 7003, 14641, 27904, 7003, 14642, 27904, 7003, 14643, 27904, 7003, 14644, 27904, 7003,
    14645, 27904, 7003, 14646, 27904, 7003, 14647, 27904, 7003, 16178, 13676, 0, 7003, 16178, 13672, 0,
    7003, 18432, 7003, 14646, 27936, 8224, 17184, 16672, 21024, 18720, 21024, 18720, 8224, 18720, 20000, 22048,
    16672, 17440, 17696, 21024, 21261, 2587, 23344, 27917, 2627, 20565, 8259, 24946, 26994, 26912, 11040, 18261,
    18764, 18776, 8235, 8261, 21328, 13106, 8278, 18241, 12112, 21298, 3338, 3338, 17772, 26989, 26990, 25888,
    24947, 8291, 26990, 25455, 8303, 28260, 24947, 8289, 28276, 25971, 8292, 24864, 26990, 30305, 29537, 28462,
    3338, 3338, 16687, 17440, 28533, 8266, 12108, 8224, 28015, 30309, 29197, 2629, 21328, 16707, 20256, 8224,
    8224, 8292, 26995, 28769, 29281, 29197, 2640, 8224, 8224, 8224, 8224, 8224, 8304, 24949, 29537, 29197,
    2641, 8224, 8224, 8224, 8224, 8224, 8307, 24937, 29197, 2573, 2587, 23353, 13165, 20594, 25971, 29545,
    28526, 25888, 30061, 24864, 29797, 25452, 24864, 28769, 29281, 8297, 28265, 25449, 24946, 11822, 11803, 23344,
    27904, 21315, 20306, 17696, 0, 8224, 22337, 22085, 8192, 8224, 19529, 22085, 21280, 0, 16687, 17440,
    28015, 30309, 29216, 8261, 21328, 16707, 20256, 25705, 29552, 24946, 24946, 8224, 20512, 28769, 30067, 24946,
    8224, 20768, 29537, 26994, 0, 20545, 21843, 16708, 20256, 11552, 20512, 25455, 28276, 26990, 30049, 8239,
    8273, 8307, 24937, 0, 20594, 25968, 24946, 25901, 29541, 11822, 11776, 20302, 17473, 8261, 19529, 19785,
    20033, 17473, 8448, 20033, 22085, 8257, 21577, 20039, 18756, 16673, 0, 7003, 14641, 27975, 16717, 17696,
    20310, 17746, 7003, 12397, 3338, 3338, 16672, 26990, 30305, 29537, 28448, 25448, 25959, 28533, 8289, 28448,
    28780, 24942, 25972, 24878, 3338, 3338, 21024, 29285, 26990, 26979, 26977, 8316, 8273, 8307, 24937, 0,
    7003, 14642, 27990, 18772, 20306, 18753, 8475, 23344, 27917, 2573, 2625, 8294, 29295, 29793, 8259, 24946,
    26994, 26912, 28786, 28532, 25959, 25973, 8303, 8307, 26995, 29797, 28001, 11789, 2573, 2642, 8306, 25961,
    28265, 25449, 24864, 31776, 20768, 29537, 26880, 21093, 29807, 29294, 24942, 25711, 8289, 28448, 18261, 18764,
    18776, 11822, 11789, 2560
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


void boot_probe() {
    print_char(67);
    print_char(65);
    print_char(82);
    print_char(73);
    print_char(82);
    print_char(73);
    print_char(32);
    print_char(71);
    print_char(65);
    print_char(77);
    print_char(69);
    print_char(32);
    print_char(66);
    print_char(79);
    print_char(79);
    print_char(84);
    print_char(13);
    print_char(10);
}

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
    print_char(12);
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
    drain_input();
    last_key = read_char();

    while (last_key == 0) {
        yield();
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
    repeat_char(45, 77);
    cursor_pos(FIELD_BOTTOM, FIELD_LEFT);
    repeat_char(45, 77);

    cursor_pos(24, 2);
    set_color(T_WHITE);
    tx(T_CONTROLS);
}

void clear_status_line() {
    cursor_pos(25, 1);
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
                cursor_pos(base_y + (g_i + g_i), enemy_cols_x[g_j]);
                print_char(32);
            }
            g_j = g_j + 1;
        }
        g_i = g_i + 1;
    }
}

void draw_enemy_grid() {
    set_color(T_RED);
    g_i = 0;
    while (g_i < ENEMY_ROWS) {
        g_j = 0;
        while (g_j < ENEMY_COLS) {
            if (enemy_alive(g_i, g_j) != 0) {
                cursor_pos(enemy_y + (g_i + g_i), enemy_cols_x[g_j]);
                print_char(87);
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

                if (shot_x == g_a) {
                    if (shot_y == g_b) {
                        kill_enemy(g_i, g_j);
                        shot_active = 0;
                        score = score + 1;
                        explosion(g_a, g_b);
                        draw_hud();
                        return;
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
    draw_shot(enemy_shot_x, enemy_shot_y, 33, T_MAGENTA);
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

    draw_shot(enemy_shot_x, enemy_shot_y, 33, T_MAGENTA);
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
    /*
     * A sonda aparece antes do ANSI e antes da espera pelo teclado.
     * Se ela não aparecer, o overlay não chegou a executar main()/print_char.
     */
    cls();
    current_color = -1;
    boot_probe();
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
