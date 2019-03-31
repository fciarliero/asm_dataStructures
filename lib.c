#include "lib.h"

/** STRING **/

char* strRange(char* a, uint32_t i, uint32_t f) {
	unsigned int len = strLen(a);
	unsigned int acc = 0;
	char* res;
	//Si i>f, retorna el mismo string pasado por parámetro
	
	if (i > f)
	{
		res = a;
	}else{
		//Si f>len, se tomará como lı́mite superior la longitud del string.
		if (f > len)
		{
			f = len;
		}
		//i>len, entonces retorna la string vacı́a
		if (i >= len )
		{
			res = (char *) malloc(1);

			*res = '\0';
			free(a);
		}else{
			int tam = f - i +2;

			res = (char *) malloc(tam);
			while(i<=f){
				res[acc] = a[i];
				acc++;
				i++;
				res[acc] ='\0';
			}
			free(a);
		}
	}

    return res;
}

/** Lista **/

void listPrintReverse(list_t* l, FILE *pFile, funcPrint_t* fp) {

}

/** n3tree **/

void n3treePrintAux(n3treeElem_t** t, FILE *pFile, funcPrint_t* fp) {

}

void n3treePrint(n3tree_t* t, FILE *pFile, funcPrint_t* fp) {

}

/** nTable **/

void nTableRemoveAll(nTable_t* t, void* data, funcCmp_t* fc, funcDelete_t* fd) {

}

void nTablePrint(nTable_t* t, FILE *pFile, funcPrint_t* fp) {

}
