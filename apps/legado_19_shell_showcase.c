#include "../user/usr_io.c"
#include "../user/usr_yield.c"

/*
 * CAFE Shell v0.4.3 - full optimized showcase.
 *
 * Refatoracao orientada ao compilador Cariri:
 * - textos armazenados com 2 caracteres por palavra de 16 bits;
 * - um unico decodificador para todas as telas;
 * - comandos identificados por hash do token, sem strings de comparacao;
 * - efeitos compartilham rotinas e variaveis globais;
 * - main retorna para o epilogo overlay em vez de incluir usr_exit.c.
 */

#define LINE_MAX 47
#define T_RESET 0
#define T_GREEN 3
#define T_YELLOW 6
#define T_BLUEWHITE 9
#define T_HIDE 14
#define T_SHOW 18
#define T_HOME 22
#define T_BANNER 24
#define T_PROMPT 49
#define T_HELP 58
#define T_VER 380
#define T_ABOUT 398
#define T_UNAME 428
#define T_MEM 446
#define T_PS 467
#define T_LOGO 504
#define T_ARCH 558
#define T_STATUS 615
#define T_VIDEO_HEAD 685
#define T_COLOR 698
#define T_MATRIX_END 704
#define T_SHOW_NEXT 728
#define T_SL 748
#define T_CAFE 775
#define T_CARIRI 794
#define T_SUDO 811
#define T_FORTUNE 832
#define T_CHROME_TITLE 855
#define T_CHROME_END 875
#define T_PS_TITLE 894
#define T_PS_END 921
#define T_COREL_TITLE 942
#define T_COREL_BALLOON 967
#define T_COREL_END 980
#define T_WIN_TITLE 993
#define T_WIN_99 1037
#define T_WIN_BLUE 1055
#define T_WIN_END 1150
#define T_UNKNOWN 1192
#define T_BYE 1198
#define T_DEMO_END 1202
#define H_HELP 1579
#define H_VER 795
#define H_ABOUT 3161
#define H_UNAME 3490
#define H_MEM 754
#define H_PS 342
#define H_ECHO 1538
#define H_CLEAR 3191
#define H_EXIT 1629
#define H_LOGO 1640
#define H_ARCH 1549
#define H_STATUS 7188
#define H_VIDEO 3472
#define H_MATRIX 6817
#define H_SHOWCASE 28598
#define H_CAFE 1500
#define H_CARIRI 6448
#define H_SUDO 1714
#define H_SL 341
#define H_FORTUNE 13748
#define H_CHROME 6570
#define H_PHOTOSHOP 56757
#define H_CORELDRAW 53888
#define H_COREL 3269
#define H_WINDOWS 14460

