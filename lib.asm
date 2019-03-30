
section .rodata
    %define NULL byte 0

    formatoStr: db "%s", 0
    textualNULL: db "NULL",0
    off_datoNodo: db 0
    off_nextNodo: db 8
    off_prevNodo: db 16

    off_firstList: db 0
    off_lastList: db 8
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

;%define NULL 0

;uint32_t strLen(char* a)
strLen:                     ;rdi → *a
    push rbp
    push rdi
    push r12
    xor r12,r12
    mov rbp, rsp
    sub rsp, 8
    xor rax, rax            ;rax ← 0
    cmp rdi, NULL
    je .fin
    .ciclo:
        mov r12b, [rdi]     ;r12b ← [a] el char al que apunta el puntero a
        cmp r12b, NULL      ;si este char es el char null, termine de recorrer el string
        je .fin
        inc rax             ;si no es null el char actual, incremento el contador y posiciono el puntero en el proximo char
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
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push rdi
    sub rsp, 8
    call strLen
    inc rax                 ;rax tiene la longitud del string en bytes, inc para que incluya un byte para '\0'
    mov rdi, rax
    call malloc
    add rsp, 8
    pop rdi
    mov r13, rax
    .ciclo:
        cmp rdi, NULL
        je .fin
        mov r12b, [rdi]
        cmp r12b, NULL
        je .fin
        mov [r13], r12b
        inc r13
        inc rdi
        jmp .ciclo
    .fin:
        ;inc r13
    mov byte [r13], NULL
    pop r13
    pop r12
    pop rbp

    ret

;int32_t strCmp(char* a, char* b)
strCmp:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    .ciclo:
        mov r12b, [rdi]
        mov r13b, [rsi]
        inc rsi
        inc rdi
        cmp r12b, NULL
        je .terminoA
        cmp r13b, NULL
        je .terminoB
        cmp r12b, r13b
        je .ciclo
        jge .bGrande
        jle .aGrande

        .terminoA:
            cmp r13b, NULL
            je .AigualB
            jmp .bGrande

        .terminoB:
            cmp r12b, NULL
            je .AigualB
            jmp .aGrande
    .aGrande:
        mov rax, 1
        jmp .fin
    .bGrande:
        mov rax, -1
        jmp .fin
    .AigualB:
    mov rax, 0
    .fin:
    pop r13
    pop r12
    pop rbp
    ret

;char *string_concat( char *a, char *b){
;    int largo = strLen(a);
;    largo = largo + strLen(b);
;    char *c = malloc(largo + 1);
;    for (int i = 0; i < largo; ++i)
;    {   
;        if (largo < strLen(a))
;        {
;            c[i] = a[i];
;        }else{
;            c[i] = b[i];
;        }
;    }
;}
strConcat:
push rbp
mov rbp, rsp
push r12
push r13
push r14
push r15

mov r12, rdi        ;r12 ← *a
mov r13, rsi        ;r13 ← *b
call strLen         ;rax ← |a|
mov r14, rax        ;r14 ← largo
mov rdi, r13
call strLen         ;rax ← |b|
add r14, rax        ;r14 = |a| + |b|

mov rdi, r14        ;pido memoria por el largo de a + b
inc rdi             ;hago lugar para el 0 final
call malloc
mov r15, rax        ;r15 = *c
mov rdi, r12
mov rsi, r13
cmp r12, NULL
jne .copioA
cmp r13, NULL 
je .fin             ;si b era vacio, salgo
jmp .copioB         ;si a era vacio, copio el b
.copioA:
    cmp byte [r12], NULL   ;si a era vacio, copio el b
    je .copioB
    xor rax, rax
    mov al,[rdi]    ;el char de la pos actual se copia a la parte baja del registro de 16 bits de rax
    mov [r15], al   ;el char actual lo copio a c ""c[i] = a[i];""
    inc r15
    inc rdi
    cmp byte [rdi], NULL    ;llegue al final del loop
    jne .copioA
.copioB:
    cmp byte [r13], NULL   ;si b era vacio, salgo
    je .fin
    xor rax, rax
    mov al, [rsi]
    mov [r15], al
    inc rsi
    inc r15
    cmp byte [rsi], NULL
    jne .copioB
.fin:
    mov byte [r15], 0
    mov rdi, r12
    call strDelete
    mov rdi, r13
    call strDelete
    sub r15, r14
    mov rax, r15
    ;mov rdi, [r15]
    ;mov [r12], rdi
    ;mov [r13], rdi
pop r15
pop r14
pop r13
pop r12
pop rbp
ret

strDelete:
    push rbp
    mov rbp, rsp
    cmp rdi, NULL
    je .fin
    call free
    .fin:
    pop rbp
    ret

;void strPrint(char* a, FILE *pFile)
strPrint:                       ;rdi = *a, rsi = *pFile
    push rbp
    mov rbp, rsp
    mov rdx, rdi
    cmp byte rdi, NULL
    je .esNull
    cmp byte [rdi], NULL
    jne .noEsNull
    .esNull:
    mov rdx, textualNULL
    .noEsNull:
    mov rdi, rsi
    mov rsi, formatoStr
    call fprintf
    pop rbp
    ret


