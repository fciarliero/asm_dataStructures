
section .rodata
    formatoStr: db "%s", 0
    textualNULL: db "NULL",0
    formatoChar: db"%c", 0    
    formatoPtr: db"%p", 0
    abre: db "["
    cierra: db "]"
    coma: db","

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

    %define off_datoNodo 0
    %define off_nextNodo 8
    %define off_prevNodo 16 
    %define NULL 0

    %define off_firstList  0
    %define off_lastList  8

    %define off_n3ElemData 0
    %define off_n3ElemLeft 8
    %define off_n3ElemCenter 16
    %define off_n3ElemRight 24

    %define menor -1
    %define mayor 1
    %define igual 0

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
        mov rax, mayor
        jmp .fin
    .bGrande:
        mov rax, menor
        jmp .fin
    .AigualB:
    mov rax, igual
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
    mov byte [r15], NULL    ;copio '\0' del finde string
    cmp r12, r13
    je .alliasingInput
    mov rdi, r12
    call strDelete
    mov rdi, r13
    call strDelete
    jmp .salir
    .alliasingInput:
    cmp r12, NULL 
    je .salir
    mov rdi, r12
    call strDelete
    .salir:
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
    cmp rdi, NULL
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
    ;off_datoNodo = 0
    ;r12 = *string
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

    mov r12, rdi        ;r12 = nodo a borrar
    mov r13, rsi        ;r13 = funcDelete

    mov rdi, [r12 + off_datoNodo]
    cmp r13, NULL
    je .llamarFree
    call r13
    jmp .salir
    .llamarFree:
        mov rdi, [r12 + off_datoNodo]
        ;call free
    .salir:
    mov rdi, r12
    call free
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret

;typedef struct s_list{
;    struct us_listElem *first; ←offset 0
;    struct s_listElem *last;  ←offset 8
;} list_t;


;list_t* listNew()
listNew:
    push rbp
    mov rbp, rsp
    push r12
    xor r12, r12
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
listAddFirst:       ;rdi = *lista, rsi = *dato
    push rbp
    mov rbp, rsp
    push r12
    push r13
    mov r12, rdi    ;r12 = *lista
    mov r13, rsi    ;r13 = *dato
                                        ;s_listElem* new_listElem(void* dato, s_listElem* siguiente, s_listElem* anterior )
    mov rdi, r13                        ;paso *dato como primer parametro
    mov rdx, NULL                       ;no hay nodo anterior al nuevo
    mov rsi, [r12 + off_firstList]      ;el nodo sig al nuevo nodo es el primero anterior
    call new_listElem   ;rax = newNodo
    mov rdi, [r12 + off_lastList]
    cmp rdi, [r12 + off_firstList]
    jne .listaConUnElemento
    cmp qword [r12 + off_firstList], NULL
    jne .listaConUnElemento 
    ;si llego hasta aca es que la lista estaba vacia antes de llamar a listAddFirst
    mov [r12 + off_firstList], rax
    mov [r12 + off_lastList], rax
    jmp .fin
    .listaConUnElemento:
        mov rdi, [r12 + off_firstList]
        mov [r12 + off_firstList], rax
        mov [rdi + off_prevNodo], rax
    .fin:
    mov rax, r12 
    pop r13
    pop r12
    pop rbp
    ret
;;void listAddLast(list_t* l, void* data)
listAddLast:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    mov r12, rdi    ;r12 = *lista
    mov r13, rsi    ;r13 = *dato
                                        ;s_listElem* new_listElem(void* dato, s_listElem* siguiente, s_listElem* anterior )
    mov rdi, r13                        ;paso *dato como primer parametro
    mov rsi, NULL                       ;no hay nodo siguiente al nuevo
    mov rdx, [r12 + off_lastList]       ;el nodo anterior al nuevo nodo es el ultimo anterior
    call new_listElem                   ;rax = newNodo
    mov rdi, [r12 + off_lastList]
    cmp rdi, [r12 + off_firstList]
    jne .listaConUnElemento
    cmp qword [r12 + off_firstList], NULL
    jne .listaConUnElemento 
    ;si llego hasta aca es que la lista estaba vacia antes de llamar a listAddFirst
    mov [r12 + off_firstList], rax
    mov [r12 + off_lastList], rax
    jmp .fin
    .listaConUnElemento:
        mov rdi, [r12 + off_lastList]
        mov [r12 + off_lastList], rax
        mov [rdi + off_nextNodo], rax
    .fin:
    mov rax, r12 
    pop r13
    pop r12
    pop rbp
    ret

