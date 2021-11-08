%{
#include <stdio.h>
#include "y.tab.h"
#include <string.h>

//extern char varname[];
%}

%%
while		{printf("WHILE\n"); return WHILE;}
do		{printf("DO\n");return DO;}
endwhile	{printf("ENDWHILE\n"); return ENDWHILE;}
if		{printf("IF\n"); return IF;}
then		{printf("THEN\n"); return THEN;}
else		{printf("ELSE\n"); return ELSE;}
endif		{printf("ENDIF\n"); return ENDIF;}
[a-z]+          {printf ("VAR\n");
                 // strcpy (varname, yytext);
                  return VAR;
                }
"+"             {printf ("PLUS\n"); return PLUS; }
"-"		{printf ("MINUS\n"); return MINUS; }
"="             {printf ("EQUAL\n"); return EQUAL; }
";"             {printf ("SEMI\n"); return SEMI; }
"<"		{printf("LT\n"); return LT;}
"<="		{printf("LTEQ\n"); return LTEQ;}
">"             {printf("GT\n"); return GT;}
">="            {printf("GTEQ\n"); return GTEQ;}
"<>"            {printf("SPACESHIP\n"); return SPACESHIP;}
"=="            {printf("EQ\n"); return EQ;}
[0-9]+		{printf("NUM\n");return NUM;}
\n		;
" "		;
.		{printf("JUNK\n"); return JUNK;}

%%
