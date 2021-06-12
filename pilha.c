#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "pilha.h"
#include "tabela_simb.h"

int init_pilha(pilha_t *p) {
	if(!p) return -1;

    p->head = 0;
    return 0;
}

int empilha(pilha_t *p, void *elem) {
	if(!p || !elem) return -1;

	p->elem[p->head] = elem;
	p->head++;
	return 0;
}

int empilha_tipo(pilha_t *p, int elem) {
	if(!p || (elem != INT && elem != BOOL)) return -1;

	int *aux = malloc(sizeof(int));
	*aux = elem;
	p->elem[p->head] = aux;
	p->head++;
	return 0;
}

void *desempilha(pilha_t *p) {
	if(!p || p->head <= 0) return NULL;
	p->head--;
	return p->elem[p->head];
}

