#ifndef TABELA_SIMB
#define TABELA_SIMB

#define TAM_TOKEN 16

#define INT 0
#define BOOL 1
#define FULL_SEARCH 1
#define NIVEL_SEARCH 0

#define REFERENCIA 0
#define VALOR 1

#define VAR_SIMPLES 0
#define PARAM_FORM 1
#define PROCED 2
#define ROT 3


typedef struct simb_t {
    struct simb_t *prox;
    char id[TAM_TOKEN];
    int passagem_tipo;
    int categoria;
    int nivel;
    int deslocamento;
    int tipo;
    char rot[4];
} simb_t;

typedef struct tabela_simb_t {
    struct simb_t *head;
    int tam;
} tabela_simb_t;

int init_tabela(tabela_simb_t *t);

/* Inicializa simbolo com id 'id', categoria 'cat', nivel 'nivel' e deslocamento 'desl' *
 * Retorna um ponteiro para o simbolo inicializado                                      */
simb_t *cria_simb(char id[TAM_TOKEN], int cat, int nivel, int desl);

/* Insere o simbolo 's' na tabele 't' */
void insere_tabela(tabela_simb_t *t, simb_t *s);

/* Remove o topo da tabela 't' */
void remove_tabela(tabela_simb_t *t);

/* Busca na tabela um simbolo com id 'id' no nivel [0..'nivel'] se 'fullSearch' == 1 *
   e no nivel 'nivel' caso contrario                                                 *
   Retorna um ponteiro para o simbolo se achar, senao NULL*/
simb_t *busca_tabela(tabela_simb_t *t, char id[TAM_TOKEN], int nivel, int fullSearch);

/* Seta o tipo das 'count' ultimas variaveis para 'token' */
void tipo_tabela(tabela_simb_t *t, char tipo[TAM_TOKEN], int count);


void imprime_tabela(tabela_simb_t *t);

void ajustaDeslocamentoParams(tabela_simb_t *t, int count);

#endif