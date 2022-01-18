/*
Sérgio Gabriel Vieira Bouço (1611200)
INF1022 - Trabalho Final
Analisador Léxico
*/

%{
  #include <stdio.h>
  #include "trab.tab.h"
	int linha = 1;
%}

alfanum		[_a-zA-Z][_a-zA-Z0-9]*

%%

ENTRADA		{ return (ENTRADA); }
SAIDA			{ return (SAIDA); }
FIM       { return (FIM); }
ENQUANTO  { return (ENQUANTO); }
FACA      {	return (FACA); }
VEZES     { return (VEZES); }
INC       { return (INC); }
DEC       { return (DEC); }
ZERA      { return (ZERA); }
SE        { return (SE); }
ENTAO     { return (ENTAO); }
SENAO     { return (SENAO); }
[=()]     { return yytext[0]; }
{alfanum}	{ 
    				yylval.num=strdup(yytext); 
    				return (ID); 
    			}
[\n]      { linha++; }
.         ;

%%
	
int yywrap() {
	return 1;
}
