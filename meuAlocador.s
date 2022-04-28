.section .data
    strInicia: .string "Endereço inicial: %d\n"
    info: .string "################"
    livre: .string "-"
    ocupado: .string "+"
    brline: .string "\n"
    topoInicialHeap: .quad 0
    topoAtualHeap: .quad 0
    ultimoAlocado: .quad 0
    ultimoLiberado: .quad 0
    .equ OCUPADO, 0
    .equ LIVRE, 1

.section .text

.globl iniciaAlocador
.globl finalizaAlocador
.globl alocaMem
.globl liberaMem
.globl imprimeMapa
# .globl main

iniciaAlocador:
    pushq %rbp
    movq %rsp, %rbp
    movq $12, %rax # código brk
    movq $0, %rdi # tamanho 0 no argumento
    syscall
    movq %rax, topoInicialHeap
    movq %rax, topoAtualHeap
    movq $0, ultimoAlocado
    movq $0, ultimoLiberado
    # movq $strInicia, %rdi # primeiro argumento printf (string)
    # movq %rax, %rsi # segundo argumento printf (endereço a ser impresso)
    # call printf
    popq %rbp
    ret

finalizaAlocador:
    pushq %rbp
    movq %rsp, %rbp
    movq topoInicialHeap, %rdi # rdi <- rbk inicial
    movq %rdi, topoAtualHeap
    movq $12, %rax
    syscall
    popq %rbp
    ret

alocaMem:
    pushq %rbp
    movq %rsp, %rbp
    pushq %r12

    movq ultimoAlocado, %r10
    cmpq $0, %r10
    je aumentaHeap

    cmpq $LIVRE, (%r10)
    je armazena

    movq topoInicialHeap, %r10 # itera começando pelo início
    addq $8, %r10
    movq ultimoAlocado, %r11 # r11 guarda último alocado

    iteracao:
        cmpq %r10, %r11 # compara iterador com último alocado (já verificado)
        je aumentaHeap # se igual, aumenta heap
        
        movq 8(%r10), %r12
        cmpq $OCUPADO, (%r10) # verifica se bloco está ocupado
        je incrementaIterador

        cmpq %r12, %rdi # compara tamanhos de memória
        jle armazena # armazena no bloco se o tamanho é menor ou igual

    incrementaIterador:
        addq $16, %r10
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
        movq topoAtualHeap, %r11
        movq topoAtualHeap, %r10
        addq $8, %r10
        addq $16, %r11
        addq %rdi, %r11
        movq %r11, topoAtualHeap
        pushq %r13
        movq %rdi, %r13

        movq %r11, %rdi
        movq $12, %rax
        syscall

        movq %r10, ultimoAlocado
        movq $OCUPADO, (%r10) # indica que bloco está ocupado
        movq %r13, 8(%r10) # armazena tamanho do bloco
        movq %r10, %rax
        addq $16, %rax # %rax <- vetor[0]
        movq %r13, %rdi
        popq %r13

    popq %r12
    popq %rbp
    ret

merge: # começa pelo espaço de controle de disponibilidade dos blocos
    pushq %rbp
    movq %rsp, %rbp

    movq 8(%rsi), %r10 # segundo bloco
    movq 8(%rdi), %r11 # primeiro bloco
    addq %r10, %r11 # soma tamanhos
    addq $16, %r11 # soma 16
    movq %r11, 8(%rdi) # guarda no controle de tamanho do primeiro bloco

    cmpq ultimoAlocado, %rsi # se o segundo é o ultimoAlocado
    jne fimMerge
    movq %rdi, ultimoAlocado # coloca o primeiro em ultimoAlocado

    fimMerge:
        popq %rbp
        ret

liberaMem:
    pushq %rbp
    movq %rsp, %rbp

    cmpq $LIVRE, -16(%rdi) # testa double free
    je retornoLibera

    movq $LIVRE, -16(%rdi) # sinaliza como livre

    movq %rdi, %r10
    addq -8(%r10), %r10 # r10 <- próximo bloco
    cmpq %r10, topoAtualHeap # testa se o próximo bloco existe (não passa do topo)
    jge pula
    cmpq $LIVRE, (%r10) # se o próximo estiver ocupado, não faz nada
    jne pula
    pushq %rdi
    subq $16, %rdi
    movq %r10, %rsi
    call merge # chama merge com o primeiro bloco sendo o atual e o segundo sendo o próximo
    popq %rdi

    pula:
        movq ultimoLiberado, %r10
        cmpq $0, %r10 # testa se existe ultimoLiberado
        je fim
        cmpq $OCUPADO, (%r10) # testa se ultimoLiberado já está ocupado
        je fim
        addq 8(%r10), %r10
        addq $16, %r10 # r10 <- bloco seguinte ao ultimoLiberado
        movq %rdi, %r11
        subq $16, %r11
        cmpq %r11, %r10 # testa se o bloco atual é o próximo ao ultimoLiberado
        jne fim
        pushq %rdi
        movq %r11, %rsi
        movq ultimoLiberado, %rdi
        call merge # chama merge com o primeiro bloco sendo o ultimoLiberado e o segundo o atual
        popq %rdi
        jmp retornoLibera
    fim:
        subq $16, %rdi
        movq %rdi, ultimoLiberado # atualiza ultimoLiberado com o bloco atual
    retornoLibera:
        popq %rbp
        ret

imprimeMapa:
    pushq %rbp
    movq %rsp, %rbp

    movq topoInicialHeap, %rbx
    addq $8, %rbx

    pushq %r12
    pushq %r13

    laco:
        cmpq topoAtualHeap, %rbx
        jge retorno
        jl imprime

    imprime:
        movq $info, %rdi
        call printf

        jmp imprime_bloco
    
    imprime_bloco:
        movq $1, %r13
        movq 8(%rbx), %r12      # indica tamanho do bloco
        cmpq $OCUPADO, (%rbx)   # verifica se o bloco esta ocupado
        je bloco_ocupado
        jmp bloco_disponivel
    
    bloco_ocupado:
        cmpq %r12, %r13
        jg proximo_bloco

        movq $ocupado, %rdi
        call printf

        addq $1, %r13

        jmp bloco_ocupado

    bloco_disponivel:
        cmpq %r12, %r13
        jg proximo_bloco
        
        movq $livre, %rdi
        call printf

        addq $1, %r13

        jmp bloco_disponivel

    proximo_bloco:
        addq $16, %rbx     # tamanho do espaço de informacoes
        addq %r12, %rbx   # tamanho do bloco

        jmp laco
    
    retorno:
        movq $brline, %rdi
        call printf
        popq %r13
        popq %r12
        popq %rbp
        ret

# main:
#     pushq %rbp
#     movq %rsp, %rbp
#     call iniciaAlocador
#     subq $8, %rsp
#     movq $100, %rdi
#     pushq %rdi
#     call alocaMem
#     popq %rdi
#     movq %rax, %rbx
#     movq $20, %rdi
#     pushq %rdi
#     call alocaMem
#     popq %rdi
#     movq %rbx, %rdi
#     call liberaMem
#     addq $8, %rsp
#     call imprimeMapa
#     movq $60, %rax
#     syscall
    