int text_data[1218] = {
    7003, 12397, 0, 7003, 14642, 27904, 7003, 14643, 27904, 7003, 13364, 15161, 14189, 0, 7003, 16178,
    13676, 0, 7003, 16178, 13672, 0, 7003, 18432, 7003, 14646, 27971, 16710, 17696, 21352, 25964, 27680,
    12334, 13358, 13083, 23344, 27936, 11552, 26725, 27760, 8300, 26995, 29793, 8291, 28525, 24942, 25711, 29453,
    2560, 7003, 14642, 28007, 30057, 27753, 30747, 23344, 27940, 8192, 7003, 14646, 27970, 16723, 18755, 20307,
    7003, 12397, 3338, 8296, 25964, 28704, 8224, 8224, 8224, 8289, 27253, 25697, 8293, 8291, 28525, 24942,
    25711, 29453, 2592, 30309, 29216, 8224, 8224, 8224, 8224, 30309, 29299, 24943, 8292, 28448, 29544, 25964,
    27661, 2592, 24930, 28533, 29728, 8224, 8224, 8224, 29551, 25202, 25888, 17217, 17989, 8271, 21295, 18261,
    18764, 18776, 3338, 8309, 28257, 28005, 8224, 8224, 8224, 8304, 27745, 29793, 26223, 29293, 24864, 24948,
    30049, 27661, 2592, 28005, 27936, 8224, 8224, 8224, 8224, 28773, 29286, 26988, 8292, 25888, 28005, 28015,
    29289, 24845, 2592, 28787, 8224, 8224, 8224, 8224, 8224, 29793, 29285, 26209, 29472, 25711, 8304, 25970,
    26217, 27661, 2592, 25955, 26735, 8276, 17752, 21583, 8224, 26989, 28786, 26989, 25888, 21573, 22612, 20237,
    2592, 25452, 25953, 29216, 8224, 8224, 8224, 27753, 28016, 24864, 24864, 29797, 27745, 3338, 8293, 30825,
    29728, 8224, 8224, 8224, 8293, 28259, 25970, 29281, 8303, 8307, 26725, 27756, 3338, 7003, 14643, 27990,
    18771, 21825, 18771, 7003, 12397, 3338, 8300, 28519, 28448, 8224, 8224, 8224, 8300, 28519, 28532, 26992,
    28448, 16723, 17225, 18701, 2592, 24946, 25448, 8224, 8224, 8224, 8224, 24946, 29045, 26996, 25972, 30066,
    24864, 25711, 8307, 26995, 29797, 28001, 3338, 8307, 29793, 29813, 29472, 8224, 8224, 8304, 24937, 28261,
    27680, 25697, 8304, 27745, 29793, 26223, 29293, 24845, 2592, 30313, 25701, 28448, 8224, 8224, 8224, 29797,
    29556, 25888, 16718, 21321, 12118, 18241, 3338, 8301, 24948, 29289, 30752, 8224, 8224, 8269, 24948, 29289,
    30752, 25965, 8308, 25964, 24864, 25448, 25961, 24845, 2592, 28001, 29810, 27000, 8300, 26998, 25888, 24942,
    26989, 24931, 24943, 8289, 29797, 8309, 28001, 8308, 25955, 27745, 3338, 8307, 26735, 30563, 24947, 25888,
    8224, 8292, 25965, 28526, 29556, 29281, 25441, 28448, 26485, 26977, 25697, 3338, 7003, 14642, 27973, 16723,
    21573, 21024, 17735, 18259, 7003, 12397, 3338, 8291, 24934, 25888, 25441, 29289, 29289, 8307, 30052, 28448,
    29548, 8294, 28530, 29813, 28261, 3338, 8291, 26738, 28525, 25888, 28776, 28532, 28531, 26735, 28704, 25455,
    29285, 27680, 25455, 29285, 27748, 29281, 30496, 30569, 28260, 28535, 29453, 2560, 17217, 17989, 8275, 26725,
    27756, 8310, 12334, 13358, 13088, 26229, 27756, 8303, 28788, 26989, 27002, 25956, 3338, 0, 17217, 17989,
    8271, 21295, 18261, 18764, 18776, 14880, 17184, 11582, 8303, 30309, 29292, 24953, 8237, 15904, 27493, 29294,
    25964, 8237, 15904, 17249, 29289, 29289, 8237, 15904, 17747, 20531, 12813, 2560, 25441, 29289, 29289, 12598,
    8291, 24934, 25901, 28531, 8295, 30057, 27753, 30752, 25971, 28723, 12845, 30311, 24845, 2560, 17235, 8244,
    19232, 31776, 17491, 12115, 21280, 13387, 8316, 8296, 25953, 28704, 13617, 12832, 31776, 29793, 29285, 26209,
    29472, 13069, 2560, 20553, 17440, 21577, 20559, 8261, 21332, 16708, 20237, 2608, 8303, 30309, 29292, 24953,
    8274, 21838, 20041, 20039, 3338, 12576, 28786, 28515, 8303, 28771, 26991, 28257, 27661, 2610, 8308, 26738,
    25953, 25632, 28528, 25449, 28526, 24940, 3338, 0, 7003, 14646, 27936, 17219, 17219, 8224, 16705, 16672,
    8262, 17990, 17990, 8261, 17733, 17733, 3338, 8259, 8224, 8224, 8257, 8257, 8224, 17952, 8224, 8224,
    17677, 2592, 17219, 17219, 8224, 16705, 16672, 8262, 17990, 8224, 8261, 17733, 17733, 3338, 7003, 14642,
    27936, 8224, 8259, 16710, 17696, 20307, 8239, 8263, 21833, 19529, 22555, 23344, 27917, 2560, 7003, 14643,
    27969, 21073, 21833, 21573, 21589, 21057, 7003, 12397, 3338, 20563, 12082, 8237, 15904, 21573, 21069, 18766,
    16716, 8261, 21328, 13106, 8237, 15904, 21825, 21076, 8237, 15904, 17741, 21836, 16708, 20306, 8261, 21328,
    13106, 3338, 20310, 17746, 19521, 22816, 11582, 8263, 21833, 19529, 22560, 11582, 8259, 20565, 8259, 16722,
    18770, 18720, 11582, 8278, 18241, 3338, 0, 7003, 14643, 27984, 19521, 21569, 17999, 21069, 16667, 23344,
    27917, 2627, 20565, 8283, 8995, 8995, 8995, 8995, 8995, 8995, 8995, 8995, 23840, 17217, 21065, 21065,
    8241, 13837, 2627, 21280, 8283, 8995, 8995, 8995, 8995, 8995, 8995, 8995, 8995, 23840, 13387, 3338,
    17491, 8224, 23331, 8995, 8995, 8995, 8995, 8995, 8995, 8995, 9053, 8244, 19213, 2646, 18241, 8283,
    8995, 8995, 8995, 8995, 8995, 8995, 8995, 8995, 23840, 18017, 25159, 19469, 2560, 7003, 14647, 27988,
    17747, 21573, 8257, 20051, 18735, 22087, 16667, 23344, 27917, 2560, 8259, 20306, 8257, 20051, 18720, 0,
    7003, 12852, 15153, 18459, 23353, 12397, 19777, 21586, 18776, 14880, 28786, 25971, 29545, 28526, 25888, 30061,
    24864, 29797, 25452, 24878, 11822, 7003, 14642, 27904, 20594, 25971, 29545, 28526, 25888, 30061, 24864, 29797,
    25452, 24864, 28769, 29281, 8291, 28526, 29801, 28277, 24946, 11822, 11789, 2560, 8224, 15677, 15677, 8224,
    8224, 24415, 24415, 3338, 24388, 24444, 8316, 24415, 24367, 17217, 17989, 23647, 24333, 2592, 20269, 20269,
    20256, 8264, 16707, 19273, 20039, 3338, 0, 17249, 26213, 8307, 25970, 30313, 25711, 15136, 25971, 25441,
    27759, 28257, 25711, 29216, 24931, 28530, 25697, 25711, 11789, 2560, 17249, 29289, 29289, 8303, 28268, 26990,
    25888, 25965, 8301, 28516, 28448, 30067, 30049, 29289, 28462, 3338, 0, 29557, 25711, 8302, 25959, 24932,
    28474, 8291, 28525, 28777, 27749, 8303, 8304, 29295, 28786, 26991, 8299, 25970, 28261, 27694, 3338, 0,
    26223, 29300, 30062, 25914, 8290, 30055, 8292, 25888, 27493, 29294, 25964, 8305, 30053, 29216, 30313, 29281,
    29216, 26213, 24948, 30066, 25902, 3338, 0, 7003, 14646, 27971, 18514, 20301, 17696, 17217, 21065, 21065,
    7003, 12397, 3338, 16738, 29289, 28260, 28448, 13367, 8289, 25185, 29440, 3338, 21057, 19744, 25448, 25961,
    24891, 8294, 25955, 26721, 29216, 24930, 24864, 24930, 29289, 29984, 25717, 24947, 11789, 2560, 7003, 13364,
    15161, 14189, 8272, 29472, 7003, 12397, 8272, 26735, 29807, 29544, 28528, 8259, 24946, 26994, 26893, 2625,
    28780, 26979, 24942, 25711, 8294, 26988, 29810, 28531, 0, 3338, 26217, 28257, 27743, 26217, 28257, 27743,
    14126, 28787, 25659, 8259, 27759, 30052, 8293, 30819, 25956, 25973, 8244, 19246, 3338, 0, 7003, 14645,
    27971, 20306, 17740, 17490, 16727, 8259, 16722, 18770, 18715, 23344, 27917, 2627, 28526, 30309, 29300, 25966,
    25711, 8293, 27936, 25461, 29302, 24947, 0, 8238, 11565, 11566, 3338, 10272, 17231, 21061, 27680, 10509,
    2592, 8316, 31757, 2560, 3338, 16754, 26977, 27680, 30313, 29295, 29984, 14384, 12336, 8302, 28531, 11789,
    2560, 7003, 14646, 27947, 11565, 11563, 8235, 11565, 11563, 3338, 31776, 8224, 31776, 31776, 8224, 31757,
    2603, 11565, 11563, 8235, 11565, 11563, 7003, 12397, 3338, 22345, 20036, 20311, 21280, 17217, 21065, 21065,
    3338, 16756, 30049, 27753, 31329, 25441, 28448, 28514, 29289, 26465, 29807, 29289, 24832, 14649, 9530, 8294,
    24940, 29793, 27936, 13344, 28009, 28204, 8243, 8296, 8303, 29984, 12832, 25705, 24947, 11789, 2560, 3338,
    8224, 8250, 10253, 2573, 2592, 8224, 20256, 22377, 28260, 28535, 29472, 25966, 25455, 28276, 29295, 29984,
    30061, 8304, 29295, 25196, 25965, 24864, 25888, 28786, 25955, 26995, 24864, 29285, 26990, 26979, 26977, 29230,
    3338, 8224, 8259, 28524, 25972, 24942, 25711, 8292, 24932, 28531, 8292, 28448, 25970, 29295, 14880, 12592,
    12325, 3338, 3338, 8224, 8275, 21583, 20538, 8259, 16710, 17759, 20307, 24404, 20303, 24390, 16723, 21599,
    17999, 21087, 22345, 20036, 20311, 21261, 2573, 2592, 8224, 21359, 27765, 25441, 28474, 8292, 25971, 27753,
    26485, 25888, 25888, 27753, 26485, 25888, 28271, 30305, 28005, 28276, 25902, 3338, 3338, 0, 7003, 14642,
    27971, 16710, 17696, 20307, 8306, 25955, 30064, 25970, 28533, 8307, 25965, 8306, 25961, 28265, 25449, 24946,
    11803, 23344, 27917, 2638, 25966, 26741, 27936, 30064, 25697, 29797, 8292, 25888, 13856, 18242, 8294, 28521,
    8302, 25955, 25971, 29537, 29289, 28462, 3338, 0, 16160, 25455, 28001, 28260, 28474, 8192, 25209, 25902,
    3338, 0, 7003, 14642, 27987, 26735, 30563, 24947, 25888, 25455, 28259, 27765, 26980, 28462, 7003, 12397,
    3338, 0
};