;    void listAdd(list_t* l, void* data, funcCmp_t* fc){
;    listElem_t *actual = l->first;
;    listElem_t *anterior = NULL;
;    //me fijo si la lista es vacia
;    if (actual != NULL)
;    { 
;                //actual->data > data
;        while(fc(actual->data, data) == -1){
;            anterior = actual;
;            actual = actual->next;
;        } 
;        listElem_t *previ = anterior;
;        listElem_t *nex = actual;
;        actual = new_listElem(dato, nex, previ );
;        //anterior == NULL => añado en el primer lugar
;        if (previ == NULL)
;        {
;            l->first->prev = actual;
;            l->first = actual;
;        }else if (nex == NULL){
;        //nex == NULL => añado en el ultimo lugar
;            l->last->next = actual;
;            l->last = actual;
;        }else{
;            nex->prev = actual;
;            previ->next= actual;
;        }
;
;
;    }else{
;        listAddFirst( l, data);
;    }
;}

;void listAdd(list_t* l, void* data, funcCmp_t* fc)
listAdd:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15

    mov r12, rdi    ;r12 = l
    mov r13, rsi    ;r13 = data
    mov r14, rdx    ;r14 = fc
    mov r11, NULL   ;previ = NULL
    mov r15, [r12 + off_firstList]              ;    listElem_t *actual = l->first;
    ;cmp r15, [r12 + off_lastList]                               ;    //me fijo si la lista es vacia
    cmp r15, NULL                                 ;la lista es vacia?
    je .agregoAdelante
    .ciclo:
        mov rdi, [r15 + off_datoNodo]
        mov rsi, r13
            push r11
            sub rsp, 8
        call r14
            add rsp, 8
            pop r11
        cmp rax, 1
        jne .salirCiclo
        mov r11, r15
        mov r15, [r15 + off_nextNodo]
        cmp r15, NULL
        je .salirCiclo
        jmp .ciclo
    .salirCiclo:    ;r15 = siguiente, r11 = anterior
        cmp r15, NULL
        je .agregoAtras
        cmp r11, NULL 
        je .agregoAdelante
        mov rdi, r13
        mov rsi, r15
        mov rdx, r11
            push r11
            sub rsp, 8
            call new_listElem ;rdi = dato, rsi = siguiente, rdx = anterior
            add rsp, 8
            pop r11

        mov [r15 + off_prevNodo], rax       ;nex->prev = actual;
        mov [r11 + off_nextNodo], rax       ;previ->next= actual;
        jmp .fin
        .agregoAtras:
            mov rdi, r12
            mov rsi, r13
            call listAddLast
            jmp .fin
        .agregoAdelante:
            mov rdi, r12                        ;listAddFirst( l, data);
            mov rsi, r13
            call listAddFirst
    .fin:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret
;int listaLargo(lista_t *l);
;listaLargo:
;    push rbp
;    mov rbp, rsp
;    push r12
;    push r13
;    xor rax, rax
;    mov r12, [rdi + off_firstList]
;    mov r13, [rdi + off_lastList]
;    cmp r12, r13
;    jne .listaConUnElemento
;    .ciclo:
;    add rax, 1
;    mov r12, [r12 + off_nextNodo]
;    cmp r12, NULL
;    je .fin
;    jmp .ciclo
;    .listaConUnElemento:
;    cmp r12, NULL
;    je .zero
;    mov rax, 1
;    jmp .fin
;    .zero:
;    mov rax, 0
;    .fin:
;    pop r13
;    pop r12
;    pop rbp
;    ret

