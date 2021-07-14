#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>

#include "tabela_simb.h"



int init_tabela(tabela_simb_t *t) {
    
    if(!t) return -1;

    t->head = NULL;
    t->tam = 0;
    return 0;
}

simb_t *cria_simb(char id[TAM_TOKEN], int cat, int nivel, int desl) {
    simb_t *s = malloc(sizeof(simb_t));
    if(!s) {
        perror("CRIA_SIMB: ");
        exit(1);
    }
    s->prox = NULL;
    strncpy(s->id, id, TAM_TOKEN);
    s->nivel = nivel;
    s->deslocamento = desl;
    s->tipo = -1;
    s->categoria = cat;

    return s;
}

void insere_tabela(tabela_simb_t *t, simb_t *s) {
    s->prox = t->head;
    t->head = s;
    t->tam++;
}

void remove_tabela(tabela_simb_t *t) {
    if(t->tam > 0) {
        t->head = t->head->prox;
        t->tam--;
    }
}

simb_t *busca_tabela(tabela_simb_t *t, char id[TAM_TOKEN], int nivel, int flag) {

    simb_t *aux = t->head;

    while(aux != NULL) {
        if(strncmp(aux->id, id, TAM_TOKEN) == 0)
            if(flag) {
                if(aux->nivel <= nivel)
                    return aux;
            } else {
                if(aux->nivel == nivel) {
                    return aux;
                }
            }
            
        aux = aux->prox;
    }

    return aux;
}

void tipo_tabela(tabela_simb_t *t, char tipo[TAM_TOKEN], int count) {
    simb_t *aux = t->head;
    if(strncmp(tipo, "integer", TAM_TOKEN) != 0)
        return;

    for(int i = 0; i < count; i++) {
        aux->tipo = INT;
        aux = aux->prox;
    }
}

void imprime_tabela(tabela_simb_t *t) {
    simb_t *aux = t->head;
    printf("\n#### Tabela de Simbolos ####\n");
    printf("id | cat | nivel | desl | tipo \n");
    while(aux != NULL) {
        printf("%2s | % 3d | % 5d | % 4d |", aux->id, aux->categoria, aux->nivel, aux->deslocamento);
        switch (aux->tipo) {
            case INT:
                printf(" integer\n");
                break;
            case BOOL:
                printf(" boolean\n");
                break;
            default:
                printf(" error\n");
        }
        aux = aux->prox;
    }
}