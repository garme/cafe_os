#include "../user/usr_io.c"
#include "../user/usr_yield.c"

/*
 * CARIRI NEON CYCLES COMPACT v4.2
 * Feito para caber no overlay de 4K words da CPU Cariri.
 *
 * Video: Device 0 ANSI 80x30
 * Teclado: Device 1 / read_char()
 * Controles: W A S D, Q sai
 *
 * Estrategia de memoria:
 * - mapa direto 38x22 = 836 words no segmento de dados
 * - menos logica para reduzir o segmento de instrucoes
 */

#define W 38
#define H 22
#define CELLS 836

#define UP 0
#define RIGHT 1
#define DOWN 2
#define LEFT 3

#define BLACK 40
#define RED 41
#define YELLOW 43
#define BLUE 44
#define MAGENTA 45
#define CYAN 46
#define WHITE 47

#define BRED 101
#define BYELLOW 103
#define BBLUE 104
#define BMAGENTA 105
#define BCYAN 106
#define BWHITE 107

#define FCYAN 96
#define FWHITE 97
#define FYELLOW 93
#define FRED 91
#define FGREEN 92
#define FMAGENTA 95

#define TXT_TITLE 0
#define TXT_HELP 10
#define TXT_SCORE 20
#define TXT_LEVEL 24
#define TXT_LIVES 28
#define TXT_READY 32
#define TXT_CRASH 36
#define TXT_CLEAR 40
#define TXT_OVER 48
#define TXT_BYE 54

int text_data[57] = {
    17217, 21065, 21065, 8270, 17743, 20000, 17241, 17228, 17747, 0, 22337, 21316,
    8269, 20310, 17696, 8273, 8273, 21833, 21504, 0, 21315, 20306, 17696, 0,
    19525, 22085, 19488, 0, 19529, 22085, 21280, 0, 21061, 16708, 22817, 0,
    17234, 16723, 18465, 0, 21317, 17236, 20306, 8259, 19525, 16722, 17732, 0,
    18241, 19781, 8271, 22085, 20992, 0, 16985, 17664, 0
};

int map[CELLS];

int px;
int py;
int pd;
int ax;
int ay;
int ad;

int score;
int level;
int lives;
int frame;
int key;
int run;

int nx;
int ny;
int pnx;
int pny;
int anx;
int any;
int crashp;
int crasha;

int i;
int v;
int q;
int t;

void tx(int p) {
    q = text_data[p];
    while (q != 0) {
        v = q >> 8;
        if (v != 0) {
            print_char(v);
        }
        v = q & 255;
        if (v == 0) {
            return;
        }
        print_char(v);
        p = p + 1;
        q = text_data[p];
    }
}

void out2(int n) {
    v = 0;
    while (n >= 10) {
        n = n - 10;
        v = v + 1;
    }
    print_char(48 + v);
    print_char(48 + n);
}

void out3(int n) {
    if (n > 999) {
        n = 999;
    }

    i = 0;
    while (n >= 100) {
        n = n - 100;
        i = i + 1;
    }
    print_char(48 + i);

    v = 0;
    while (n >= 10) {
        n = n - 10;
        v = v + 1;
    }
    print_char(48 + v);
    print_char(48 + n);
}

void pos(int r, int c) {
    print_char(27);
    print_char(91);
    out2(r);
    print_char(59);
    out2(c);
    print_char(72);
}

void sgr(int n) {
    print_char(27);
    print_char(91);

    /* Os fundos ANSI brilhantes usados pelo jogo sao 100..107.
     * out2() so representa dois digitos; portanto tratamos 100..109
     * explicitamente para nunca produzir sequencias como ESC[:6m.
     */
    if (n >= 100) {
        print_char(49);
        print_char(48);
        print_char(48 + n - 100);
    } else {
        out2(n);
    }

    print_char(109);
}

void wait_ticks(int n) {
    t = 0;
    while (t < n) {
        yield();
        t = t + 1;
    }
}

void clear_line(int r) {
    pos(r, 1);
    print_char(27);
    print_char(91);
    print_char(50);
    print_char(75);
}

void hud() {
    pos(1, 2);
    sgr(FWHITE);
    tx(TXT_SCORE);
    sgr(FYELLOW);
    out3(score);
    sgr(FWHITE);
    print_char(32);
    tx(TXT_LEVEL);
    sgr(FCYAN);
    print_char(48 + level);
    sgr(FWHITE);
    print_char(32);
    tx(TXT_LIVES);
    sgr(FGREEN);
    print_char(48 + lives);
    print_char(32);
    print_char(32);
}

