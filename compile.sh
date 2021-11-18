yacc -d project.yacc
lex project.lex
cc y.tab.c lex.yy.c -ll
