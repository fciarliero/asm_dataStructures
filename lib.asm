
section .rodata

section .text

extern malloc
extern free
extern fprintf

global strLen
global strClone
global strCmp
global strConcat
global strDelete
global strPrint
global listNew
global listAddFirst
global listAddLast
global listAdd
global listRemove
global listRemoveFirst
global listRemoveLast
global listDelete
global listPrint
global n3treeNew
global n3treeAdd
global n3treeRemoveEq
global n3treeDelete
global nTableNew
global nTableAdd
global nTableRemoveSlot
global nTableDeleteSlot
global nTableDelete

%define NULL 0

;uint32_t strLen(char* a)
strLen:                     ;rdi → a
    push rbp
    push rdi
    push r12
    mov rbp, rsp
    sub rsp, 8
    xor eax, eax            ;eax ← 0
    .ciclo:
        mov r12b, [rdi]     ;r12b ← [a] el char al que apunta el puntero a
        cmp r12b, NULL      ;si este char es el char null, termine de recorrer el string
        je .fin
        inc eax             ;si no es null el char actual, incremento el contador y posiciono el puntero en el proximo char
        inc rdi
        jmp .ciclo
    .fin:
    add rsp, 8
    pop r12
    pop rdi
    pop rbp
    ret

;char* strClone(char* a)
strClone:                   ;rdi ← a

    ret

strCmp:
    ret

strConcat:
    ret

strDelete:
    ret
 
strPrint:
    ret
    
listNew:
    ret

listAddFirst:
    ret

listAddLast:
    ret

listAdd:
    ret

listRemove:
    ret

listRemoveFirst:
    ret

listRemoveLast:
    ret

listDelete:
    ret

listPrint:
    ret

n3treeNew:
    ret

n3treeAdd:
    ret

n3treeRemoveEq:
    ret

n3treeDelete:
    ret

nTableNew:
    ret

nTableAdd:
    ret
    
nTableRemoveSlot:
    ret
    
nTableDeleteSlot:
    ret

nTableDelete:
    ret
