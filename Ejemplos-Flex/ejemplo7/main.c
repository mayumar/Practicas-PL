#include <stdio.h>
#include <stdlib.h> /* Uso de malloc */
#include <string.h>

#include "token.h"


int main()
{
	/* Llamada al analizador léxico */
	yylex();

	/* Fin del programa */
	return 0;
}
