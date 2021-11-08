%{
#include <stdio.h>
#include "y.tab.h"
#include <string.h>

//extern char varname[];
%}

%%
while		{printf("lex found while\n"); return WHILE;}
do		{printf("lex found do\n");return DO;}
endwhile	{printf("lex found endwhile\n"); return ENDWHILE;}
if		{printf("lex found if\n"); return IF;}
then		{printf("lex found then\n"); return THEN;}
else		{printf("lex found else\n"); return ELSE;}
endif		{printf("lex found endif\n"); return ENDIF;}
[a-z]+          {printf ("lex found variable\n");
                 // strcpy (varname, yytext);
                  return VAR;
                }
"+"             {printf ("lex found plus\n"); return PLUS; }
"-"		{printf ("lex found minus\n"); return MINUS; }
"="             {printf ("lex found equal\n"); return EQUAL; }
";"             {printf ("lex found semi\n"); return SEMI; }
"<"		{printf("lex found less than\n"); return LT;}
"<="		{printf("lex found less than or equal to\n"); return LTEQ;}
">"             {printf("lex found greater than\n"); return GT;}
">="            {printf("lex found greater than or equal to\n"); return GTEQ;}
"<>"            {printf("lex found spaceship\n"); return SPACESHIP;}
"=="            {printf("lex found equal to\n"); return EQ;}
[0-9]+		{printf("lex found num\n");return NUM;}
.               ;
\n              ;

%%
