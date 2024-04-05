#include <stdio.h>
#include <stdlib.h> /* Uso de malloc */
#include <string.h>

#include "token.h"

/* 
	Se declara lista_palabra como una variable estaática y global 
	para contener las palabras que se declaren 
*/
static struct Ficha_palabra *lista_palabra;


/*
  Código de las funciones auxiliares
*/ 

int poner_palabra(int tipo, char *palabra)
{
	struct Ficha_palabra *p;	

	if(buscar_palabra(palabra) != BUSCAR) 
	{
		/* Si la palabra está definida previamente, termina la función */
		return 0;
	}
	/* Se introduce la nueva palabra en la lista de palabras */
	else
	{
		p = (struct Ficha_palabra *) malloc(sizeof(struct Ficha_palabra));

		p->siguiente = lista_palabra;
		p->palabra_nombre = (char *) malloc(strlen(palabra)+1);
		strcpy(p->palabra_nombre, palabra);
		p->palabra_tipo = tipo;
		lista_palabra = p;
		return 1;	
	}
}

int buscar_palabra(char *palabra)
{
	/* La variable "p" se utiliza para recorrer la lista de palabras */
	struct Ficha_palabra *p = lista_palabra;

	/* Se busca la palabra recorriendo la lista simple */
	for(; p; p = p->siguiente) 
	{
		if(strcmp(p->palabra_nombre, palabra) == 0)
			/* Se devuelve el tipo de la palbra encontrada */
			return p->palabra_tipo;
	}

	/* Palabra no encontrada */
	return BUSCAR;	
}
