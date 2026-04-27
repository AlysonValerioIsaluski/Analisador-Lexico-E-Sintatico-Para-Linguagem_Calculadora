# Makefile - Calculadora Avancada

TARGET = calc
CC = gcc

# Dependencia do lib math necessária por conta da funcao B_sqrt, etc
LIBS = -lm

BISON_Y = calc.y
BISON_C = calc.tab.c
BISON_H = calc.tab.h

FLEX_L  = calc.l
FLEX_C  = calc.lex.c

SRC_C   = calc.c

all: $(TARGET)

$(TARGET): $(BISON_C) $(FLEX_C) $(SRC_C)
	$(CC) -o $(TARGET) $(BISON_C) $(FLEX_C) $(SRC_C) $(LIBS)

$(BISON_C) $(BISON_H): $(BISON_Y)
	bison -d $(BISON_Y)

$(FLEX_C): $(FLEX_L) $(BISON_H)
	flex -o $(FLEX_C) $(FLEX_L)

clean:
	rm -f $(BISON_C) $(BISON_H) $(FLEX_C) $(TARGET)