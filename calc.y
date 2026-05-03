/* Parser para uma calculadora avancada */
%{
#include <stdio.h>
#include <stdlib.h>
#include "calc.h"
%}

%union {
    struct ast *a;
    double d;
    struct symbol *s;
    struct symlist *sl;
    int fn; /* qual funcao? */
}

/* declaracao de tokens */
%token <d> NUMBER
%token <s> NAME
%token <fn> FUNC
%token EOL

%token IF THEN ELSE WHILE DO LET FOR

/* Ordem: Da MENOR prioridade para a MAIOR prioridade */
%right '='
%left <fn> LOGIC /* && e || resolvem depois de comparar */
%nonassoc <fn> CMP /* ==, >, < resolvem depois da matematica */
%left '+' '-'
%left '*' '/'
%right UMINUS   /* Precedencia do menos unario (alta prioridade) */

%type <a> exp stmt list explist init
%type <sl> symlist

%precedence THEN
%precedence ELSE

%start calclist

%%

stmt: IF exp THEN list { $$ = newflow('I', $2, $4, NULL); }
    | IF exp THEN list ELSE list { $$ = newflow('I', $2, $4, $6); }
    | WHILE exp DO list { $$ = newflow('W', $2, $4, NULL); }
    | FOR '(' init ';' exp ';' exp ')' list { $$ = newforloop('P', $3, $5, $7, $9); }
    | exp
    ;

list: /* vazio! */ { $$ = NULL; }
    | ';' { $$ = NULL; } /* Aceita corpo de laco vazio */
    | stmt ';' list { if ($3 == NULL) $$ = $1; else $$ = newast('L', $1, $3); }
    ;

exp: exp CMP exp { $$ = newcmp($2, $1, $3); }
   | exp '+' exp { $$ = newast('+', $1, $3); }
   | exp '-' exp { $$ = newast('-', $1, $3); }
   | exp '*' exp { $$ = newast('*', $1, $3); }
   | exp '/' exp { $$ = newast('/', $1, $3); }
   | '-' exp %prec UMINUS { $$ = newast('-', newnum(0.0), $2); } /* Transforma -k em 0 - k na AST, para aceitar numeros negativos*/
   | exp LOGIC exp { $$ = newlogic($2, $1, $3); }
   | '(' exp ')' { $$ = $2; }
   | NUMBER      { $$ = newnum($1); }
   | NAME        { $$ = newref($1); }
   | init
   | FUNC '(' explist ')' { $$ = newfunc($1, $3); }
   | NAME '(' explist ')' { $$ = newcall($1, $3); }
   ;

init: NAME '=' exp { $$ = newasgn($1, $3); }
    ;

explist: exp
       | exp ',' explist { $$ = newast('L', $1, $3); }
       ;

symlist: NAME { $$ = newsymlist($1, NULL); }
       | NAME ',' symlist { $$ = newsymlist($1, $3); }
       ;

calclist: /* vazio! */
        | calclist EOL { printf("> "); } /* Ignora \n soltos */
        | calclist stmt EOL {
            double res = eval($2);
            /* Verifica se o no eh a funcao print */
            int is_print = ($2 && $2->nodetype == 'F' && ((struct fncall *)$2)->functype == B_print);
            
            /* Suprime o print de '=' (Atribuicao), 'W' (While), 'P' (For), 'I' (If) e 'L' (Blocos) */
            if($2 && $2->nodetype != '=' && $2->nodetype != 'W' && $2->nodetype != 'P' && $2->nodetype != 'I' && $2->nodetype != 'L' && !is_print) {
                printf("= %4.4g\n", res);
            }
            printf("> ");
            treefree($2);
        }
        | calclist LET NAME '(' symlist ')' '=' list EOL {
            dodef($3, $5, $8);
            printf("Defined %s\n> ", $3->name);
        }
        | calclist error EOL { yyerrok; printf("> "); }
        ;
%%