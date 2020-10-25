%{
#define YYSTYPE void*
#include <stdio.h>
#include "helpers.h"
%}

/* Define tokens here */
%token T_NL T_INT
 /********** Start: add your tokens here **********/
%left PLUS MINUS
%left MUL
%token LP RP
%token LB RB
%token CL
%token CM

 /********** End: add your tokens here **********/

%%
input:  /* empty */ 
    |   input line;

line:   T_NL 
    |   expr T_NL { print_matrix($1); };

/********** Start: add your grammar rules here **********/

expr:	expr PLUS subexpr { $$ = matrix_add($1,$3); }
	|	expr MINUS subexpr { $$ = matrix_sub($1,$3); }
	|	subexpr { $$ = $1; };

subexpr:	subexpr MUL unit { $$ = matrix_mul($1,$3); }
	|	unit { $$ = $1; };

unit:	LP expr RP { $$ = $2; }
	|	matrix { $$ = $1; };

matrix: LB rows RB { $$ = $2; };

rows:	rows CL row { $$ = append_row($1,$3); }
	|	row { $$ = $1; };

row:	row CM element { $$ = append_element($1,$3); }
	|	element { $$ = $1; };

/********** End: add your grammar rules here **********/

element:  T_INT { $$ = element2matrix((long)$1); };
%%

int main() { return yyparse(); }
int yyerror(const char* s) { printf("%s\n", s); return 0; }
