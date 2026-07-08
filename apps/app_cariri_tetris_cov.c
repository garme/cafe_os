#include "../user/usr_io.c"
#include "../user/usr_yield.c"

/*
 * Cariri Tetris - COV Window Edition v1.5
 *
 * Ajustado para a janela dinâmica única:
 *   limite: 1024 palavras no .COV
 *
 * Versão mínima para caber na janela:
 *   - tabuleiro 10x12;
 *   - peça 2x2;
 *   - colisão;
 *   - fixação;
 *   - limpeza de linhas completas;
 *   - execução cooperativa via yield().
 *
 * Controles:
 *   a = esquerda
 *   d = direita
 *   s = queda rápida
 *   q = sair do jogo e retornar ao shell
 */

int board[12];
int px;
int py;
int running;
int tick;
int i;
int j;
int k;
int ch;

void nl(){ print_char(13); print_char(10); }
void cls(){ print_char(12); }

int bit(int b){
    k=1;
    while(b>0){
        k=k+k;
        b=b-1;
    }
    return k;
}

int filled(int x,int y){
    if((board[y] & bit(x)) != 0){
        return 1;
    }
    return 0;
}

int hit(int x,int y){
    if(x<0){return 1;}
    if(x>8){return 1;}
    if(y>10){return 1;}

    if(y>=0){
        if(filled(x,y)==1){return 1;}
        if(filled(x+1,y)==1){return 1;}
    }

    if(y+1>=0){
        if(filled(x,y+1)==1){return 1;}
        if(filled(x+1,y+1)==1){return 1;}
    }

    return 0;
}

void draw(){
    cls();

    i=0;
    while(i<12){
        print_char(124);

        j=0;
        while(j<10){
            ch=32;

            if(filled(j,i)==1){
                ch=35;
            }

            if(i>=py){
                if(i<py+2){
                    if(j>=px){
                        if(j<px+2){
                            ch=79;
                        }
                    }
                }
            }

            print_char(ch);
            j=j+1;
        }

        print_char(124);
        nl();
        i=i+1;
    }
}

void new_piece(){
    px=4;
    py=0;

    if(hit(px,py)==1){
        running=0;
    }
}

void put_piece(){
    board[py]=board[py] | bit(px) | bit(px+1);
    board[py+1]=board[py+1] | bit(px) | bit(px+1);
}

void clear_rows(){
    i=11;
    while(i>=0){
        if(board[i]==1023){
            j=i;
            while(j>0){
                board[j]=board[j-1];
                j=j-1;
            }
            board[0]=0;
        } else {
            i=i-1;
        }
    }
}

void input(){
    ch=read_char();

    if(ch==97){
        if(hit(px-1,py)==0){
            px=px-1;
        }
    }

    if(ch==100){
        if(hit(px+1,py)==0){
            px=px+1;
        }
    }

    if(ch==115){
        tick=5;
    }

    if(ch==113){
        running=0;
    }
}

void step(){
    tick=tick+1;

    if(tick>4){
        tick=0;

        if(hit(px,py+1)==0){
            py=py+1;
        } else {
            put_piece();
            clear_rows();
            new_piece();
        }
    }
}

void main(){
    i=0;
    while(i<12){
        board[i]=0;
        i=i+1;
    }

    running=1;
    new_piece();

    while(running==1){
        draw();
        input();
        step();
        yield();
    }
}