;typedef struct s_listElem{
    ;void *data;             ←offset 0
    ;struct s_listElem *next;←offset 8
    ;struct s_listElem *prev;←offset 16
;} listElem_t;
;s_listElem* new_listElem(void* dato, s_listElem* siguiente, s_listElem* anterior )
new_listElem: ;rdi = dato, rsi = siguiente, rdx = anterior
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    sub rsp, 8 
    mov r12, rdi
    mov r13, rsi
    mov r14, rdx
    mov rdi, 24
    call malloc
    mov [rax + off_datoNodo], r12
    mov [rax + off_nextNodo], r13
    mov [rax + off_prevNodo], r14
    add rsp, 8
    pop r14
    pop r13
    pop r12
    pop rbp
    ret

;listElem* del_listElem(listElem* nodoAborrar, listElem* nodoSiguiente, listElem* nodoAnterior, funcDelete_t* fd )
del_listElem: ;rdi = nodoAborrar, rsi = &pointerSiguiente, rdx = &pointerAnterior, rcx = funcDelete_t
                ;rsi y rdx es por ejemplo *nodo + off_nextNodo
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15
    mov r12, rdi                    ;r12 ← nodoAborrar
    mov r13, rsi                    ;r13 ← pointerSiguiente
    mov r14, rdx                    ;r14 ← pointerAnterior
    mov r15, rcx                    ;r15 ← funcDelete_t
    mov rdi, [r12 + off_datoNodo]   ;cargo el dato *void a borrar en rdi para pasarlo como parametro a free o funcDelete_t
    cmp r15, NULL                   ;me fijo si tengo que llamar a free o a funcDelete        
    je .borroStandard 
    call [r15]
    jmp .continuar
    .borroStandard:
    call free
    .continuar:                     ;ya borre el dato del nodoAnterior, ligo los punteros
    mov r15, [r12 + off_nextNodo]
    mov [r14], r15
    mov r15, [r12 + off_prevNodo] 
    mov [r13], r15
    mov rdi, r12
    call free
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret

;typedef struct s_list{
;    struct s_listElem *first; ←offset 0
;    struct s_listElem *last;  ←offset 8
;} list_t;

;list_t* listNew()
listNew:
    push rbp
    mov rbp, rsp
    push r12
    sub rsp, 8
    mov rdi, 16
    call malloc
    mov [rax + off_firstList], r12
    mov [rax + off_lastList], r12
    add rsp, 8
    pop r12
    pop rbp
    ret

;void listAddFirst(list_t* l, void* data)
listAddFirst:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    mov r12, rdi
    mov r13, rsi
    ;s_listElem* new_listElem(void* dato, s_listElem* siguiente, s_listElem* anterior )
    mov rdi, rsi
    mov rsi, [r12 + off_firstList]
    xor rdx, rdx
    call new_listElem
    mov [r12 + off_firstList], rax
    pop r13
    pop r12
    pop rbp
    ret

listAddLast:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    mov r12, rdi
    mov r13, rsi
    ;s_listElem* new_listElem(void* dato, s_listElem* siguiente, s_listElem* anterior )
    mov rdi, rsi
    xor rsi, rsi
    mov rdx, [r12 + off_lastList]
    call new_listElem
    mov [r12 + off_lastList], rax
    pop r13
    pop r12
    pop rbp
    ret

listAdd:
    ret

listRemove:
    ret
;void listRemoveFirst(list_t* l, funcDelete_t* fd)
listRemoveFirst: ;rdi = lista, rsi = funcDelete
    push rbp
    mov rbp, rsp   
    push r12
    push r13
    push r14
    push r15
    mov r12, rdi                        ;r12 = lista
    mov r13, rsi                        ;r13 = funcDelete_t
        ;del_listElem: ;rdi = nodoAborrar, rsi = &pointerSiguiente, rdx = &pointerAnterior, rcx = funcDelete_t
    lea r14, [rdi + off_firstList]      
    lea r15, [rdi + off_lastList]
        ;caso el nodo es unico o lista vacia
    cmp r14, r15
    jne .noEsUnico
        ;caso lista vacia
    cmp r14, NULL
    je .fin
        ;el nodo es unico
    jmp .borrar    
    jmp .fin
    .noEsUnico:
    mov r15, [r14 + off_nextNodo]       ;r15 = signodo
    add r15, off_prevNodo               ;r15 = &signodo.prevNodo
    .borrar:
    mov rdi, [r14]
    mov rsi, r14
    mov rdx, r15
    mov rcx, r13
    call del_listElem

    .fin:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret
;void listRemoveLast(list_t* l, funcDelete_t* fd)
listRemoveLast:
    ret
;void listDelete(list_t* l, funcDelete_t* fd)
listDelete:                     ;rdi = list, rsi = funcDelete
    push rbp
    mov rbp, rsp
    push r12
    push r13
    mov r12, rdi
    mov r13, rsi
    .ciclo:
    cmp byte [r12 +off_firstList], NULL
    je .fin
    mov rdi, r12
    mov rsi, r13
    call listRemoveFirst
    jmp .ciclo
    .fin:
    pop r13
    pop r12
    pop rbp
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
