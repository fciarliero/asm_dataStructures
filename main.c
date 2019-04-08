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
    	//a = strRange(a,0,1);
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
void test_list(FILE *pfile) {
    char* strings[10] = {"aa","bb","dd","ff","00","zz","cc","ee","gg","hh"};
    fprintf(pfile,"\n");
    char *a, *b, *c;
    list_t* l1;
    // listAddFirst
    fprintf(pfile,"==> listAddFirst\n");
    l1 = listNew();
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listAddFirst(l1,strClone("PRIMERO"));
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listDelete(l1,(funcDelete_t*)&strDelete);
    l1 = listNew();
    listAddFirst(l1,strClone("PRIMERO"));
    listAddFirst(l1,strClone("PRIMERO"));
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listDelete(l1,(funcDelete_t*)&strDelete);
    l1 = listNew();
    listAddFirst(l1,strClone("PRIMERO"));
    listAddFirst(l1,strClone("PRIMERO"));
    listAddFirst(l1,strClone("PRIMERO"));
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listDelete(l1,(funcDelete_t*)&strDelete);
    // listAddLast
    fprintf(pfile,"==> listAddLast\n");
    l1 = listNew();
    listAddLast(l1,strClone("ULTIMO"));
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    
    listDelete(l1,(funcDelete_t*)&strDelete);
    l1 = listNew();
    listAddLast(l1,strClone("ULTIMO"));
    listAddLast(l1,strClone("ULTIMO"));
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listDelete(l1,(funcDelete_t*)&strDelete);
    l1 = listNew();
    listAddLast(l1,strClone("ULTIMO"));
    listAddLast(l1,strClone("ULTIMO"));
    listAddLast(l1,strClone("ULTIMO"));
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listDelete(l1,(funcDelete_t*)&strDelete);
    //listAdd
    fprintf(pfile,"==> listAdd\n");
    l1 = listNew();
    for(int i=0; i<5;i++)
        listAdd(l1,strClone(strings[i]),(funcCmp_t*)&strCmp);
    listAddFirst(l1,strClone("PRIMERO"));
    listAddLast(l1,strClone("ULTIMO"));
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listDelete(l1,(funcDelete_t*)&strDelete);
    l1 = listNew();
    listAddFirst(l1,strClone("PRIMERO"));
    listAddLast(l1,strClone("ULTIMO"));
    for(int i=0; i<5;i++)
        listAdd(l1,strClone(strings[i]),(funcCmp_t*)&strCmp);
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listDelete(l1,(funcDelete_t*)&strDelete);

    // listRemove
    fprintf(pfile,"==> listRemove\n");
    l1 = listNew();
    listRemove(l1, strings[0], (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);
    for(int i=0; i<5;i++) {
        listAdd(l1,strClone(strings[i]),(funcCmp_t*)&strCmp);
        listRemove(l1, strings[0], (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);
    }
    listRemove(l1, strings[1], (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);
    listAddFirst(l1,strClone("PRIMERO"));
    listRemove(l1, strings[2], (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);
    listAddLast(l1,strClone("ULTIMO"));
    listRemove(l1, "PRIMERO", (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);
    listRemove(l1, "ULTIMO", (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listDelete(l1,(funcDelete_t*)&strDelete);

    // listRemoveFirst
    fprintf(pfile,"==> listRemoveFirst\n");
    l1 = listNew();
    listRemoveFirst(l1, (funcDelete_t*)&strDelete);
    for(int i=0; i<5;i++)
        listAdd(l1,strClone(strings[i]),(funcCmp_t*)&strCmp);
    listRemoveFirst(l1, (funcDelete_t*)&strDelete);
    listAddFirst(l1,strClone("PRIMERO"));
    listRemoveFirst(l1, (funcDelete_t*)&strDelete);
    listAddLast(l1,strClone("ULTIMO"));
    listRemoveFirst(l1, (funcDelete_t*)&strDelete);
    listRemoveFirst(l1, (funcDelete_t*)&strDelete);
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listDelete(l1,(funcDelete_t*)&strDelete);

    // listRemoveLast
        fprintf(pfile,"==> listRemoveLast\n");
      l1 = listNew();
      listRemoveLast(l1, (funcDelete_t*)&strDelete);
      for(int i=0; i<5;i++)
          listAdd(l1,strClone(strings[i]),(funcCmp_t*)&strCmp);
      listRemoveLast(l1, (funcDelete_t*)&strDelete);
      listAddFirst(l1,strClone("PRIMERO"));
      listRemoveLast(l1, (funcDelete_t*)&strDelete);
      listAddLast(l1,strClone("ULTIMO"));
      listRemoveLast(l1, (funcDelete_t*)&strDelete);
      listRemoveLast(l1, (funcDelete_t*)&strDelete);
      listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
      listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
      listDelete(l1,(funcDelete_t*)&strDelete);
        // listRemove listRemoveFirst listRemoveLast
    fprintf(pfile,"==> listRemove listRemoveFirst listRemoveLast\n");
    l1 = listNew();
    listRemove(l1, strings[2], (funcCmp_t*)&strCmp, 0);
    listRemoveFirst(l1, 0);
    listRemoveLast(l1, 0);
    char* stringsLocal[10];
    for(int i=0; i<10;i++)
        stringsLocal[i] = strClone(strings[i]);
    for(int i=0; i<10;i++)
        listAdd(l1,stringsLocal[i],(funcCmp_t*)&strCmp);
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listRemove(l1, strings[2], (funcCmp_t*)&strCmp, 0);
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listRemoveLast(l1, 0);
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listRemoveFirst(l1, 0);
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listRemoveLast(l1, 0);
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listRemove(l1, strings[2], (funcCmp_t*)&strCmp, 0);
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listRemoveFirst(l1, 0);
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listRemoveLast(l1, 0);
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listRemoveFirst(l1, 0);
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listRemove(l1, strings[2], (funcCmp_t*)&strCmp, 0);
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listDelete(l1,0);
    for(int i=0; i<10;i++)
        free(stringsLocal[i]);
    
}

void test_n3Tree(FILE *pfile) {
    char *a, *b, *c;
    n3tree_t *t;
    // n3treeAdd
    fprintf(pfile,"==> n3treeAdd\n");
    t = n3treeNew();
    n3treeAdd(t, strClone("zar"),(funcCmp_t*)&strCmp);
    n3treeAdd(t, strClone("zar"),(funcCmp_t*)&strCmp);
    n3treeAdd(t, strClone("zsd"),(funcCmp_t*)&strCmp);
    n3treeAdd(t, strClone("zasf"),(funcCmp_t*)&strCmp);
    n3treeAdd(t, strClone("za33r"),(funcCmp_t*)&strCmp);
    n3treeAdd(t, strClone("21ar"),(funcCmp_t*)&strCmp);
    n3treePrint(t,pfile,(funcPrint_t*)&strPrint);
    fprintf(pfile,"\n");
    n3treeDelete(t,(funcDelete_t*)&strDelete);
}

int main (void){
    FILE *pfile = fopen("salida.caso.propios.txt","w");
    //test_string(pfile);
    //test_list(pfile);
    test_n3Tree(pfile);
    //test_n3tree(pfile);
    //test_nTable(pfile);
    fclose(pfile);
    return 0;
}


