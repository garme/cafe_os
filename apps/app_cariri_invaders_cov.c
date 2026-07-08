#include "../user/usr_io.c"
#include "../user/usr_yield.c"

/*
 * Cariri Invaders - COV Window Edition v1.5
 *
 * Ajustado para a janela dinâmica única:
 *   limite: 1024 palavras no .COV
 *
 * Esta versão preserva a mecânica essencial:
 *   - jogador lateral;
 *   - fileira de invasores por máscara de bits;
 *   - disparo do jogador;
 *   - pontuação;
 *   - execução cooperativa via yield().
 *
 * Controles:
 *   a = esquerda
 *   d = direita
 *   espaço = tiro
 *   q = sair do jogo e retornar ao shell
 */

int player_x;
int shot_on;
int shot_x;
int shot_y;
int enemies;
int enemy_x;
int enemy_dir;
int tick;
int score;
int lives;
int running;
int i;
int j;
int k;
int ch;

void nl(){ print_char(13); print_char(10); }
void cls(){ print_char(12); }

void putn(int n){
    int h;
    int t;
    h=0;
    while(n>=100){ n=n-100; h=h+1; }
    t=0;
    while(n>=10){ n=n-10; t=t+1; }
    if(h>0){ print_char(48+h); print_char(48+t); }
    else { if(t>0){ print_char(48+t); } }
    print_char(48+n);
}

void ps(char* s){
    i=0;
    ch=s[i];
    while(ch!=0){
        print_char(ch);
        i=i+1;
        ch=s[i];
    }
}

int bit(int b){
    k=1;
    while(b>0){
        k=k+k;
        b=b-1;
    }
    return k;
}

int alive(int c){
    if((enemies & bit(c)) != 0){
        return 1;
    }
    return 0;
}

void draw(){
    cls();
    ps("INV ");
    putn(score);
    ps(" L");
    putn(lives);
    nl();

    j=0;
    while(j<20){
        print_char(45);
        j=j+1;
    }
    nl();

    i=0;
    while(i<10){
        j=0;
        while(j<20){
            ch=32;

            if(i==1){
                if(j>=enemy_x){
                    if(j<enemy_x+8){
                        if(alive(j-enemy_x)==1){
                            ch=87;
                        }
                    }
                }
            }

            if(shot_on==1){
                if(i==shot_y){
                    if(j==shot_x){
                        ch=124;
                    }
                }
            }

            if(i==9){
                if(j==player_x){
                    ch=65;
                }
            }

            print_char(ch);
            j=j+1;
        }
        nl();
        i=i+1;
    }

    ps("a d sp q");
    nl();
}

void input(){
    ch=read_char();

    if(ch==97){
        if(player_x>0){
            player_x=player_x-1;
        }
    }

    if(ch==100){
        if(player_x<19){
            player_x=player_x+1;
        }
    }

    if(ch==32){
        if(shot_on==0){
            shot_on=1;
            shot_x=player_x;
            shot_y=8;
        }
    }

    if(ch==113){
        running=0;
    }
}

void step(){
    if(shot_on==1){
        if(shot_y==1){
            if(shot_x>=enemy_x){
                if(shot_x<enemy_x+8){
                    k=shot_x-enemy_x;
                    if(alive(k)==1){
                        enemies=enemies-bit(k);
                        score=score+1;
                        shot_on=0;
                    }
                }
            }
        }

        if(shot_on==1){
            shot_y=shot_y-1;
            if(shot_y<0){
                shot_on=0;
            }
        }
    }

    tick=tick+1;
    if(tick>5){
        tick=0;
        enemy_x=enemy_x+enemy_dir;
        if(enemy_x<=0){
            enemy_dir=1;
        }
        if(enemy_x>=12){
            enemy_dir=0-1;
        }
    }

    if(enemies==0){
        enemies=255;
        enemy_x=3;
        lives=lives+1;
    }
}

void main(){
    player_x=10;
    enemies=255;
    enemy_x=3;
    enemy_dir=1;
    lives=3;
    running=1;

    while(running==1){
        draw();
        input();
        step();
        yield();
    }
}
