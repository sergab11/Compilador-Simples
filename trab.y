/*
Sérgio Gabriel Vieira Bouço (1611200)
INF1022 - Trabalho Final
Analisador Sintático
*/

%{
	#include <stdio.h>
	#include <string.h>
	#include <stdlib.h>

	int yylex();
	extern int linha;
	extern FILE *yyin;
	void yyerror();
%}

%union{
	char *num;
}

%token ENTRADA
%token SAIDA
%token FIM
%token ENQUANTO
%token FACA
%token VEZES
%token INC
%token ZERA
%token DEC
%token SE
%token ENTAO
%token SENAO
%token <num> ID
%type <num> cmd cmds varlist 


%%
program	:	ENTRADA varlist SAIDA varlist cmds FIM {
    FILE *file = fopen("provolone.c", "w");
    if (file == NULL) exit(1); // error opening file
    char* codigo = malloc(strlen($2) + strlen($4) + strlen($5) + 75);
    strcpy(codigo, "void provolone(int ");
    strcat(codigo, $2);
		strcat(codigo, "){\n");
		strcat(codigo, "int ");
		strcat(codigo, $4);
		strcat(codigo, ";\n");
    strcat(codigo, $5);
    strcat(codigo, "	");
    strcat(codigo, "\nreturn ");
    strcat(codigo, $4);
    strcat(codigo, ";\n}");
    fprintf(file, "%s", codigo);
    fclose(file);

    printf("codigo na linguagem C escrito em 'provolone.c'\n");

    exit(0);
};

varlist	:	varlist ID {
    char* codigo = malloc(strlen($1) + strlen($2) + 1);
    strcpy(codigo, $1);
    strcat(codigo, ", int ");
    strcat(codigo, $2);
		$$ = codigo;
  }
  | ID {
		char* codigo = malloc(strlen($1) + 1);
		strcat(codigo, $1);
		$$ = codigo;
	}
;



cmds	:	cmd cmds {
    char* codigo = malloc(strlen($1) + strlen($2) + 1);
    strcat(codigo, "	");
    strcpy(codigo, $1);
    strcat(codigo, "	");
    strcat(codigo, $2);
    $$ = codigo;
  }
  | cmd {$$ = $1;}
;

cmd	:	ENQUANTO ID FACA cmds FIM {
   	char* codigo = malloc(strlen($2) + strlen($4) + 12); 
   	strcpy(codigo, "while(");
    strcat(codigo, $2); 
    strcat(codigo, "){ \n"); 
    strcat(codigo, "	");
    strcat(codigo, $4);
		strcat(codigo, ";\n}\n"); 
    $$ = codigo;
    }
    | ID '=' ID { 
		char* codigo = malloc(strlen($1) + strlen($3) + 6);
		strcpy(codigo, $1); 
		strcat(codigo, " = ");  
		strcat(codigo, $3);  
		strcat(codigo, ";\n");  
		$$ = codigo; 
		}
    | INC '(' ID ')' { 
		char* codigo = malloc(strlen($3) + 5);  
		strcat(codigo, "	"); 
		strcpy(codigo, $3); 
		strcat(codigo, "++; ");  
		$$ = codigo; 
		}
    | DEC '(' ID ')' { 
		char* codigo = malloc(strlen($3) + 5);  
		strcpy(codigo, $3); 
		strcat(codigo, "--; ");  
		$$ = codigo; 
		}
    | ZERA '(' ID ')' { 
		char* codigo = malloc(strlen($3) + 7);  
		strcpy(codigo, $3); 
		strcat(codigo, " = 0;\n");  
		$$ = codigo; 
		}
    | SE ID ENTAO cmds FIM{
        char* codigo = malloc(strlen($2) + strlen($4) + 10); 
        strcpy(codigo, "if(");
        strcat(codigo, $2); 
        strcat(codigo, "){\n"); 
        strcat(codigo, "	");
        strcat(codigo, $4);
				strcat(codigo, "\n}"); 
        $$ = codigo;
    } 
    | SE ID ENTAO cmds SENAO cmds FIM{
        char* codigo = malloc(strlen($2) + strlen($4) +strlen($6) + 50); 
        strcpy(codigo, "if(");
        strcat(codigo, $2); 
        strcat(codigo, "){ \n"); 
        strcat(codigo, "	");
        strcat(codigo, $4); 
        strcat(codigo, "\n}\n"); 
        strcat(codigo, "else{ \n");
        strcat(codigo, "	");
        strcat(codigo, $6);
				strcat(codigo, "\n} ");  
        $$ = codigo;
    } 
    | FACA ID VEZES cmds FIM{
        char* codigo = malloc(strlen($2) + strlen($4) + 30); 
        strcpy(codigo, "while(");
        strcat(codigo, $2); 
        strcat(codigo, "){ \n");
        strcat(codigo, "	");
        strcat(codigo, $4);
				strcat(codigo, "\n");
				strcat(codigo, "	");
				strcat(codigo, $2);
				strcat(codigo, "--;");
				strcat(codigo, "	\n}"); 
        $$ = codigo;
    }
;

%%

int main(int argc, char** argv){
	if (argc > 1) {
    yyin = fopen(argv[1], "r");
  }
  yyparse();
  if (argc > 1) {
    fclose(yyin);
  }

	return 0;
}
  
void yyerror(){
	printf("\nOperacao invalida na linha %d\n\n", linha);
}	