;void listRemove(list_t* l, void* data, funcCmp_t* fc, funcDelete_t* fd)
listRemove:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15

    mov r12, rdi    ;r12 = l
    mov r13, rsi    ;r13 = data
    mov r14, rdx    ;r14 = fc
    mov r15, rcx    ;r15 = fd
    mov r10, NULL   ;previ = NULL
    mov r11, [r12 + off_firstList]              ;    listElem_t *actual = l->first;
    ;cmp r15, [r12 + off_lastList]                               ;    //me fijo si la lista es vacia
    cmp r11, NULL                                 ;la lista es vacia?
    je .fin
    .ciclo:             ;r10 =anterior, r11 = siguiente
        mov rdi, [r11 + off_datoNodo]
        mov rsi, r13
            push r10
            push r11
        call r14
            pop r11
            pop r10
        cmp rax, 0
        je .borro
        mov r10, r11
        mov r11, [r11 + off_nextNodo]
        cmp r11, NULL
        je .salirCiclo
        jmp .ciclo
    .borro:
        cmp r10, NULL
        je .borroPrimero
        cmp qword [r11 + off_nextNodo], NULL
        je .borroUltimo
        mov r9, [r11 + off_nextNodo]
        mov [r10 + off_nextNodo], r9
        mov [r9 + off_prevNodo], r10
        mov rdi, r11
        mov rsi, r15
            push r10
            push r9
            call del_listElem
            pop r9
            pop r10
        mov r11, r9
        jmp .ciclo
    .borroPrimero:
    mov rdi, r12
    mov rsi, r15
        push r10
        push r11
        call listRemoveFirst
        pop r11
        pop r10
    mov r11, [r12 + off_firstList]
    cmp r11, NULL
    je .fin
    jmp .ciclo
    .borroUltimo:
    mov rdi, r12
    mov rsi, r15
    call listRemoveLast
    .salirCiclo:    ;r15 = siguiente, r11 = anterior
    .fin:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret

;void listRemoveFirst(list_t* l, funcDelete_t* fd){
;    elemento primero = l.first
;    elemento ultimo = l.last 
;
;    if(primero != NULL ){
;        
;        if (primero == ultimo){
;            //la lista tiene un solo elemento
;            borrarElemLista(primero)
;
;        }else{
;            //la lista tiene mas de un elemento
;            elemento segundo = primero.siguiente
;            segundo.anterior = null
;            borrarElemLista(primero)
;            l.first = segundo
;
;        }
;    }else{
;        //la lista es vacia 
;        free(l)
;    }
;    
;}
;void listRemoveFirst(list_t* l, funcDelete_t* fd)
listRemoveFirst: ;rdi = lista, rsi = funcDelete
    push rbp
    mov rbp, rsp   
    push r12
    push r13
    push r14
    push r15
    mov r12, rdi
    mov r13, rsi
    mov r14, [rdi + off_firstList]
    mov r15, [rdi + off_lastList]
    cmp r14, NULL
    jne .listaNoVacia
;    mov rdi, r12
;    call free
    jmp .fin
    .listaNoVacia:
        cmp r14, r15
        jne .tieneMasQUnElemento
        mov rdi, r14
        call del_listElem
        mov qword [r12 + off_firstList], NULL
        mov qword [r12 + off_lastList], NULL
        
        jmp .fin
    .tieneMasQUnElemento:
        mov rcx, [r14 + off_nextNodo]
        ;mov rcx, [rcx + off_nextNodo]
        mov qword [rcx + off_prevNodo], NULL
        mov [r12 + off_firstList], rcx
        mov rdi, r14
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
    push rbp
    mov rbp, rsp   
    push r12
    push r13
    push r14
    push r15
    mov r12, rdi
    mov r13, rsi
    mov r14, [rdi + off_firstList]
    mov r15, [rdi + off_lastList]
    cmp r14, NULL
    jne .listaNoVacia
;    call free
    jmp .fin
    .listaNoVacia:
        cmp r14, r15
        jne .tieneMasQUnElemento
        mov rdi, r14
        call del_listElem
        mov qword [r12 + off_firstList], NULL
        mov qword [r12 + off_lastList], NULL
        
        jmp .fin
    .tieneMasQUnElemento:
        mov rcx, [r15 + off_prevNodo]
        ;mov rcx, [rcx + off_nextNodo]
        mov qword [rcx + off_nextNodo], NULL
        mov [r12 + off_lastList], rcx
        mov rdi, r15
        call del_listElem
    .fin:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret
;void listDelete(list_t* l, funcDelete_t* fd)
listDelete:                     ;rdi = list, rsi = funcDelete
    push rbp
    mov rbp, rsp
    push r12
    push r13
    mov r12, rdi
    mov r13, rsi
    cmp qword [r12 + off_firstList], NULL
    jne .ciclo
    jmp .fin
    .ciclo:
        cmp qword [r12 + off_firstList], NULL
        je .fin
        mov rdi, r12
        mov rsi, r13
        call listRemoveFirst
        jmp .ciclo
    mov rdi, r12
    .fin:
    mov rdi, r12
    call free
    pop r13
    pop r12
    pop rbp
    ret

    ;void listPrint(list_t* l, FILE *pFile, funcPrint_t* fp)
