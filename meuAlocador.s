.section .data
    strInicia: .string "Endereço inicial: %d\n"
    strBlocosAlocados: .string "%d\n"
    topoInicialHeap: .quad 0
    topoAtualHeap: .quad 0
    .equ OCUPADO, 0
    .equ LIVRE, 1

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
    movq $strInicia, %rdi # primeiro argumento printf (string)
    movq %rax, %rsi # segundo argumento printf (endereço a ser impresso)
    call printf
    popq %rbp
    ret

finalizaAlocador:
    pushq %rbp
    movq %rsp, %rbp
    movq topoInicialHeap, %rdi # rdi <- rbk inicial
    subq topoAtualHeap, %rdi # rdi <- rbk inicial - rbk final
    movq $12, %rax
    syscall
    popq %rbp
    ret

alocaMem:
    pushq %rbp
    movq %rsp, %rbp

    movq topoInicialHeap, %r10 # itera começando pelo início
    movq topoAtualHeap, %r11 # r11 guarda final da heap
    pushq %r12

    iteracao:
        cmpq %r10, %r11 # compara iterador com topo
        je aumentaHeap # se igual, aumenta heap
        
        cmpq $OCUPADO, (%r10) # verifica se bloco está ocupado
        je incrementaIterador

        movq 8(%r10), %r12 # r12 <- tamanho alocado no bloco
        cmpq %rdi, %r12 # compara tamanhos de memória
        jle armazena # armazena no bloco se o tamanho é menor ou igual

    incrementaIterador:
        addq $8, %r10
        addq %r12, %r10
        jmp iteracao

    armazena:
        movq $OCUPADO, (%r10) # indica que bloco agora está ocupado
        addq $16, %r10 # r10 <- vetor[0]
        movq %r10, %rax
        popq %r12
        popq %rbp
        ret

    aumentaHeap:
        addq $8, %r11
        addq %rdi, %r11
        pushq %r13
        movq %rdi, %r13

        addq $16, %rdi
        movq $12, %rax
        syscall

        movq %r11, topoAtualHeap # atualiza topo
        movq $OCUPADO, (%r10) # indica que bloco está ocupado
        movq %r13, 8(%r10) # armazena tamanho do bloco
        movq %r10, %rax
        addq $16, %rax # %rax <- vetor[0]
        movq %r13, %rdi
        popq %r13

    popq %r12
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
    pushq %rbp
    movq %rsp, %rbp
    call iniciaAlocador
    subq $8, %rsp
    movq $16, %rdi
    pushq %rdi
    call alocaMem
    popq %rdi
    # call imprimeMapa
    call finalizaAlocador
    movq $60, %rax
    syscall
    