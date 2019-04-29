#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>
#include <math.h>

#include "lib.h"


void test_n3Tree(FILE *pfile) {
    n3tree_t *t;
    t = n3treeNew();
    char* strings[10] = {"no","tengo","mucha","i","ma","gi","na","cion","!!","uno"};
        for(int i=0;i<10;i++) {
            n3treeAdd(t,strClone(strings[i]),(funcCmp_t*)&strCmp);
        }
    n3treePrint(t,pfile,(funcPrint_t*)&strPrint);
    n3treeDelete(t,(funcDelete_t*)&strDelete);
    fprintf(pfile, "%s\n","" );

}

void test_ntable(FILE *pfile) {
    char* strings[10] = {"no","tengo","mucha","i","ma","gi","na","cion","!!","uno"};
    nTable_t *n;
    n = nTableNew(33);
        for(int i=0;i<34;i++) {
            nTableAdd(n, i, strClone(strings[i % 10]), (funcCmp_t*)&strCmp);
        }
    nTablePrint(n,pfile,(funcPrint_t*)&strPrint);
    nTableDelete(n,(funcDelete_t*)&strDelete);
}

int main (void){
    FILE *pfile = fopen("salida.caso.propios.txt","w");
    test_n3Tree(pfile);
    test_ntable(pfile);
    fclose(pfile);
    return 0;
}