listPrint:

    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15
    mov r12, rdi                ;lista
    mov r13, rsi                ;pfile
    mov r14, rdx 
    mov rcx, rdx               ;funprint
    mov rdi, r13
    xor rsi, rsi
    mov rsi, formatoChar
    mov rdx, [abre]
    call fprintf
    mov r15, [r12 + off_firstList]
    .ciclo:
        cmp r15, NULL
        je .termino
        cmp r14, NULL
        je .copioStandard
            mov rdi, [r15 + off_datoNodo]
            mov rsi, r13
            call r14
            jmp .saltito
        .copioStandard:
            mov rdi, r13
            mov rsi, formatoPtr
            mov rcx, [r15 + off_datoNodo]
            call fprintf
        .saltito:
        mov r15, [r15 + off_nextNodo]
        cmp r15, NULL
        je .ciclo
        mov rdi, r13
        mov rsi, formatoChar
        mov rdx, [coma]
        call fprintf
        jmp .ciclo

    .termino:
      mov rdi, r13
      mov rsi, formatoChar
      mov rdx, [cierra]
      call fprintf
      pop r15
      pop r14
      pop r13
      pop r12
      pop rbp
    ret


;typedef struct s_n3treeElem{
;void* data;                    ←offset 0
;struct s_n3treeElem *left;     ←offset 8
;struct s_list *center;         ←offset 16
;struct s_n3treeElem *right;    ←offset 24
;} n3treeElem_t;                ←tam 32
new_n3treeElem:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    mov r13, rdi            ;data = r13
    mov rdi, 32
    call malloc
    mov r12, rax
    mov [r12 + off_n3ElemData], r13
    mov qword [r12 + off_n3ElemLeft], NULL
    call listNew
    mov [r12 + off_n3ElemCenter], rax
    mov qword [r12 + off_n3ElemRight], NULL
    mov rax, r12
    pop r13
    pop r12
    pop rbp
ret

;typedef struct s_n3tree{
;struct s_n3treeElem *first; ← offset 0
;} n3tree_t;                 ← tam 8

;n3tree_t* n3treeNew()
n3treeNew:
    push rbp
    mov rbp, rsp
    mov rdi, 8
    call malloc
    mov qword [rax], NULL 
    pop rbp
    ret

;void n3treeAdd(n3tree_t* t, void* data, funcCmp_t* fc)
n3treeAdd:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15
    mov r12, rdi            ;rdi = n3tree
    mov r13, rsi            ;rsi = data 
    mov r14, rdx            ;rdx = fc
    mov rdi, r13
    call new_n3treeElem
    mov r15, rax            ;r15 = nuevo nodo
    cmp qword [r12], NULL
    je .n3Nulo
    mov rdi, [r12]
    mov rsi, r15
    mov rdx, r14
    call recuAddn3
    jmp .fin
    .n3Nulo:
        mov [r12], r15
    .fin:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret
;n3tree_t* recuAddn3(n3treeElem* n3, n3treeElem* nodo, funcComp* fc)
recuAddn3:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15
    mov r12, rdi    ;r12 = n3treeElem
    mov r13, rsi    ;r13 = nodo
    mov r14, rdx    ;r14 = fc

    mov rdi, [r12 + off_n3ElemData]
    mov rsi, [r13 + off_n3ElemData]
    call r14
    cmp rax, menor
    je .agregoDer
    cmp rax, mayor
    je .agregoIzq
    ;si estoy aca es porque son iguales
        mov rdi, [r12 + off_n3ElemCenter]
        mov rsi, [r13 + off_n3ElemData]
        call listAddLast
        jmp .fin
    .agregoIzq:
        cmp qword [r12 + off_n3ElemLeft], NULL
        jne .recuCallIz
        mov [r12 + off_n3ElemLeft], r13
        jmp .fin
        .recuCallIz:
            mov rdi, [r12 + off_n3ElemLeft]
            mov rsi, r13
            mov rdx, r14
            call recuAddn3
            jmp .fin
    .agregoDer:
        cmp qword [r12 + off_n3ElemRight], NULL
        jne .recuCallDe
        mov [r12 + off_n3ElemRight], r13
        jmp .fin
        .recuCallDe:
            mov rdi, [r12 + off_n3ElemRight]
            mov rsi, r13
            mov rdx, r14
            call recuAddn3
            jmp .fin   
    .fin:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
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
