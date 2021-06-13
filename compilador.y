
// Testar se funciona corretamente o empilhamento de parâmetros
// passados por valor ou por referência.


%{
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "compilador.h"

void yyerror (char const *);

#define IMPRIME(STR) printf("%s    # %s \n", STR, token);

tabela_simb_t *tab_simb;
pilha_t *pilha_tipos;
pilha_t *pilha_rotulos;

int num_vars;
int deslocamento[MAX_NIVEL];
int nivel;
int var_count;

char l_elem[TAM_TOKEN];
char *rotulo;
int rot_count;

int checaTipos(int tipo);
char *empilha_rotulo(pilha_t *p);

%}

%union {
  char INT_T[TAM_TOKEN];
  int BOOL_T;
}

%token PROGRAM ABRE_PARENTESES FECHA_PARENTESES 
%token VIRGULA PONTO_E_VIRGULA DOIS_PONTOS PONTO
%token T_BEGIN T_END VAR IDENT ATRIBUICAO
%token LABEL TYPE ARRAY OF PROCEDURE FUNCTION IF
%token ELSE THEN WHILE DO OR DIV NOT MAIS
%token MENOS MULTIPLICACAO DIVISAO IGUAL DESIGUAL
%token MENOR MENOR_IGUAL MAIOR MAIOR_IGUAL AND
%token READ WRITE
%token NUMERO BOOLEAN INTEGER
%%

programa    :{ 
               geraCodigo (NULL, "INPP");
               
             }
             PROGRAM IDENT 
             ABRE_PARENTESES lista_idents FECHA_PARENTESES PONTO_E_VIRGULA
             bloco PONTO 
             {
               geraCodigo (NULL, "PARA");
               imprime_tabela(tab_simb);
             }
;

bloco       : 
              parte_declara_vars
              comando_composto
;


parte_declara_vars  : { var_count = 0;} VAR declara_vars
                    | 
;

declara_vars  : declara_vars declara_var 
              | declara_var 
;

declara_var : lista_id_var DOIS_PONTOS tipo 
              { /* AMEM */
                char aux[10];
                sprintf(aux, "AMEM %d", var_count);
                geraCodigo(NULL, aux);

                tipo_tabela(tab_simb, token, var_count);
                var_count = 0;
              }
              PONTO_E_VIRGULA
;

tipo        : INTEGER
;

lista_id_var  : lista_id_var VIRGULA IDENT 
              {
                if(busca_tabela(tab_simb, token, nivel, NIVEL_SEARCH) != NULL) {
                    IMPRIME("______Simbolo ja existe");
                    exit(1);
                }
                simb_t *simb = cria_simb(token, 0, nivel, deslocamento[nivel]);
                insere_tabela(tab_simb, simb);

                var_count++;
                deslocamento[nivel]++;                
              }
              | IDENT 
              { 
                if(busca_tabela(tab_simb, token, nivel, NIVEL_SEARCH) != NULL) {
                    IMPRIME("______Simbolo ja existe");
                    exit(1);
                }
                simb_t *simb = cria_simb(token, 0, nivel, deslocamento[nivel]);
                insere_tabela(tab_simb, simb);

                var_count++;
                deslocamento[nivel]++;     
              }
;

lista_idents  : lista_idents VIRGULA IDENT  
              | IDENT
;


comando_composto : T_BEGIN comandos T_END 

comandos  : comandos PONTO_E_VIRGULA comando
          | comando
;

comando : atribuicao
        | write
        | read
        | while
;

write : WRITE ABRE_PARENTESES vars_write FECHA_PARENTESES
;

vars_write  : vars_write VIRGULA var_write
            | var_write
;

var_write : IDENT
            {
              simb_t *simb = busca_tabela(tab_simb, token, nivel, FULL_SEARCH);
              if(simb == NULL){
                  fprintf(stderr, "Simbolo nao existe\n");
                  exit(1);
              }

              char aux[10];
              sprintf(aux, "CRVL %d,%d", simb->nivel, simb->deslocamento);
              geraCodigo(NULL, aux);

              geraCodigo(NULL, "IMPR");
            }
          | NUMERO
            {
              char aux[TAM_TOKEN+10];
              sprintf(aux, "CRCT %s", token);
              geraCodigo(NULL, aux); 
            }
