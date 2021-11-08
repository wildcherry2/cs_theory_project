%{
#include <stdio.h>
#include <string.h>
extern int yylex();
void yyerror(char *);

char varname[20];
char destination[20];

%}

%token VAR EQUAL PLUS MINUS SEMI LT LTEQ GT GTEQ EQ SPACESHIP NUM WHILE DO ENDWHILE IF THEN ENDIF ELSE JUNK


%%


stmts:  stmt stmts
        | stmt


stmt:   var EQUAL mexpr SEMI    { printf("yacc found stmt\n");
                                  printf("MOV %s, R0\n", destination); }


mexpr:  var1 PLUS var2          { printf("yacc found mexpr\n"); }

var1:   VAR                     { printf("MOV R0, %s\n",varname); }
var2:   VAR                     { printf("ADD R0, %s\n",varname); }

var:    VAR                     { strcpy(destination, varname); }


%%


int main()
{
   yyparse();
}

void yyerror(char *msg)
{
   printf ("Oops, syntax error\n");
}
