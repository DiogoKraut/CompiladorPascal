/* -------------------------------------------------------------------
 *            Arquivo: compilaodr.h
 * -------------------------------------------------------------------
 *              Autor: Bruno Muller Junior
 *               Data: 08/2007
 *      Atualizado em: [15/03/2012, 08h:22m]
 *
 * -------------------------------------------------------------------
 *
 * Tipos, protótipos e vaiáveis globais do compilador
 *
 * ------------------------------------------------------------------- */
#ifndef __COMP__
#define __COMP__

#include "tabela_simb.h"
#include "pilha.h"

#define MAX_NIVEL 10


typedef enum simbolos { 
  simb_program, simb_var, simb_begin, simb_end, 
  simb_identificador, simb_numero,
  simb_ponto, simb_virgula, simb_ponto_e_virgula, simb_dois_pontos,
  simb_atribuicao, simb_abre_parenteses, simb_fecha_parenteses,
  simb_label, simb_type, simb_array, simb_of, simb_procedure, simb_function,
  simb_if, simb_else, simb_then, simb_while, simb_do, simb_or, simb_div,
  simb_not, simb_mais, 
  simb_menos, simb_multiplicacao, simb_divisao, simb_igual, simb_desigual,
  simb_menor, simb_menor_igual, simb_maior, simb_maior_igual, simb_and,
  simb_read, simb_write, simb_integer, simb_boolean,
} simbolos;

// void geraCodigo (char* rot, char* comando);
/* -------------------------------------------------------------------
 * vari�veis globais
 * ------------------------------------------------------------------- */

extern simbolos simbolo, relacao;
extern char token[TAM_TOKEN];
extern int nivel_lexico;
extern int desloc;
extern int nl;


extern simbolos simbolo, relacao;
extern char token[TAM_TOKEN];

/* -------------------------------------------------------------------
 * prototipos globais
 * ------------------------------------------------------------------- */

void geraCodigo (char*, char*);
int yylex();
void yyerror(const char *s);



#endif
