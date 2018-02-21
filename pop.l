%{
#include<stdlib.h>
#include "type.h"
#include "y.tab.h"
#include<string.h>
void yyerror(char *s);
%}
%%
"return" 		   { return Return ;}
"if"			    { return If;}
"while"                     {return While ;}
[a-zA-Z]+			   {strcpy(yylval.sname,yytext);  return symb;}
[0-9]+                 {yylval.iValue = atoi(yytext); return num;}
[\n]                {return yytext[0];}
[ \t]                  {;}
"=="			   {yylval.ide='e'; return OP;}
[*+<]           	   {yylval.ide=yytext[0] ; return OP;}
[\]\[=]		           {return yytext[0] ;}
[;]			   { return yytext[0];}
.                      {ECHO; yyerror ("unexpected character");}

%%
int yywrap (void) {return 1;}

