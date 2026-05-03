# Programação Básica - Parser & Scanner

-> **Objetivo:** Implementar análise léxica, sintática, construção de AST e Tabela de Símbolos para uma calculadora estendida.
-> **Contexto:** Trabalho de Compiladores - 5º Período BCC (UTFPR).
-> **Autores:** Alyson Valerio Isaluski & Atos Aires Arruda.

## 🛠️ Stack Tecnológico
* **Linguagem:** C
* **Léxico:** Flex (Lex)
* **Sintático:** Bison (Yacc)
* **Build:** Make & GCC (Ambiente Linux)

## 📂 Estrutura de Arquivos
* `calc.l` -> Regras léxicas (Tokens, Regex e registro de referências).
* `calc.y` -> Regras sintáticas (Gramática BNF e montagem da AST).
* `calc.h` -> Definições compartilhadas (Estruturas da Árvore, Tabela de Símbolos e assinaturas).
* `calc.c` -> Lógica central (Avaliação da AST, Hashing, controle de escopo e manipulação de I/O).
* `makefile` -> Automação de compilação.

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

-> Modo Interativo (Lê do terminal, escreve no terminal):

```bash
./calc
```

-> Modo Lote Padrão (Lê de arquivo, exporta para out.txt):

```bash
./calc <arquivo_entrada>
```

-> Modo Lote Customizado (Lê de arquivo, exporta para arquivo específico):

```bash
./calc <arquivo_entrada> <arquivo_saida>
```


## 🧠 Lógica de Funcionamento
1. I/O Management: Redirecionamento dinâmico de yyin (entrada) e stdout via freopen (saída).

2. Scanner (Flex): Converte a stream de caracteres em Tokens (NUMBER, NAME, FOR, etc.). Ignora espaços e comentários.

3. Tabela de Símbolos: Armazena identificadores via Hashing (symhash) com tentativa linear. Mantém estado de inicialização e histórico de referências físicas (arquivo e linha).

4. Parser (Bison): Valida a gramática e constrói a AST (Abstract Syntax Tree) alocando nós dinamicamente para cada instrução.

5. Avaliação (eval): Percorre a AST em profundidade. Executa cálculos, gerencia fluxo (if/while/for), invoca funções customizadas lidando com escopo de variáveis e acusa erros de lógica (ex: variável não inicializada).

6. Output: Imprime os resultados das expressões e, ao final da execução, realiza o dump da Tabela de Símbolos no arquivo/console de destino.