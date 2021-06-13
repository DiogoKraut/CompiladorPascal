$DEPURA=1

compilador: lex.yy.c y.tab.c compilador.o compilador.h pilha.o pilha.h tabelaSimbolo.o tabela_simb.h
	gcc -g lex.yy.c compilador.tab.c pilha.o tabelaSimbolo.o compilador.o -o compilador -ll -ly -lc

lex.yy.c: compilador.l compilador.h
	flex compilador.l

tabelaSimbolo.o: tabela_simb.h tabela_simb.c
	gcc -g -c tabela_simb.c -o tabelaSimbolo.o

pilha.o: pilha.h pilha.c
	gcc -g -c pilha.c -o pilha.o

y.tab.c: compilador.y compilador.h
	bison compilador.y -d -v

compilador.o : compilador.h compiladorF.c
	gcc -g -c compiladorF.c -o compilador.o

clean : 
	rm -f compilador.tab.* lex.yy.c *.o

purge:
	rm -f compilador.tab.* lex.yy.c *.o
	rm -f compilador
	rm -f MEPA*