;
read :  READ ABRE_PARENTESES vars_read FECHA_PARENTESES
;

vars_read : vars_read VIRGULA var_read
          | var_read
;

var_read  : IDENT 
            {
              simb_t *simb = busca_tabela(tab_simb, token, nivel, FULL_SEARCH);
              if(simb == NULL){
                  fprintf(stderr, "Simbolo nao existe\n");
                  exit(1);
              }

              geraCodigo(NULL, "LEIT");
              char aux[10];
              sprintf(aux, "ARMZ %d,%d", simb->nivel, simb->deslocamento);
              geraCodigo(NULL, aux);
            }
;

atribuicao :  IDENT 
              {
                strncpy(l_elem, token, TAM_TOKEN);
              }
              ATRIBUICAO comparacao
              { 
                simb_t *simb = busca_tabela(tab_simb, l_elem, nivel, FULL_SEARCH);
                empilha_tipo(pilha_tipos, simb->tipo);
                if(checaTipos(INT)) {
                    char aux[10];
                    sprintf(aux, "ARMZ %d,%d", simb->nivel, simb->deslocamento);
                    geraCodigo(NULL, aux);
                    empilha_tipo(pilha_tipos, INT);
                } else {
                    printf("Syntax Error : Type mismatch\n");
                    return 1;
                }
              }
;
/*
constante : NUMERO
            {
              char aux[TAM_TOKEN+10];
              sprintf(aux, "CRCT %s", token);
              geraCodigo(NULL, aux); 
            }
          | comparacao
;*/

/* Comparacao >>> +\-\or >>> *\/\and */
comparacao  : comparacao IGUAL expr
            {
              if(checaTipos(INT)) {
                  geraCodigo(NULL, "CMIG");
                  empilha_tipo(pilha_tipos, BOOL);
              } else {
                  printf("Syntax Error : Type mismatch\n");
                  return 1;
              }
            }
            | comparacao MENOR expr
            {
              if(checaTipos(INT)) {
                  geraCodigo(NULL, "CMME");
                  empilha_tipo(pilha_tipos, BOOL);
              } else {
                  printf("Syntax Error : Type mismatch\n");
                  return 1;
              }
            }
            | comparacao MAIOR expr
            {
              if(checaTipos(INT)) {
                  geraCodigo(NULL, "CMMA");
                  empilha_tipo(pilha_tipos, BOOL);
              } else {
                  printf("Syntax Error : Type mismatch\n");
                  return 1;
              }
            }
            | comparacao MENOR_IGUAL expr
            {
              if(checaTipos(INT)) {
                  geraCodigo(NULL, "CMEG");
                  empilha_tipo(pilha_tipos, BOOL);
              } else {
                  printf("Syntax Error : Type mismatch\n");
                  return 1;
              }
            }
            | comparacao MAIOR_IGUAL expr
            {
              if(checaTipos(INT)) {
                  geraCodigo(NULL, "CMMAG");
                  empilha_tipo(pilha_tipos, BOOL);
              } else {
                  printf("Syntax Error : Type mismatch\n");
                  return 1;
              }
            }
            | expr
;

expr : expr MAIS mult
      {
        if(checaTipos(INT)) {
            geraCodigo(NULL, "SOMA");
            empilha_tipo(pilha_tipos, INT);
        } else {
            printf("Syntax Error : Type mismatch\n");
            return 1;
        }
      }

      | expr MENOS mult
      {
        if(checaTipos(INT)) {
            geraCodigo(NULL, "SUBT");
            empilha_tipo(pilha_tipos, INT);
        } else {
            printf("Syntax Error : Type mismatch\n");
            return 1;
        }
      }

      | expr OR mult
      {
        if(checaTipos(BOOL)) {
            geraCodigo(NULL, "DISJ");
            empilha_tipo(pilha_tipos, BOOL);
        } else {
            printf("Syntax Error : Type mismatch\n");
            return 1;
        }
      }

      | mult
;

