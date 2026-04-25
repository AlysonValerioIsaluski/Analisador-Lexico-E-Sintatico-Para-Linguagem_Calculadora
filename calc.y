/* parser da calculadora*/
%{
    #include <stdio.h>
    #include "calc.h"

    int yylex(void);
    void yyerror(char *s);
%}

/* declaracao de tokens */
%token NUMBER
%token ADD SUB MUL DIV
%token EOL

%%

calclist: /* empty */
        | calclist exp EOL { printf("= %d\n", $2); } /* EOL end of an expression */
        ;

exp: factor /* default $$ = $1 */
   | exp ADD factor { $$ = $1 + $3; }
   | exp SUB factor { $$ = $1 - $3; }
   ;

factor: term /* default $$ = $1 */
      | factor MUL term { $$ = $1 * $3; }
      | factor DIV term { $$ = $1 / $3; }
      ;

term: NUMBER ; /* default $$ = $1 */

%%

/* Funções C obrigatórias */
void yyerror(char *s) {
    fprintf(stderr, "Erro sintático: %s\n", s);
}

int main() {
    /* yyparse chama o yylex internamente e inicia a análise sintática */
    yyparse();
    return 0;
}