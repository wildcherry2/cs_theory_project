%{
#include <stdio.h>
#include <string.h>
extern int yylex();
extern int yylineno;
void yyerror(char *);

char varname[20];
char destination[20];
%}

%token VAR EQUAL PLUS MINUS SEMI LT LTEQ GT GTEQ EQ SPACESHIP NUM WHILE DO ENDWHILE IF THEN ENDIF ELSE JUNK


%%


stmts:			stmt stmts
			|stmt


stmt:			assignment				{printf("yacc found valid assignment statement\n");}
			|while_loop				{printf("yacc found valid while loop\n");}
			|if					{printf("yacc found valid if statement\n");}

/*** ASSIGNMENT STATEMENT RULES ***/
assignment:		VAR EQUAL expr additional_exprs SEMI

expr:			operand
			|mexpr

additional_exprs:	|arith_operator operand additional_exprs
			
mexpr:			operand arith_operator operand		

operand:		VAR
			|NUM
					
arith_operator:		PLUS
			|MINUS

/*** CONDITIONAL STATEMENT RULES ***/
conditional:		expr cond_operator expr

cond_operator:		LT|LTEQ|GT|GTEQ|EQ|SPACESHIP

/***WHILE LOOP RULES***/
while_loop:		WHILE conditional DO stmts ENDWHILE SEMI

/*** IF STATEMENT RULES ***/
if:			IF conditional THEN stmts else ENDIF SEMI

else:			|ELSE stmts					
//var:			VAR					{strcpy(destination, varname);}


%%


int main()
{
   yyparse();
}

void yyerror(char *msg)
{
   printf ("%s at line %d\n",msg,yylineno);
}
