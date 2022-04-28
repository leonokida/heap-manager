#include "meuAlocador.h" 

int main() {
  void *a, *b;
  iniciaAlocador();
  imprimeMapa();
  a=alocaMem(240);
  imprimeMapa();
  b=alocaMem(50);
  imprimeMapa();
  liberaMem(a);
  imprimeMapa();
  a=alocaMem(50);
  imprimeMapa();

  finalizaAlocador();

}
