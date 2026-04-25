%option noyywrap nodefault yylineno
%{
    #include "calc.h"
    #include "calc.tab.h"
%}

%%
"+" { return ADD; }
"-" { return SUB; }
"*" { return MUL; }
"/" { return DIV; }
[0-9]+ { yylval = atoi(yytext); return NUMBER; }
"\n" { return EOL; }
[ \t] {/* ignora espaço em branco */}
. {printf("Caracter nao reconhecido: %c\n", *yytext); }

%%