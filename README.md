# Programação Básica - Parser & Scanner

-> **Objetivo:** Implementar análise léxica e sintática de uma calculadora estendida.
-> **Contexto:** Trabalho de Compiladores - 5º Período BCC (UTFPR).
-> **Autores:** Alyson Valerio Isaluski & Atos Aires Arruda.

## 🛠️ Stack Tecnológico
* **Linguagem:** C
* **Léxico:** Flex (Lex)
* **Sintático:** Bison (Yacc)
* **Build:** Make & GCC (Ambiente Linux)

## 📂 Estrutura de Arquivos
* `calc.l` -> Regras léxicas (Tokens e Regex).
* `calc.y` -> Regras sintáticas (Gramática Livre de Contexto / BNF).
* `calc.h` -> Definições compartilhadas.
* `makefile` -> Automação do build.

## ⚙️ Dependências (Debian/Ubuntu/Mint)
```bash
sudo apt install flex bison build-essential libfl-dev
```

## 🚀 Como Compilar e Executar
1. Compilar o projeto:

```bash
make
```

2. Executar o binário gerado:

```bash
./calc
```


## 🧠 Lógica de Funcionamento
1. Input: Usuário digita expressão matemática.

2. Flex (yylex): Quebra string de entrada em Tokens (ex: NUMBER, ADD). Ignora espaços.

3. Bison (yyparse): Valida a ordem dos tokens usando regras gramaticais. Calcula o valor ou aciona yyerror se houver erro de sintaxe.

4. Output: Resultado numérico ou mensagem de erro.