void cell(int x, int y, int color) {
    pos(4 + y, 3 + x + x);
    sgr(color);
    print_char(32);
    print_char(32);
    sgr(BLACK);
}

int blocked(int x, int y) {
    if (x < 0) {
        return 1;
    }
    if (x >= W) {
        return 1;
    }
    if (y < 0) {
        return 1;
    }
    if (y >= H) {
        return 1;
    }
    if (map[y * W + x] != 0) {
        return 1;
    }
    return 0;
}

void step_from(int x, int y, int d) {
    nx = x;
    ny = y;
    if (d == UP) {
        ny = y - 1;
    }
    if (d == RIGHT) {
        nx = x + 1;
    }
    if (d == DOWN) {
        ny = y + 1;
    }
    if (d == LEFT) {
        nx = x - 1;
    }
}

void arena() {
    /* Limpeza ANSI explicita: funciona tanto no Video.py quanto no CLI. */
    print_char(27);
    print_char(91);
    print_char(50);
    print_char(74);
    print_char(27);
    print_char(91);
    print_char(72);

    /* Oculta o cursor durante o jogo. */
    print_char(27);
    print_char(91);
    print_char(63);
    print_char(50);
    print_char(53);
    print_char(108);

    pos(1, 31);
    sgr(FCYAN);
    tx(TXT_TITLE);
    hud();

    sgr(BBLUE);
    pos(3, 2);
    i = 0;
    while (i < 78) {
        print_char(32);
        i = i + 1;
    }
    pos(26, 2);
    i = 0;
    while (i < 78) {
        print_char(32);
        i = i + 1;
    }

    i = 4;
    while (i < 26) {
        pos(i, 2);
        print_char(32);
        pos(i, 79);
        print_char(32);
        i = i + 1;
    }
    sgr(BLACK);

    pos(28, 3);
    sgr(FWHITE);
    tx(TXT_HELP);
}

void reset_round() {
    i = 0;
    while (i < CELLS) {
        map[i] = 0;
        i = i + 1;
    }

    px = 7;
    py = 11;
    pd = RIGHT;

    ax = 30;
    ay = 11;
    ad = LEFT;

    map[py * W + px] = 1;
    map[ay * W + ax] = 1;

    /* Descarta apenas teclas antigas da rodada anterior. Teclas digitadas
     * durante READY ficam na fila e valem para o primeiro movimento. */
    key = read_char();
    while (key != 0) {
        key = read_char();
    }

    arena();
    cell(px, py, BCYAN);
    cell(ax, ay, BMAGENTA);

    clear_line(29);
    pos(29, 31);
    sgr(FYELLOW);
    tx(TXT_READY);
    wait_ticks(6);
    clear_line(29);

    /* Semente por rodada sem memoria extra: i ja existe como scratch global.
     * frame persiste entre rodadas, portanto o percurso seguinte nao reinicia
     * sempre no mesmo estado. */
    i = frame + score;
    i = i + lives;
}

void input() {
    key = read_char();
    if (key == 0) {
        return;
    }

    /* A entrada do jogador tambem perturba o estado leve da IA. */
    i = i + key;

    if (key >= 65) {
        if (key <= 90) {
            key = key + 32;
        }
    }

    if (key == 119) {
        if (pd != DOWN) {
            pd = UP;
        }
    }
    if (key == 100) {
        if (pd != LEFT) {
            pd = RIGHT;
        }
    }
    if (key == 115) {
        if (pd != UP) {
            pd = DOWN;
        }
    }
    if (key == 97) {
        if (pd != RIGHT) {
            pd = LEFT;
        }
    }
    if (key == 113) {
        run = 0;
    }
}

/* IA compacta menos deterministica.
 * i funciona tambem como um pequeno estado dinamico entre frames. Ele e
 * perturbado pelo frame, pelas posicoes e pelas teclas do jogador. Isso evita
 * o roteiro fixo sem aumentar o mapa, adicionar PRNG ou exigir nova syscall.
 */
