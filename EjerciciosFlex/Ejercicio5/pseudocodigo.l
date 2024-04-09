/**************************** pseudocodigo.l ***********************************/
/***** Zona de las declaraciones o definiciones *****/
%{
   /* Descripcion
      Codificacion de un AFD que simula el funcionamiento basico de un automovil

      Nota:  permite leer desde un fichero y escribir la salida en otro fichero

   */

/* Fichero que contiene la declaracion de los componentes lexicos o tokens */

/* Variables globales */

#include "token.h"


%}

%option case-insensitive

/* Definiciones regulares */

letra             [a-záéíóú]
digito            [0-9]
guion             _

id                {letra}({letra}|{digito}|{guion}({letra}|{digito}))*

entero            (-)?[0-9]+
real              (-)?[0-9]+\.[0-9]+
not_cient         (-)?[0-9]+(\.[0-9]+)?([eE][+-]?[0-9]+)?

cadena            \'([^'\\]|\\.)*\'

/* Definicion de estados */

%x COMENTARIO_LARGO COMENTARIO_CORTO

/***** Zona de las reglas *****/
%%

inicio                  {fprintf(yyout, "\n Palabra reservada: %s --> token %d \n", yytext, INICIO);}
fin                     {fprintf(yyout, "\n Palabra reservada: %s --> token %d \n", yytext, FIN);}
leer                    {fprintf(yyout, "\n Palabra reservada: %s --> token %d \n", yytext, LEER);}
escribir                {fprintf(yyout, "\n Palabra reservada: %s --> token %d \n", yytext, ESCRIBIR);}
si                      {fprintf(yyout, "\n Palabra reservada: %s --> token %d \n", yytext, SI);}
entonces                {fprintf(yyout, "\n Palabra reservada: %s --> token %d \n", yytext, ENTONCES);}
si_no                   {fprintf(yyout, "\n Palabra reservada: %s --> token %d \n", yytext, SI_NO);}
fin_si                  {fprintf(yyout, "\n Palabra reservada: %s --> token %d \n", yytext, FIN_SI);}
mientras                {fprintf(yyout, "\n Palabra reservada: %s --> token %d \n", yytext, MIENTRAS);}
hacer                   {fprintf(yyout, "\n Palabra reservada: %s --> token %d \n", yytext, HACER);}
fin_mientras            {fprintf(yyout, "\n Palabra reservada: %s --> token %d \n", yytext, FIN_MIENTRAS);}
repetir                 {fprintf(yyout, "\n Palabra reservada: %s --> token %d \n", yytext, REPETIR);}
hasta_que               {fprintf(yyout, "\n Palabra reservada: %s --> token %d \n", yytext, HASTA_QUE);}
para                    {fprintf(yyout, "\n Palabra reservada: %s --> token %d \n", yytext, PARA);}
desde                   {fprintf(yyout, "\n Palabra reservada: %s --> token %d \n", yytext, DESDE);}
hasta                   {fprintf(yyout, "\n Palabra reservada: %s --> token %d \n", yytext, HASTA);}
paso                    {fprintf(yyout, "\n Palabra reservada: %s --> token %d \n", yytext, PASO);}
fin_para                {fprintf(yyout, "\n Palabra reservada: %s --> token %d \n", yytext, FIN_PARA);}

{id}                    {fprintf(yyout, "\n Identificador: %s --> token %d \n", yytext, ID);}

{id}?__{id}?            {fprintf(yyout, "\n Error en el identificador: %s --> No puede tener dos subrayados seguidos \n", yytext);}
(_|{digito}){id}        {fprintf(yyout, "\n Error en el identificador: %s --> Debe comenzar por una letra \n", yytext);}
{id}_                   {fprintf(yyout, "\n Error en el identificador: %s --> No puede acabar en subrayado \n", yytext);}

{entero}                {fprintf(yyout, "\n Numero (entero): %s --> token %d \n", yytext, NUMERO);}
{real}                  {fprintf(yyout, "\n Numero (real): %s --> token %d \n", yytext, NUMERO);}
{not_cient}             {fprintf(yyout, "\n Numero (notac. cient.): %s --> token %d \n", yytext, NUMERO);}

{entero}\.               {fprintf(yyout, "\n Error en el numero: %s --> Falta la parte decimal \n", yytext);}

{cadena}                {yytext[yyleng-1] = '\0'; yytext++; yyleng--;
                         fprintf(yyout, "\n Cadena: <%s> \n", yytext);}

:=                      {fprintf(yyout, "\n Asignacion: %s --> token %d \n", yytext, ASIGNACION);}
\+=                     {fprintf(yyout, "\n Asignacion con suma: %s --> token %d \n", yytext, ASIGNACIONSUMA);}
\-=                     {fprintf(yyout, "\n Asignacion con resta: %s --> token %d \n", yytext, ASIGNACIONRESTA);}
\*=                     {fprintf(yyout, "\n Asignacion con producto: %s --> token %d \n", yytext, ASIGNACIONPRODUCTO);}
\/=                     {fprintf(yyout, "\n Asignacion con división: %s --> token %d \n", yytext, ASIGNACIONDIVISION);}

