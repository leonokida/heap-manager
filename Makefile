all: avalia meuAlocador.o

avalia: meuAlocador.o
	gcc -g avalia.c meuAlocador.o -o avalia -no-pie

meuAlocador.o: meuAlocador.s
	gcc -c -g meuAlocador.s -o meuAlocador.o

clean:
	rm *.o