mult :  mult MULTIPLICACAO operando
        {
          if(checaTipos(INT)) {
              geraCodigo(NULL, "MULT");
              empilha_tipo(pilha_tipos, INT);
          } else {
              printf("Syntax Error : Type mismatch\n");
              return 1;
          }
        }

      | mult DIV operando
        {
          if(checaTipos(INT)) {
              geraCodigo(NULL, "DIVI");
              empilha_tipo(pilha_tipos, INT);

          } else {
              printf("Syntax Error : Type mismatch\n");
              return 1;
          }
        }

      | mult AND operando
        {
          if(checaTipos(BOOL)) {
              geraCodigo(NULL, "CONJ");
              empilha_tipo(pilha_tipos, BOOL);
          } else {
              printf("Syntax Error : Type mismatch\n");
              return 1;
          }
        }

      | operando
;
operando :  ABRE_PARENTESES comparacao FECHA_PARENTESES
          | ident
          | NUMERO
            {
              empilha_tipo(pilha_tipos, INT);
              char aux[TAM_TOKEN+10];
              sprintf(aux, "CRCT %s", token);
              geraCodigo(NULL, aux); 
            }
          
;
ident : IDENT
        {
          simb_t *simb = busca_tabela(tab_simb, token, nivel, FULL_SEARCH);
          empilha_tipo(pilha_tipos, simb->tipo);

          char aux[TAM_TOKEN+10];
          sprintf(aux, "CRVL %d,%d", simb->nivel, simb->deslocamento);
          geraCodigo(NULL, aux);

        }
;

while : {
          geraCodigo(empilha_rotulo(pilha_rotulos), "NADA");
          empilha_rotulo(pilha_rotulos);

        }
        WHILE comparacao
        /*{
          char aux[TAM_TOKEN*2];
          sprintf(aux, "DSVF %s", (char *)peek(pilha_rotulos));
          geraCodigo(NULL, aux);
        }*/
        DO
        {
          char aux[TAM_TOKEN*2];
          sprintf(aux, "DSVF %s", (char *)peek(pilha_rotulos));
          geraCodigo(NULL, aux);
        }
        comando_composto
        {
          char nada[5];
          strncpy(nada, (char *)desempilha(pilha_rotulos), 5);

          char rot[5];
          strncpy(rot, (char *)desempilha(pilha_rotulos), 5);

          char aux[TAM_TOKEN];
          snprintf(aux, TAM_TOKEN, "DSVS %s", rot);
          geraCodigo(NULL, aux);
          geraCodigo(nada, "NADA");
        }
;


%%
void yyerror (char const *message)
{
    fputs (message, stderr);
    fputc ('\n', stderr);
}

char *empilha_rotulo(pilha_t *p) {
    char *rot = malloc(4);
    snprintf(rot, 4, "R%02d", p->head);
    empilha(p, rot);
    return rot;
}

int checaTipos(int tipo) {
    int *a, *b;

    a = (int *) desempilha(pilha_tipos);
    b = (int *) desempilha(pilha_tipos);

    if(*a == *b == tipo) {
        free(a);
        free(b);
        return 0;
    }

    free(a);
    free(b);
    return 1;
}

int main (int argc, char** argv) {
    FILE* fp;
    extern FILE* yyin;

    if (argc<2 || argc>2) {
        printf("usage compilador  <arq>a %d\n", argc);
        return(-1);
    }

    fp=fopen (argv[1], "r");
    if (fp == NULL) {
        printf("usage compilador <arq>b\n");
        return(-1);
    }


/* -------------------------------------------------------------------
 *  Inicia a Tabela de Símbolos
 * ------------------------------------------------------------------- */
    num_vars  = 0;
    nivel     = 0;
    var_count = 0;
    rot_count = 0;

    tab_simb = malloc(sizeof(tabela_simb_t));
    if(init_tabela(tab_simb)) {
        perror("CRIA_TAB: ");
        exit(1);
    }

    pilha_tipos = malloc(sizeof(pilha_t));
    if(init_pilha(pilha_tipos)) {
        perror("CRIA_PILHA: ");
        exit(1);
    }

    pilha_rotulos = malloc(sizeof(pilha_t));
    if(init_pilha(pilha_rotulos)) {
        perror("CRIA_PILHA: ");
        exit(1);
    }

    for(int i = 0; i < MAX_NIVEL; i++) deslocamento[i] = 0;
    

    yyin=fp;
    yyparse();

    return 0;
}