\+                      {fprintf(yyout, "\n Suma: %s --> token %d \n", yytext, SUMA);}
\+\+                    {fprintf(yyout, "\n Incremento: %s --> token %d \n", yytext, INCREMENTO);}
\-                      {fprintf(yyout, "\n Resta: %s --> token %d \n", yytext, RESTA);}
\-\-                    {fprintf(yyout, "\n Decremento: %s --> token %d \n", yytext, DECREMENTO);}
\*                      {fprintf(yyout, "\n Producto: %s --> token %d \n", yytext, PRODUCTO);}
\/                      {fprintf(yyout, "\n Division: %s --> token %d \n", yytext, DIVISION);}
\/\/                    {fprintf(yyout, "\n Division entera: %s --> token %d \n", yytext, DIVISION_ENTERA);}
%                       {fprintf(yyout, "\n Modulo: %s --> token %d \n", yytext, MODULO);}
\*\*                    {fprintf(yyout, "\n Potencia: %s --> token %d \n", yytext, POTENCIA);}

\|\|                    {fprintf(yyout, "\n Concatenacion: %s --> token %d \n", yytext, CONCATENACION);}

#o                      {fprintf(yyout, "\n Disyuncion logica: %s --> token %d \n", yytext, DISYUNCION_LOGICA);}
#y                      {fprintf(yyout, "\n Conjuncion logica: %s --> token %d \n", yytext, CONJUNCION_LOGICA);}
#no                     {fprintf(yyout, "\n Negacion logica: %s --> token %d \n", yytext, NEGACION_LOGICA);}

\<                      {fprintf(yyout, "\n Menor que: %s --> token %d \n", yytext, MENOR_QUE);}
\<=                     {fprintf(yyout, "\n Menor o igual que: %s --> token %d \n", yytext, MENOR_IGUAL_QUE);}
\>                      {fprintf(yyout, "\n Mayor que: %s --> token %d \n", yytext, MAYOR_QUE);}
\>=                     {fprintf(yyout, "\n Mayor o igula que: %s --> token %d \n", yytext, MAYOR_IGUAL_QUE);}
==                      {fprintf(yyout, "\n Igual que: %s --> token %d \n", yytext, IGUAL);}
\<\>                    {fprintf(yyout, "\n Distinto que: %s --> token %d \n", yytext, DISTINTO);}

;                       {fprintf(yyout, "\n Fin de sentencia: %s --> token %d \n", yytext, FIN_SENTENCIA);}
\(                      {fprintf(yyout, "\n Parentesis izquierdo: %s --> token %d \n", yytext, PARENTESIS_IZQUIERDO);}
\)                      {fprintf(yyout, "\n Parentesis derecho: %s --> token %d \n", yytext, PARENTESIS_DERECHO);}

\<\<                    {BEGIN COMENTARIO_LARGO; fprintf(yyout, "\n Comienza comentario multilinea: %s --> token %d \n", yytext, COMENTARIO_ML_ABRE);}

<COMENTARIO_LARGO>\>\>  {BEGIN INITIAL; fprintf(yyout, "\n Fin del comentario multilinea: %s --> token %d \n", yytext, COMENTARIO_ML_CIERRA);}

<COMENTARIO_LARGO>.*    {fprintf(yyout, "\n Comentario multilinea: <%s> \n", yytext);}

!!                      {BEGIN COMENTARIO_CORTO; fprintf(yyout, "\n Comienza comentario una linea: %s --> token %d \n", yytext, COMENTARIO_UNALINEA);}

<COMENTARIO_CORTO>\n    {BEGIN INITIAL; fprintf(yyout, "\n Termina comentario una linea \n");}

<COMENTARIO_CORTO>.*    {fprintf(yyout, "\n Comentario una linea: <%s> \n", yytext);}

%%

/***** Zona de funciones auxiliares *****/

extern FILE *yyin, *yyout;

int main(int argc, char *argv[])
{
 
 switch(argc)
  {
   case 2:
      yyin=fopen(argv[1],"r");

      if(yyin == NULL){
         printf("\n Error, El fichero de entrada no existe \n");
         return -1;
      }

      break;

   case 3:
      yyin=fopen(argv[1],"r");

      if(yyin == NULL){
         printf("\n Error, El fichero de entrada no existe \n");
         return -1;
      }

      yyout=fopen(argv[2],"r");

      if(yyin != NULL){
         printf("\n Error, El fichero de salida ya existe \n");
         return -1;
      }else{
         yyout=fopen(argv[2],"w");
      }

  }
  yylex();

  return 0;
}