void ai() {
    /* Atualiza o estado leve em TODOS os frames, nao apenas quando vira. */
    i = i + frame;
    i = i + px;
    i = i + ay;
    i = i + 3;
    i = i & 7;

    step_from(ax, ay, ad);
    anx = nx;
    any = ny;

    /* Frente bloqueada: escolhe dinamicamente qual lateral testar primeiro. */
    if (blocked(anx, any) != 0) {
        if ((i & 1) == 0) {
            v = ad - 1;
            if (v < 0) {
                v = LEFT;
            }
        } else {
            v = ad + 1;
            if (v > LEFT) {
                v = UP;
            }
        }

        step_from(ax, ay, v);
        anx = nx;
        any = ny;
        if (blocked(anx, any) == 0) {
            ad = v;
            return;
        }

        /* O outro lado fica a duas direcoes do primeiro (modulo 4). */
        v = v + 2;
        if (v > LEFT) {
            v = v - 4;
        }
        step_from(ax, ay, v);
        anx = nx;
        any = ny;
        if (blocked(anx, any) == 0) {
            ad = v;
        }
        return;
    }

    /* A cada oito frames: 0 tenta esquerda, 1 tenta direita e os demais
     * mantem a direcao. Como i carrega historia, a sequencia nao fica presa
     * ao mesmo lado a cada rodada. */
    if ((frame & 7) == 0) {
        if ((i & 3) < 2) {
            if ((i & 1) == 0) {
                v = ad - 1;
                if (v < 0) {
                    v = LEFT;
                }
            } else {
                v = ad + 1;
                if (v > LEFT) {
                    v = UP;
                }
            }

            step_from(ax, ay, v);
            if (blocked(nx, ny) == 0) {
                ad = v;
                anx = nx;
                any = ny;
            }
        }
    }
}

void boom(int x, int y) {
    cell(x, y, BWHITE);
    wait_ticks(1);
    cell(x, y, BRED);
    wait_ticks(1);
    cell(x, y, BYELLOW);
}

void play_round() {
    reset_round();
    crashp = 0;
    crasha = 0;

    while (crashp == 0) {
        input();
        if (run == 0) {
            return;
        }

        step_from(px, py, pd);
        crashp = blocked(nx, ny);
        pnx = nx;
        pny = ny;

        ai();

        crasha = blocked(anx, any);

        /* Colisao frontal: os dois tentam ocupar a mesma celula. */
        if (pnx == anx) {
            if (pny == any) {
                crashp = 1;
                crasha = 1;
            }
        }

        /* Colisao por troca de posicao entre as duas cabecas. */
        if (pnx == ax) {
            if (pny == ay) {
                if (anx == px) {
                    if (any == py) {
                        crashp = 1;
                        crasha = 1;
                    }
                }
            }
        }

        /* Em colisao simultanea, a queda do jogador tem prioridade: nao
         * transformamos uma batida mutua em setor vencido. */
        if (crashp != 0) {
            break;
        }

        cell(px, py, CYAN);
        px = pnx;
        py = pny;
        map[py * W + px] = 1;
        cell(px, py, BCYAN);

        if (crasha == 0) {
            cell(ax, ay, MAGENTA);
            ax = anx;
            ay = any;
            map[ay * W + ax] = 1;
            cell(ax, ay, BMAGENTA);
        }

        if (crasha != 0) {
            boom(ax, ay);
            score = score + level;
            level = level + 1;
            if (level > 9) {
                level = 9;
            }
            hud();
            clear_line(29);
            pos(29, 29);
            sgr(FGREEN);
            tx(TXT_CLEAR);
            wait_ticks(8);
            return;
        }

        frame = frame + 1;
        v = 7 - (level >> 1);
        if (v < 2) {
            v = 2;
        }
        wait_ticks(v);
    }

    boom(px, py);
    lives = lives - 1;
    hud();
    clear_line(29);
    pos(29, 31);
    sgr(FRED);
    tx(TXT_CRASH);
    wait_ticks(8);
}

void game_over() {
    clear_line(29);
    pos(29, 30);
    sgr(FRED);
    tx(TXT_OVER);
    wait_ticks(12);
}

void main() {
    run = 1;
    score = 0;
    level = 1;
    lives = 3;
    frame = 1;

    while (run != 0) {
        play_round();

        if (lives <= 0) {
            game_over();
            score = 0;
            level = 1;
            lives = 3;
        }
    }

    print_char(27);
    print_char(91);
    print_char(50);
    print_char(74);
    print_char(27);
    print_char(91);
    print_char(72);
    pos(14, 37);
    sgr(FCYAN);
    tx(TXT_BYE);
    sgr(0);
    print_char(27);
    print_char(91);
    print_char(63);
    print_char(50);
    print_char(53);
    print_char(104);
}
