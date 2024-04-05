/*** ejemplo6.l ***/

/*** Zona de las declaraciones o definiciones ***/
%{
   /* Descripción
       El analizador léxico reconoce las palabras y las almacena en una tabla.
       
	Permite definir el tipo de cada palabra. 
        Por ejemplo, si se teclea al principio de la línea
            verbo amar luchar
        define las palabras "amar" y "luchar" como verbos
   */

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
   
/* Variable usada para definir el tipo de las palabras: verbo, adjetivo, etc. */
int tipo; 

/* Prototipos de las funciones auxiliares */
int poner_palabra(int tipo, char *palabra);
int buscar_palabra(char *palabra);
%}

%%
\n	{ tipo = BUSCAR; } /* Fin de línea: vuelve al tipo por defecto */

^verbo	{ tipo = VERBO; } /* Operador ^: solamente se reconoce el patrón al principio de la línea */
^adj	{ tipo = ADJETIVO; }
^adv	{ tipo = ADVERBIO; }
^nombre	{ tipo = NOMBRE; }
^prep	{ tipo = PREPOSICION; }
^pron	{ tipo = PRONOMBRE; }
^conj	{ tipo = CONJUNCION; }

[a-zA-Z]+  {
			/* palabra normal: la define o la busca */
	    	if(tipo != BUSCAR) 
			{	
				/* Muestra un mensaje si la palabra ya estaba definida previamente */
				if (poner_palabra(tipo, yytext) == 0) 
				{
					printf("---> : la palabra <%s> ya está definida\n", yytext);
				}
				/* Muestra un mensaje si se definido una nueva palabra */
				else 
				{
					printf("La palabra <%s> se ha definido como ", yytext);
					switch(tipo) 
					{
						case VERBO: printf("verbo\n"); break;
						case ADJETIVO: printf("adjetivo\n"); break;
						case ADVERBIO: printf("adverbio\n"); break;
						case NOMBRE: printf("nombre\n"); break;
						case PREPOSICION: printf("preposición\n"); break;
						case PRONOMBRE: printf("pronombre\n"); break;
						case CONJUNCION: printf("conjunción\n"); 
					}
				}
	     	} 
		 /* Si el tipo es BUSCAR */
		 else 
		 {
			switch(buscar_palabra(yytext)) 
			{
				case VERBO: printf("%s: verbo\n", yytext); 
							break;
				case ADJETIVO: printf("%s: adjetivo\n", yytext); 
							break;
				case ADVERBIO: printf("%s: adverbio\n", yytext); 
							break;
				case NOMBRE: printf("%s: nombre\n", yytext); 
							break;
				case PREPOSICION: printf("%s: preposición\n", yytext); 
							break;
				case PRONOMBRE: printf("%s: pronombre\n", yytext); 
							break;
				case CONJUNCION: printf("%s: conjunción\n", yytext); 
							break;
				default: 
						printf("%s: no reconocida \n", yytext);
			}
            }
          }

.    ; 	/* Se ignoran el resto de caracteres */ 

%%

#include <stdio.h>
#include <stdlib.h> /* Uso de malloc */
#include <string.h>

/* Se define el tipo de lista enlazada de palabras y tipos */
struct Ficha_palabra 
{
	char *palabra_nombre;
	int palabra_tipo;
	struct Ficha_palabra  *siguiente;
};

/* 
   Se declara lista_palabra como una variable global y estática
   para contener las palabras que se declaren 
*/
static struct Ficha_palabra  *lista_palabra;

int main()
{
	/* Llamada al analizador léxico */
	yylex();

	/* Fin del programa */
	return 0;
}

/******************************************************/
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