int line[48];
int line_len;
int shell_c;
int running;

/* scratch global compartilhado: o shell executa em uma unica tarefa */
int g_i;
int g_j;
int g_k;
int g_w;
int g_a;
int g_b;
int g_hash;
int g_arg;
int g_seed;
int g_frame;
int g_key;
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

void nl() {
    print_char(13);
    print_char(10);
}

void cls() {
    print_char(12);
    tx(T_HOME);
}

void pause_ticks(int ticks) {
    g_pause = 0;
    while (g_pause < ticks) {
        yield();
        g_pause = g_pause + 1;
    }
}

void drain_input() {
    g_key = read_char();
    while (g_key != 0) {
        g_key = read_char();
    }
}

void wait_key() {
    tx(T_YELLOW);
    tx(T_SHOW_NEXT);
    tx(T_RESET);

    drain_input();
    g_key = read_char();

    while (g_key == 0) {
        yield();
        g_key = read_char();
    }
}

void print_from(int pos) {
    shell_c = line[pos];

    while (shell_c != 0) {
        print_char(shell_c);
        pos = pos + 1;
        shell_c = line[pos];
    }
}

void finish_screen() {
    wait_key();
    tx(T_RESET);
    tx(T_SHOW);
    cls();
}

void effect_page(int title, int ending) {
    tx(title);
    nl();
    loading_field();
    tx(ending);
    finish_screen();
}

