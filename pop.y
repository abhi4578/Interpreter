%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<stdarg.h>
#include "type.h"
/* prototypes */
nodeType *opr(int oper,int nops, ...);
nodeType *id(int i);
nodeType *con(int val);

int ex(nodeType *p);
int yylex(void);
void yyerror(char *s);
symbol_table symbols[10];
void freeNode(nodeType *p);
int symbolVal(char symbol[]);
int ccount=0;
int yylex(void);
%} /* symbol table */
%union {
int iValue;
char ide;
char sname[10];
nodeType *nPtr;
};
%start start
%token Return
%token If
%token While
%token <iValue> num
%token <ide> OP
%token <sname> symb
%type <nPtr> exp prog isymb

%%
start	: prog '\n'   { ex($1); freeNode($1); exit(0);}
	| exp '\n'	  {printf("%d\n",ex($1)); freeNode($1); exit(0);}


prog 	: '[' '=' isymb exp ']'          { $$=opr('=',2,$3,$4);}
	
	|'['';' prog prog  ']'  { $$=opr(';',2,$3,$4) ;}
 
	| '[' While exp prog ']'    	{$$=opr(While,2,$3,$4);}


	| '[' Return exp ']' 		       { $$=opr(Return,1,$3);}
						 
	                        
	| '[' If exp prog prog']'	          { $$=opr(If,3,$3,$4,$5);}	

isymb	: symb					{$$=id(symbolVal($1));}
	
exp    	: '[' OP exp exp ']'                {$$=opr($2,2,$3,$4);}
       	               
	| symb                                 {$$=id(symbolVal($1));}
	| num					 { $$=con($1);}

        ;
%%
nodeType *con(int val) {
nodeType *p;
/* allocate node */
if ((p = malloc(sizeof(nodeType))) == NULL)
yyerror("out of memory");
/* copy information */
p->type = typeCon;
p->con.value = val;
return p;
}
nodeType *id(int i) {
nodeType *p;
/* allocate node */
if ((p = malloc(sizeof(nodeType))) == NULL)
yyerror("out of memory");
/* copy information */
p->type = typeId;	
p->id.i = i;
return p;
}

int symbolVal(char symbol[])
{        
	int bucket;
	for(bucket=0;bucket<ccount;bucket++)
	{
        if(strcmp(symbols[bucket].name,symbol)==0)
  	  { return bucket;}
		
	}
 
	strcpy(symbols[ccount].name,symbol);
	  ccount+=1;
	
	return ccount-1;
	
}
nodeType *opr(int oper, int nops, ...) {
va_list ap;
nodeType *p;
int i;
/* allocate node, extending op array */
if ((p = malloc(sizeof(nodeType) +
(nops-1) * sizeof(nodeType *))) == NULL)
yyerror("out of memory");
/* copy information */
p->type = typeOpr;
p->opr.oper = oper;
p->opr.nops = nops;
va_start(ap, nops);
for (i = 0; i < nops; i++)
p->opr.op[i] = va_arg(ap, nodeType*);
va_end(ap);
return p;
}


int ex(nodeType *p) 
{
if (!p) return 0;
switch(p->type) {
case typeCon: return p->con.value;
case typeId:return symbols[p->id.i].Value;
case typeOpr:
switch(p->opr.oper) {
case While:
	   while(ex(p->opr.op[0]))
	   ex(p->opr.op[1]);
	  return 0;
case If:
	if (ex(p->opr.op[0]))
	ex(p->opr.op[1]);
	return ex(p->opr.op[2]);

case Return: printf("%d\n", ex(p->opr.op[0]));
	     return 0;
case ';':ex(p->opr.op[0]); return ex(p->opr.op[1]);

case '=':return symbols[p->opr.op[0]->id.i].Value=ex(p->opr.op[1]);
case '+':return ex(p->opr.op[0]) + ex(p->opr.op[1]);
case '*': return ex(p->opr.op[0]) * ex(p->opr.op[1]);
case '<':return ex(p->opr.op[0]) < ex(p->opr.op[1]);
case 'e':return ex(p->opr.op[0]) == ex(p->opr.op[1]);


}
}
return 0;
}

int main (void) {
	/* init symbol table */
	int i;
	for(i=0;i<10;i++)
	symbols[i].Value=-128;
	return yyparse ();
}
void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 
void freeNode(nodeType *p) {
int i;
if (!p) return;
if (p->type == typeOpr) {
for (i = 0; i < p->opr.nops; i++)
freeNode(p->opr.op[i]);
}
free (p);
}
