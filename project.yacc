%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
extern int yylex();
extern int yylineno;

void yyerror(char *);

extern char* token_buffer[];
extern int tbuf_size;

void PrintAssignment(){
	int tindex = tbuf_size - 3;
	//printf("%s\n",token_buffer[tindex]);
	//if(strcmp(token_buffer[tindex],";")){
	//	tindex--;
	//}
	if(tindex < 2){return;} //might not need this
	char* operand_right;
	char* operation;
	char* operand_left;

	operand_right = (char*)calloc(strlen(token_buffer[tindex]),sizeof(char));
	memcpy(operand_right,token_buffer[tindex],strlen(token_buffer[tindex]));
	tindex--;
		
	operation = (char*)calloc(1,sizeof(char));
	memcpy(operation,token_buffer[tindex],1);
	tindex--;
	
	operand_left = (char*)calloc(strlen(token_buffer[tindex]),sizeof(char));
        memcpy(operand_left,token_buffer[tindex],strlen(token_buffer[tindex]));
        tindex--;
	
	//printf("%s\n%s\n%s\n",operand_left,operation,operand_right);
	
	bool parsing = true;
	bool once = true;	
	while(parsing == true){
		if(strcmp(operation,"=") == 0){
			if(once){
				printf("MOV	R1,%s\n",operand_right);
				printf("MOV	%s,R1\n",operand_left);
			}
			else{
				printf("MOV	%s,R1\n",operand_left);
			}
			parsing = false;
		}
		else{ 
			if(strcmp(operation,"+") == 0){
				printf("MOV	R2,%s\n",operand_right);
				printf("MOV	R1,%s\n",operand_left);
				printf("ADD	R1,R2\n");
			}
			else{
				printf("MOV	R2,%s\n",operand_right);
				printf("MOV	R1,%s\n",operand_left);
				printf("SUB	R1,R2\n");
			}
			
			free(operand_right);
			operand_right = (char*)calloc(strlen(operand_left),sizeof(char));
			memcpy(operand_right,operand_left,strlen(operand_left));
			free(operand_left);
			//printf("MOV	R2,R1\n");
			//printf("swapped\n");
			
			//tindex--;
			memcpy(operation,token_buffer[tindex],1);
			//printf("op copied%s\n",operation);
			
			tindex--;
			operand_left = (char*)calloc(strlen(token_buffer[tindex]),sizeof(char));
			memcpy(operand_left,token_buffer[tindex],strlen(token_buffer[tindex]));

			once = false;
		}
	}

	free(operand_left);
	free(operand_right);
	free(operation);
	//for(int i = 0; i < tbuf_size - 1;i++){
	//	free(token_buffer[i]);
	//}
	tbuf_size = 1;
}

char* instruction_buffer[10000];

char varname[20];
char destination[20];
%}

%token VAR EQUAL PLUS MINUS SEMI LT LTEQ GT GTEQ EQ SPACESHIP NUM WHILE DO ENDWHILE IF THEN ENDIF ELSE JUNK


%%


stmts:			stmt stmts
			|stmt


stmt:			assignment				{PrintAssignment();}
			|while_loop				
			|if					

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
