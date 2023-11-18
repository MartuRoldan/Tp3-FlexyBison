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

%start objetivo

%%

objetivo: programa FDT {exit(0);}
;

programa: INICIO listaSentencias FIN {printf("\n\nAnalisis sintactico efectuado con exito"); exit(0);}
;

listaSentencias:     listaSentencias sentencia 
                    |sentencia
;

sentencia:   asignacion
            |entradaSalida
;

asignacion: ID {if(yyleng>32) yyerror("El ID es demasiado largo\n");} ASIGNACION expresion PYCOMA {asignar($1, $3);}
;

entradaSalida:  LEER PARENIZQUIERDO listaIdentificadores PARENDERECHO PYCOMA
                |ESCRIBIR PARENIZQUIERDO listaExpresiones PARENDERECHO PYCOMA
;

listaIdentificadores:    ID
                        |listaIdentificadores COMA ID
;

listaExpresiones:    expresion
                    |listaExpresiones COMA expresion
;

expresion:   primaria                           {$$ = $1;}
            |expresion operadorAditivo primaria {$$ = $1 + $3;}
; 

primaria:    ID
            |CONSTANTE                              {$$ = $1;}
            |PARENIZQUIERDO expresion PARENDERECHO  {$$ = $2;}
;

operadorAditivo: SUMA
                |RESTA
;

%%
#define largo 40

typedef struct Id {
		char nombre[largo]; //nombre de la variable
		int valor;		    //valor de la variable
} Id;

Id buffer[500]; //Armo una lista de identificadores para irlos guardando ahi
int tope = 0; //me dice cuantos identificadores tengo en la lista
int buscar(char* nombre);
void asignar(char* nombre, int valor);

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

void asignar(char* nombre, int valor) {	
	int i = buscar(nombre);
	if(i < 0) { // el ID no esta en el buffer
		strcpy(buffer[tope].nombre, nombre);
		buffer[tope].valor = valor;
		tope++;
	} 
	else { 
		buffer[indice].valor = valor;
	}	
}

int buscar(char* nombre) {
	int i;
	for(i = 0; i < tope; i++) {
		if(!strcmp(buffer[i].nombre, nombre)){
			return i;
		}
	}
	return -1;
/* Si el identificador no está en el buffer (índice es menor que 0), lo agrega al final del buffer con su valor correspondiente */
}
