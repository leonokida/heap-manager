.section .data
    strInicia: .string "Endereço inicial: %d\n"
    topoInicialHeap: .quad 0
    topoAtualHeap: .quad 0

.section .text

.globl iniciaAlocador, finalizaAlocador, alocaMem, liberaMem, imprimeMapa, main

iniciaAlocador:
    pushq %rbp
    movq %rsp, %rbp
    movq $12, %rax # código brk
    movq $0, %rdi # tamanho 0 no argumento
    syscall
    movq %rax, topoInicialHeap
    movq %rax, topoAtualHeap
    movq $strInicia, %rdi
    movq %rax, %rsi
    call printf
    popq %rbp
    ret

finalizaAlocador:
    pushq %rbp
    movq %rsp, %rbp
    movq topoInicialHeap, %rdi
    movq $12, %rax
    syscall
    popq %rbp
    ret

alocaMem:
    pushq %rbp
    movq %rsp, %rbp
    popq %rbp
    ret

liberaMem:
    pushq %rbp
    movq %rsp, %rbp
    popq %rbp
    ret

imprimeMapa:
    pushq %rbp
    movq %rsp, %rbp
    popq %rbp
    ret

main:
    call iniciaAlocador
    call finalizaAlocador
    movq $60, %rax
    movq %rbx, %rdi
    syscall
    