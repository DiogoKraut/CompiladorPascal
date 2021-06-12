
%{
#include <stdio.h>

%}

%token IDENT BOOL MAIS MENOS OR AND ASTERISCO DIV ABRE_PARENTESES FECHA_PARENTESES

%%

expr      :  add |
             or
;

add       :  add MAIS mul {printf ("+"); } |
             add MENOS mul {printf ("-"); } | 
             mul
;

mul       :  mul ASTERISCO fator {printf ("*"); } | 
             mul DIV fator  {printf ("/"); } |
             fator
;

fator     :  IDENT {printf ("A"); }
;

or        :  or OR and { printf ("or"); } | 
             and
;

and       :  and AND bool { printf ("and"); } |
             bool
;

bool      :  BOOL {printf ("B"); }
;

%%

main (int argc, char** argv) {
   yyparse();
   printf("\n");
}
