/**************************** ejemplo9.l ***********************************/
/***** Zona de las declaraciones o definiciones *****/
%{
   /* Descripcion
      El analizador léxico reconoce algunos componentes léxicos de un lenguaje de programación

      Nota:  permite leer desde un fichero y escribir la salida en otro fichero

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

{espacios}        { /* Se decartan los espacios en blanco */ ; }

if                {fprintf(yyout,"\n Palabra reservada: %s --> token %d\n", yytext,IF);}

then              {fprintf(yyout,"\n Palabra reservada: %s --> token %d\n", yytext,THEN);}

else              {fprintf(yyout,"\n Palabra reservada: %s --> token %d\n", yytext,ELSE);}

{identificador}   {fprintf(yyout,"\n Identificador: %s --> token %d\n", yytext, ID);}

{numero}          {fprintf(yyout,"\n Numero: %s --> token %d\n", yytext,NUMERO);}

">"               {fprintf(yyout,"\n Operador relacional: %s --> token %d\n",
                            yytext,MAYOR_QUE);}
">="              {fprintf(yyout,"\n Operador relacional: %s --> token %d\n",
                            yytext,MAYOR_IGUAL);}

^#                {fprintf(yyout,"\n Fin del programa \n"); return 0;}

.                 { ECHO; fprintf(yyout,"%c",'\n'); /* Se muestra por pantalla, pero no se indica nada */ }
%%


/***** Zona de funciones auxiliares *****/

extern FILE *yyin, *yyout;

int main(int argc, char *argv[])
{
 
 switch(argc)
  {
   case 2:  yyin=fopen(argv[1],"r"); 
            break;
   case 3:  yyin=fopen(argv[1],"r"); 
            yyout=fopen(argv[2],"w"); 
  }
  yylex();

  return 0;
}
