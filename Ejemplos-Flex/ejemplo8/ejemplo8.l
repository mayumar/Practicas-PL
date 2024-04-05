/**************************** ejemplo8.l ***********************************/
/***** Zona de las declaraciones o definiciones *****/
%{
   /* Descripcion
      El analizador léxico reconoce algunos componentes léxicos de un lenguaje de programación

   */

/* Fichero que contiene la declaracion de los componentes lexicos o tokens */
#include "token.h"   

%}
/* 
  Si se desar no distinguir mayúsculas de minúsculas: 
  1) Versiones anteriores a flex 2.6.4 
     (?i:texto) 
  2) Versión  flex 2.6.4 
    %option case-insensitive 
*/


/* Definiciones regulares */

espacio        [ \t\n]
espacios       {espacio}+
letra          [a-zA-Z]
digito         [0-9]
identificador  {letra}({letra}|{digito})*
numero         {digito}+(\.{digito}+)?(E[+\-]?{digito}+)?

/***** Zona de las reglas *****/
%%

{espacios}	      { /* Se descartan los espacios en blanco */ ; }

if                {printf("Palabra reservada: %s --> token %d\n", yytext,IF);}

then		         {printf("Palabra reservada: %s --> token %d\n", yytext,THEN);}

else              {printf("Palabra reservada: %s --> token %d\n", yytext,ELSE);}

{identificador}   {printf("Identificador: %s --> token %d\n", yytext, ID);}

{numero}          {printf("Numero: %s --> token %d\n", yytext, NUMERO);}

">"               {printf("Operador relacional: %s --> token %d\n", yytext, MAYOR_QUE);}
">="              {printf("Operador relacional: %s --> token %d\n", yytext, MAYOR_IGUAL);}

^#                {printf("Fin del programa \n"); return 0;}

.                 {ECHO; putchar('\n'); /* Se muestra el carácter por pantalla, pero no se indica nada. */ }
%%


/***** Zona de funciones auxiliares *****/