void show_video() {
    cls();
    tx(T_HIDE);
    tx(T_VIDEO_HEAD);

    g_i = 0;
    while (g_i < 8) {
        print_char(27);
        print_char(91);
        print_char(51);
        print_char(48 + g_i);
        print_char(109);
        tx(T_COLOR);

        g_j = 0;
        while (g_j < 20) {
            print_char(35);
            g_j = g_j + 1;
        }

        tx(T_RESET);
        nl();
        g_i = g_i + 1;
    }

    finish_screen();
}

void show_matrix(int live) {
    cls();
    tx(T_HIDE);
    tx(T_GREEN);
    drain_input();

    g_seed = 7;
    g_frame = 0;
    g_key = 0;

    while (g_key == 0) {
        tx(T_HOME);
        g_i = 0;

        while (g_i < 24) {
            g_j = 0;

            while (g_j < 79) {
                g_seed = g_seed + 73 + g_frame;

                while (g_seed > 250) {
                    g_seed = g_seed - 251;
                }

                if (g_seed < 57) {
                    print_char(32);
                } else {
                    if (g_seed < 126) {
                        g_k = g_seed & 1;
                        print_char(48 + g_k);
                    } else {
                        if (g_seed < 205) {
                            g_k = g_seed & 15;
                            print_char(65 + g_k);
                        } else {
                            if (g_seed < 231) {
                                print_char(124);
                            } else {
                                print_char(46);
                            }
                        }
                    }
                }

                g_j = g_j + 1;
            }

            if (g_i < 23) {
                nl();
            }

            yield();
            g_i = g_i + 1;
        }

        tx(T_MATRIX_END);

        if (live == 0) {
            drain_input();
            g_key = read_char();

            while (g_key == 0) {
                yield();
                g_key = read_char();
            }
        } else {
            pause_ticks(3);
            g_key = read_char();
            g_frame = g_frame + 1;
        }
    }

    tx(T_RESET);
    tx(T_SHOW);
    cls();
}

