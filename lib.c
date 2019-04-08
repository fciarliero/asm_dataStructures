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
	fprintf(pFile, "%s","[" );
	if (l != NULL)
	{
	listElem_t *primero = l->first;
	listElem_t *ultimo = l->last;
	//void *dat = primero->data;
		while(ultimo != NULL){
			if(fp != NULL){
				fp(ultimo->data, pFile);
				
			}else{
				fprintf(pFile, "%p",ultimo->data);
				
			}
			ultimo = ultimo->prev;
			if (ultimo != NULL)
			{
				fprintf(pFile, "%s","," );
			}
		}

	}
	fprintf(pFile, "%s","]" );
//	//lol
// listPrintRev(l,pFile,(funcPrint_t*)&fp);

}




/** n3tree **/
/*
typedef struct s_n3treeElem{
void* data;
struct s_n3treeElem *left;
struct s_list *center;
struct s_n3treeElem *right;
} n3treeElem_t;
*/
void n3treePrintAux(n3treeElem_t* t, FILE *pFile, funcPrint_t* fp) {
	if (t == NULL)
	{
		return;
	}
	n3treePrintAux(t->right, pFile, fp);

		if(fp == NULL){
			fprintf(pFile, "%p",t->data );
		}else{
			fp(t->data, pFile);
		}

		if (t->center->first != NULL)
		{
			listPrint(t->center,pFile,fp);
		}
		fprintf(pFile, "%s"," ");

	n3treePrintAux(t->left, pFile, fp);
}
//
//void printInorder(struct Node* node) 
//{ 
//    if (node == NULL) 
//        return; 
//  
//    /* first recur on left child */
//    printInorder(node->left); 
//  
//    /* then print the data of node */
//    cout << node->data << " "; 
//  
//    /* now recur on right child */
//    printInorder(node->right); 
//} 
void n3treePrint(n3tree_t* t, FILE *pFile, funcPrint_t* fp) {
	fprintf(pFile, "%s","<< " );
	if(t != NULL){
		n3treePrintAux(t->first, pFile, fp);
	}
	fprintf(pFile, "%s",">>" );
}

/** nTable **/

void nTableRemoveAll(nTable_t* t, void* data, funcCmp_t* fc, funcDelete_t* fd) {

}

void nTablePrint(nTable_t* t, FILE *pFile, funcPrint_t* fp) {

}
