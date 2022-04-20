.section .data
str2 : .string " topo %d ini %d \n"
str3 : .string "################"
str4 : .string "-"
str5 : .string "+"
str6 : .string "\n"
str7 : .string "%s"
str8 : .string "%d \n"
INICIO_HEAP: .quad 0
TOPO_HEAP: .quad 0
.equ TAM_INFO, 8
.equ DISP_INFO, 0
.equ TAM_ALOCADO, 8

.equ DISPONIVEL, 0
.equ OCUPADO, 1

.section .text
.globl main
.globl iniciaAlocador
.globl alocaMem
.globl liberaMem
.globl imprimeMapa

iniciaAlocador:
     pushq %rbp
     movq %rsp, %rbp
     movq $12, %rax
     movq $0, %rdi
     syscall
     movq %rax, TOPO_HEAP
     movq %rax, INICIO_HEAP
     movq $0, %rax
     movq $str6, %rdi
     call printf
     popq %rbp
     ret


alocaMem:
     pushq %rbp                                               
     movq %rsp, %rbp
     movq %rdi, %rax
     movq INICIO_HEAP, %rbx
     movq TOPO_HEAP, %r10

     loop_alocacao:
          cmpq %r10, %rbx
          je solicita_mem

          movq TAM_ALOCADO(%rbx), %rdx
          cmpq $OCUPADO, DISP_INFO(%rbx)
          je proximo

          cmpq %rdx, %rax
          jle aloca

     proximo:
          addq $TAM_INFO, %rbx
          addq %rdx, %rbx

          jmp loop_alocacao

     aloca:
          movq $OCUPADO, DISP_INFO(%rbx)
          addq $TAM_INFO, %rbx

          popq %rbp
          ret


     solicita_mem:
          addq $TAM_INFO, %r10
          addq %rax, %r10

          pushq %rbx
          pushq %rax

          movq $12, %rax
          movq %r10, %rdi
          syscall

          popq %rax
          popq %rbx

          movq $OCUPADO, DISP_INFO(%rbx)
          movq %rax, TAM_ALOCADO(%rbx)

          addq $TAM_INFO, %rbx

          movq %r10, TOPO_HEAP

          popq %rbp
          ret


liberaMem:
     pushq %rbp                                               
     movq %rsp, %rbp
     movq %rdi, %rax
     subq TAM_INFO, %rax
     movq $DISPONIVEL, DISP_INFO(%rax)

     popq %rbp
     ret

imprimeMapa:
     pushq %rbp                                               
     movq %rsp, %rbp
     movq INICIO_HEAP, %rbx
     movq TOPO_HEAP, %r10

     loop_memoria:
          cmpq %r10, %rbx
          jge fim
          jl imprime_info

     imprime_info:
          movq $0, %rax
          movq $str4, %rdi
          call printf

          jmp verifica_bloco
     
     verifica_bloco:
          movq $1, %r13
          movq TAM_ALOCADO(%rbx), %r12
          cmpq $OCUPADO, DISP_INFO(%rbx)
          je imprime_bloco_ocupado
          jmp imprime_bloco_disponivel

     imprime_bloco_ocupado:
          cmpq %r12, %r13
          jg proximo_bloco

          movq $0, %rax
          movq $str4, %rdi
          call printf

          addq $1, %r13

          jmp imprime_bloco_ocupado

     imprime_bloco_disponivel:
          cmpq %r12, %r13
          jg proximo_bloco
          
          movq $0, %rax
          movq $str4, %rdi
          call printf
          addq $1, %r13
          jmp imprime_bloco_disponivel

     proximo_bloco:
          addq $TAM_INFO, %rbx
          addq %r12, %rbx

          jmp loop_memoria

     fim:
          popq %rbp
          ret


main:
     pushq %rbp
     movq %rsp, %rbp
     call iniciaAlocador
     subq $8, %rsp
     movq $100, %rdi
     pushq %rdi
     call alocaMem
     popq %rdi
     addq $8, %rsp
     call imprimeMapa
     movq $60, %rax
     syscall
