%{
#include <stdio.h>
#include "y.tab.h"
#include <string.h>

//extern char varname[];
%}

%%
while		{return WHILE;}
do		{return DO;}
endwhile	{return ENDWHILE;}
if		{return IF;}
then		{return THEN;}
else		{return ELSE;}
endif		{return ENDIF;}
[a-z]+          {return VAR;}
"+"             {return PLUS; }
"-"		{return MINUS; }
"="             {return EQUAL; }
";"             {return SEMI; }
"<"		{return LT;}
"<="		{return LTEQ;}
">"             {return GT;}
">="            {return GTEQ;}
"<=>"           {return SPACESHIP;}
"=="            {return EQ;}
[0-9]+		{return NUM;}
\n		;
" "		;
.		{return JUNK;}

%%
