#include "meuAlocador.h" 
#include <stdio.h>

int main() {
  void *a, *b;
  iniciaAlocador();
  imprimeMapa();
  a=alocaMem(20);
  imprimeMapa();
  b = alocaMem(20);
  imprimeMapa();
  liberaMem(a);
  imprimeMapa();
  liberaMem(b);
  imprimeMapa();
  a = alocaMem(20);
  imprimeMapa();
  b = alocaMem(40);
  imprimeMapa();
  liberaMem(a);
  imprimeMapa();
  liberaMem(b);
  imprimeMapa();
  a = alocaMem(2);
  imprimeMapa();
  liberaMem(a);
  imprimeMapa();
  finalizaAlocador();

}