void loading_field() {
    g_i = 0;

    while (g_i < 10) {
        g_j = 0;
        g_k = 0;

        while (g_j < 56) {
            print_char(46);
            g_k = g_k + 1;

            if (g_k == 8) {
                pause_ticks(1);
                g_k = 0;
            }

            g_j = g_j + 1;
        }

        nl();
        g_i = g_i + 1;
    }
}

void windows_blue_screen() {
    tx(T_BLUEWHITE);
    print_char(12);
    tx(T_HOME);

    g_i = 0;
    while (g_i < 24) {
        g_j = 0;

        while (g_j < 79) {
            print_char(32);
            g_j = g_j + 1;
        }

        if (g_i < 23) {
            nl();
        }

        g_i = g_i + 1;
    }

    tx(T_HOME);
    tx(T_WIN_BLUE);
    finish_screen();
}

void show_effect(int mode) {
    cls();
    tx(T_HIDE);
    drain_input();

    if (mode == 1) {
        effect_page(T_CHROME_TITLE, T_CHROME_END);
        return;
    }

    if (mode == 2) {
        effect_page(T_PS_TITLE, T_PS_END);
        return;
    }

    if (mode == 3) {
        g_i = 0;

        while (g_i < 31) {
            cls();
            g_j = 0;

            while (g_j < g_i) {
                print_char(32);
                g_j = g_j + 1;
            }

            tx(T_COREL_BALLOON);
            pause_ticks(3);
            g_i = g_i + 5;
        }

        cls();
        effect_page(T_COREL_TITLE, T_COREL_END);
        return;
    }

    tx(T_WIN_TITLE);
    nl();
    loading_field();
    tx(T_WIN_99);
    pause_ticks(20);
    windows_blue_screen();
    tx(T_WIN_END);
}

