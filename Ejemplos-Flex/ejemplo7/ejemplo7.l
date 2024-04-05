/**************************** ejemplo7.l ***********************************/

/***** Zona de las declaraciones o definiciones *****/
%{
	
	/*
	 Nota: este ejemplo es similar al ejemplo6 pero utiliza varios ficheros para tener más modularidad. 
	 
	 Descripción:
       El analizador léxico reconoce las palabras y las almacena en una tabla de palabras reconocidas.
       Se utiliza el fichero "main.c" para codificar el programa principal y las funciones de la tabla de palabras reconocidas
       
	Permite definir el tipo de cada palabra. 
        Por ejemplo, si se teclea al principio de la línea
        verbo amar luchar
        define las palabras "amar" y "luchar" como verbos
   */

#include "token.h"

/* Variable usada para definir el tipo de las palabras: verbo, adjetivo, etc. */
int tipo; 

%}

%%
\n	{ tipo = BUSCAR; } /* Fin de línea: vuelve al tipo por defecto */

^verbo	{ tipo = VERBO; }
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
					printf("---> : la palabra %s ya está definida\n", yytext);
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
						printf("%s:  no reconocida \n", yytext);
			}
            }
          }

.    ; 	/* Se ignoran el resto de caracteres */ 

%%
