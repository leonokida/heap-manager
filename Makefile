all: meuAlocador.o

meuAlocador.o: meuAlocador.s
	gcc -c -g meuAlocador.s -o meuAlocador.o

clean:
	rm *.o