void show_showcase() {
    cls();
    tx(T_LOGO);
    wait_key();

    cls();
    tx(T_ARCH);
    wait_key();

    cls();
    tx(T_STATUS);
    wait_key();

    show_video();
    show_matrix(1);
    cls();
    tx(T_DEMO_END);
}

void command() {
    g_hash = 0;
    g_i = 0;
    shell_c = line[0];

    while (shell_c != 0) {
        if (shell_c == 32) {
            g_arg = g_i + 1;
            shell_c = 0;
        } else {
            g_hash = g_hash + g_hash;
            g_hash = g_hash + shell_c;
            g_hash = g_hash + 1;
            g_i = g_i + 1;
            shell_c = line[g_i];
            g_arg = g_i;
        }
    }

    switch (g_hash) {
        case H_HELP:
            tx(T_HELP);
            break;
        case H_VER:
            tx(T_VER);
            break;
        case H_ABOUT:
            tx(T_ABOUT);
            break;
        case H_UNAME:
            tx(T_UNAME);
            break;
        case H_MEM:
            tx(T_MEM);
            break;
        case H_PS:
            tx(T_PS);
            break;
        case H_ECHO:
            print_from(g_arg);
            nl();
            break;
        case H_CLEAR:
            cls();
            break;
        case H_EXIT:
            tx(T_BYE);
            running = 0;
            break;
        case H_LOGO:
            tx(T_LOGO);
            break;
        case H_ARCH:
            tx(T_ARCH);
            break;
        case H_STATUS:
            tx(T_STATUS);
            break;
        case H_VIDEO:
            show_video();
            break;
        case H_MATRIX:
            if (line[g_arg] == 108) {
                show_matrix(1);
            } else {
                show_matrix(0);
            }
            break;
        case H_SHOWCASE:
            show_showcase();
            break;
        case H_CAFE:
            tx(T_CAFE);
            break;
        case H_CARIRI:
            tx(T_CARIRI);
            break;
        case H_SUDO:
            tx(T_SUDO);
            break;
        case H_SL:
            tx(T_SL);
            break;
        case H_FORTUNE:
            tx(T_FORTUNE);
            break;
        case H_CHROME:
            show_effect(1);
            break;
        case H_PHOTOSHOP:
            show_effect(2);
            break;
        case H_CORELDRAW:
            show_effect(3);
            break;
        case H_COREL:
            show_effect(3);
            break;
        case H_WINDOWS:
            show_effect(4);
            break;
        default:
            tx(T_UNKNOWN);
            print_from(0);
            nl();
            break;
    }
}

void backspace() {
    if (line_len > 0) {
        line_len = line_len - 1;
        line[line_len] = 0;
        print_char(8);
        print_char(32);
        print_char(8);
    }
}

void accept_char(int value) {
    if (line_len < LINE_MAX) {
        line[line_len] = value;
        line_len = line_len + 1;
        line[line_len] = 0;
        print_char(value);
    }
}

void execute_line() {
    nl();
    line[line_len] = 0;

    if (line_len > 0) {
        command();
    }

    line_len = 0;
    line[0] = 0;

    if (running != 0) {
        tx(T_PROMPT);
    }
}

void main() {
    line_len = 0;
    line[0] = 0;
    running = 1;

    tx(T_RESET);
    tx(T_SHOW);
    tx(T_BANNER);
    tx(T_PROMPT);

    while (running != 0) {
        shell_c = read_char();

        if (shell_c == 0) {
            yield();
        } else {
            if (shell_c == 13) {
                execute_line();
            } else {
                if (shell_c == 10) {
                    execute_line();
                } else {
                    if (shell_c == 8) {
                        backspace();
                    } else {
                        if (shell_c == 127) {
                            backspace();
                        } else {
                            accept_char(shell_c);
                        }
                    }
                }
            }
        }
    }

    tx(T_RESET);
    tx(T_SHOW);
}
