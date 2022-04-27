#include "meuAlocador.h" 
#include <stdio.h>

int main() {
  void *a, *b;
  iniciaAlocador();
  imprimeMapa();
  a=alocaMem(20);
  imprimeMapa();
  liberaMem(a);
  imprimeMapa();
  b=alocaMem(10);
  imprimeMapa();
  a=alocaMem(50);
  imprimeMapa();
  liberaMem(b);
  imprimeMapa();
  a=alocaMem(21);
  imprimeMapa();

  finalizaAlocador();

}