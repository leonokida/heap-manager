#include "meuAlocador.h" 
#include <stdio.h>

int main() {
  void *a, *b;
  iniciaAlocador();
  //imprimeMapa();
  a=alocaMem(240);
  a = "rossiya";
  printf("%s\n", (char *)a);
  //imprimeMapa();
  b=alocaMem(50);
  //imprimeMapa();
  //liberaMem(a);
  //imprimeMapa();
  //a=alocaMem(50);
  //imprimeMapa();

  finalizaAlocador();

}
