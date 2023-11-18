%{
#include <stdio.h>
#include <stdlib.h> 
#include <ctype.h>
#include <string.h>
extern int yyleng;
extern int yylex(void);
extern char *yytext;
extern FILE *yyin;
void yyerror(char const *);
%}

%union{
    char* cadena;
    int num;
}

%token INICIO FIN LEER ESCRIBIR
%token ASIGNACION PYCOMA COMA
%token SUMA RESTA
%token PARENIZQUIERDO PARENDERECHO

%token <cadena> ID
%token <num> CONSTANTE

/* Cambié objetivo por programa */
%start programa

%%

/* objetivo: programa FDT */

programa: INICIO listaSentencias FIN {printf("\n\nAnalisis sintactico efectuado con exito");}

listaSentencias:     listaSentencias sentencia 
                    |sentencia
;

sentencia:   asignacion
            |entradaSalida
;

asignacion: identificador {if(yyleng>32) yyerror("El ID es demasiado largo\n");} ASIGNACION expresion PYCOMA
;

entradaSalida:  LEER PARENIZQUIERDO listaIdentificadores PARENDERECHO PYCOMA
                |ESCRIBIR PARENIZQUIERDO listaExpresiones PARENDERECHO PYCOMA
;

listaIdentificadores:    identificador
                        |listaIdentificadores COMA identificador
;

listaExpresiones:    expresion
                    |listaExpresiones COMA expresion
;

expresion:   primaria 
            |expresion operadorAditivo primaria
; 

primaria:    identificador
            |CONSTANTE
            |PARENIZQUIERDO expresion PARENDERECHO
;

operadorAditivo: SUMA
                |RESTA
;

identificador: ID
;

%%

int main(int argc, char *argv []) {
    if((yyin = fopen(argv[1], "rt")) == NULL) {
		printf("\nNo se logro abrir el archivo: %s\n", argv[1]);
        return 1;
    } else { 
        printf("\nEl archivo se abrio con exito\n", argv[1]); 
        yyparse();
    }

    printf("\nLectura del archivo %s completa\n\n", argv[1]);
    fclose(yyin);
    return 0;
}

void yyerror (char const *s) {
    if(!strcmp(s, "syntax error")) {
        fprintf (stderr, "\n\n%s\n", s);
    } else {
        fprintf (stderr, "\n\nError lexico, no se reconoce el lexema: %s\n\n", s);
    }
    exit(1);
}

int yywrap() {
    return 1;  
} 