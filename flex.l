%{
	#include <stdio.h>
	#include <stdlib.h>
    #include <string.h>
	#include "y.tab.h"
    extern FILE *yyin;
    extern int yyparse();
    extern void yyerror(char const *);
%}

DIGITO [0-9]
LETRA [a-zA-Z]
IDENTIFICADOR {LETRA}({LETRA}|{DIGITO})*
constEntera {DIGITO}({DIGITO})*

%%
Inicio      { printf("\nP. reserv. \t\t{%s}",yytext); return INICIO; }
Fin         { printf("\nP. reserv. \t\t{%s}",yytext); return FIN; }
Leer        { printf("\nP. reserv. \t\t{%s}",yytext); return LEER; }
Escribir    { printf("\nP. reserv. \t\t{%s}",yytext); return ESCRIBIR; }

":=" { printf("\nOp. asignacion \t\t{%s}",yytext); return ASIGNACION; }
{constEntera} { printf("\nCte \t\t\t{%s}",yytext); yylval.num=atoi(yytext); return CONSTANTE; }
{IDENTIFICADOR} { printf("\nId \t\t\t{%s}",yytext); return ID; }

";" { printf("\nCarac. de punt. \t{%s}",yytext); return PYCOMA; }
"," { printf("\nCarac. de punt. \t{%s}",yytext); return COMA; }
"(" { printf("\nCarac. de punt. \t{%s}",yytext); return PARENIZQUIERDO; }
")" { printf("\nCarac. de punt. \t{%s}",yytext); return PARENDERECHO; }

"+" { printf("\nOp. aditivo \t\t{%s}",yytext); return SUMA; }
"-" { printf("\nOp. aditivo \t\t{%s}",yytext); return RESTA; }

[ \t\r\n]     { /* Ignorar espacios, caracteres de nueva linea y tabulaciones */ }
.             yyerror(yytext);
%%