%{
#include <stdio.h>
#include "y.tab.h"
#include <string.h>
#include <stdbool.h>

char* token_buffer[100];
int tbuf_size = 1;

int whilecount = 0;
int ifcount = 0;
bool elseflag = false;

void PrintConditionCheck(){
	char* operand_left = token_buffer[tbuf_size -4];
	char* operand_right = token_buffer[tbuf_size - 2];
	char* operation = token_buffer[tbuf_size - 3];
	
	printf("MOV	R8,%s\n",operand_left);
	printf("MOV	R4,%s\n",operand_right);
	printf("CMP	R4\n");
	
	
	if(strcmp(operation,"<") == 0){
		printf("BGE	");
	}
	else if(strcmp(operation,"<=") == 0){
		printf("BGT	");
	}
	else if(strcmp(operation,"==") == 0){
		printf("BNE	");
	}
	else if(strcmp(operation,">=") == 0){
		printf("BLT	");
	}
	else if(strcmp(operation,">") == 0){
		printf("BLE	");
	}
	else if(strcmp(operation,"<=>") == 0){
		printf("BEQ	");
	}
	
	free(operand_left);
	free(operand_right);
	free(operation);	
	
}

void PrintWhile(){
	printf("while%d:\n",whilecount);
	PrintConditionCheck(); //...jmp end ->insertwhilelabel
	printf("endwhile%d\n",whilecount);	
}

void PrintEndwhile(){
	printf("JMP 	while%d\n",whilecount);
	printf("endwhile%d:\n",whilecount);
	whilecount++;
}

void PrintIf(){
	printf("if%d:\n",ifcount);
	PrintConditionCheck(); //-> jmp to endif, under endif check for else
	printf("set_else_flag%d\n",ifcount);
}

void PrintElse(){
	elseflag = true;
	//printf("JMP	end_set_else_flag%d\n",ifcount);
	printf("else%d:\n",ifcount);
	printf("MOV	R5,0\n");
	//printf("JMP	end_set_else_flag%d\n",ifcount);
}

void PrintEndif(){
	printf("endif%d:\n",ifcount);
	if(elseflag){
		printf("MOV	R8,R5\n");
		printf("CMP	1\n");
		printf("MOV	R5,0\nMOV	R8,0\n");
		printf("BEQ	else%d\n",ifcount);
		printf("JMP	end_set_else_flag%d\n",ifcount);
		printf("set_else_flag%d:\n",ifcount);
		printf("MOV	R5,1\n");
		printf("JMP	endif\n");
		printf("end_set_else_flag%d:\n",ifcount);
		elseflag = false;
	}
	else{
		printf("JMP	end_set_else_flag%d\n",ifcount);
		printf("end_set_else_flag%d:\n",ifcount);
	}
	ifcount++;
}

void AddTok(){
	token_buffer[tbuf_size-1] = (char*)calloc(strlen(yytext),sizeof(char));
	memcpy(token_buffer[tbuf_size-1],yytext,strlen(yytext));
	tbuf_size++;
}

%}

%%
while		{return WHILE;}
do		{PrintWhile();return DO;}
endwhile	{PrintEndwhile();return ENDWHILE;}
if		{return IF;}
then		{PrintIf();return THEN;}
else		{PrintElse();return ELSE;}
endif		{PrintEndif();return ENDIF;}
[a-z]+          {AddTok();return VAR;}
"+"             {AddTok();return PLUS; }
"-"		{AddTok();return MINUS; }
"="             {AddTok();return EQUAL; }
";"             {AddTok();return SEMI; }
"<"		{AddTok();return LT;}
"<="		{AddTok();return LTEQ;}
">"             {AddTok();return GT;}
">="            {AddTok();return GTEQ;}
"<=>"           {AddTok();return SPACESHIP;}
"=="            {AddTok();return EQ;}
[0-9]+		{AddTok();return NUM;}
\n		;
\t		;
" "		;
.		{return JUNK;}

%%
