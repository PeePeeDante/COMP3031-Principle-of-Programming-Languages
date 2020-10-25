%option noyywrap
%{
#define YYSTYPE void*
#include "matcal.tab.h"
%}

/* Flex definitions */
whitespace      [ \t]+
newline         [\n]
integer         [0-9]+

/********** Start: add your definitions here **********/
plus			[+]
minus			[-]
mul				[*]
left_para		[(]
right_para		[)]

/********** End: add your definitions here **********/

%%
 /********** Start: add your rules here. **********/
{plus}			{ return PLUS; }
{minus}			{ return MINUS; }
{mul}			{ return MUL; }
{left_para}		{ return LP; }
{right_para}	{ return RP; }
"["				{ return LB; }
"]"				{ return RB; }
";"				{ return CL; }
","				{ return CM; }


 /********** End: add your rules here **********/

{integer}       { yylval = (void*)atol(yytext); return T_INT; }
{newline}       { return T_NL; }
{whitespace}    /* ignore white spaces */
%%
