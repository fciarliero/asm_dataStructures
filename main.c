#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>
#include <math.h>

#include "lib.h"

void test_n3tree(FILE *pfile){
    
}

void test_nTable(FILE *pfile){
    
}

void test_string(FILE *pfile){
char *a, *b, *c;
    // clone
    fprintf(pfile,"==> Clone");
    a = strClone("casa");
    b = strClone("");
    strPrint(a,pfile);
    fprintf(pfile,"\n");
    strPrint(b,pfile);
    fprintf(pfile,"\n");
    strDelete(a);
    strDelete(b);
    // concat
    fprintf(pfile,"==> Concat");
    a = strClone("perro_");
    b = strClone("loco");
    fprintf(pfile,"%i\n",strLen(a));
    fprintf(pfile,"%i\n",strLen(b));
    c = strConcat(a,b);
    fprintf(pfile,"%s\n",c);
    c = strConcat(c,strClone(""));
    fprintf(pfile,"%s\n",c);
    c = strConcat(strClone(""),c);
    fprintf(pfile,"%s\n",c);
    
    // range
    fprintf(pfile,"==> Range");
    fprintf(pfile,"%i\n",strLen(c));            
    int h = strLen(c);
    	//a = strClone(c);
    	//a = strRange(a,10,15);
    	//strPrint(a,pfile);
    	//strDelete(a);
    	//a = strRange(c,1,0);
    	//strPrint(a,pfile);
    	//strDelete(a);
    	//strDelete(c);
    for(int i=0; i<h+1; i++) {
        for(int j=0; j<h+1; j++) {    
            a = strClone(c);
            a = strRange(a,i,j);
            strPrint(a,pfile);
            fprintf(pfile,"\n");
            strDelete(a);
        }
        fprintf(pfile,"\n");
    }
    strDelete(c);
    // cmp
    fprintf(pfile,"==> Cmp");
    char* texts[5] = {"sar","23","taaa","tbb","tix"};
    for(int i=0; i<5; i++) {
        for(int j=0; j<5; j++) {
            fprintf(pfile,"cmp(%s,%s) -> %i\n",texts[i],texts[j],strCmp(texts[i],texts[j]));
        }
    }
}


int main (void){
    FILE *pfile = fopen("salida.caso.propios.txt","w");
    test_string(pfile);
    //test_n3tree(pfile);
    //test_nTable(pfile);
    fclose(pfile);
    return 0;
}


