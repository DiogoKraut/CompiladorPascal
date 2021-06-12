#ifndef ___PILHA___
#define ___PILHA___
#define P_TAM 128

typedef struct pilha_t {
	void *elem[P_TAM];
	int head;
} pilha_t;

int init_pilha(pilha_t *p);


int empilha(pilha_t *p, void *elem);


int empilha_tipo(pilha_t *p, int elem);


void *desempilha(pilha_t *p);

#endif