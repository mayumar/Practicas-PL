#ifndef _TOKEN_H_
#define _TOKEN_H_

/* Tipos de las palabras */
enum {
	BUSCAR = 0, /* Tipo por defecto. */
	VERBO,
	ADJETIVO,
	ADVERBIO,
	NOMBRE,
	PREPOSICION,
	PRONOMBRE,
	CONJUNCION
};

/* Se define el tipo de lista enlazada de palabras y tipos */
struct Ficha_palabra 
{
	char *palabra_nombre;
	int palabra_tipo;
	struct Ficha_palabra *siguiente;
};

int yylex();

int poner_palabra(int tipo, char *palabra);
int buscar_palabra(char *palabra);

#endif /*  _TOKEN_H_ */
