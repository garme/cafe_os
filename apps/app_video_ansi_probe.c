#include "../user/usr_io.c"
#include "../user/usr_yield.c"

/* Teste minimo do Device 0 usado por video(7).py e pelo terminal VGA. */

int g_i;
int g_v;
int last_key;

void csi() {
    print_char(27);
    print_char(91);
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

void pos(int row, int col) {
    csi(); print_small(row); print_char(59); print_small(col); print_char(72);
}

void sgr(int code) {
    csi();
    if (code >= 100) {
        print_char(49); print_char(48); print_char(48 + code - 100);
    } else {
        print_small(code);
    }
    print_char(109);
}

void put_text(int a, int b, int c, int d, int e, int f, int g, int h) {
    if (a) {
        print_char(a);
    }
    if (b) {
        print_char(b);
    }
    if (c) {
        print_char(c);
    }
    if (d) {
        print_char(d);
    }
    if (e) {
        print_char(e);
    }
    if (f) {
        print_char(f);
    }
    if (g) {
        print_char(g);
    }
    if (h) {
        print_char(h);
    }
}

void bar(int row, int col, int width, int bg) {
    sgr(bg); pos(row, col);
    g_i = 0;
    while (g_i < width) { print_char(32); g_i = g_i + 1; }
}

void main() {
    print_char(12);
    csi(); print_char(63); print_char(50); print_char(53); print_char(108);

    bar(3, 8, 64, 104);
    pos(3, 28); sgr(97);
    put_text(65,78,83,73,32,86,71,65);  /* ANSI VGA */
    put_text(32,80,82,79,66,69,0,0);    /* PROBE */

    bar(7, 12, 12, 106);
    bar(7, 26, 12, 105);
    bar(7, 40, 12, 103);
    bar(7, 54, 12, 102);

    pos(10, 12); sgr(96);
    put_text(67,89,65,78,32,32,0,0);
    sgr(95); put_text(77,65,71,69,78,84,65,0);
    sgr(93); put_text(32,89,69,76,76,79,87,0);
    sgr(92); put_text(32,71,82,69,69,78,0,0);

    pos(14, 16); sgr(97);
    put_text(80,82,69,83,83,32,65,78);
    put_text(89,32,75,69,89,32,84,79);
    put_text(32,69,88,73,84,0,0,0);

    last_key = read_char();
    while (last_key == 0) { yield(); last_key = read_char(); }

    csi(); print_char(48); print_char(109);
    csi(); print_char(63); print_char(50); print_char(53); print_char(104);
    print_char(12);
}
