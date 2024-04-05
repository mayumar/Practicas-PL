/**************************** pseudocodigo.l ***********************************/
/***** Zona de las declaraciones o definiciones *****/
%{
   /* Descripcion
      Codificacion de un AFD que simula el funcionamiento basico de un automovil

      Nota:  permite leer desde un fichero y escribir la salida en otro fichero

   */

/* Fichero que contiene la declaracion de los componentes lexicos o tokens */

/* Variables globales */


%}

%option case-insensitive

/* Definiciones regulares */

letra             [a-záéíóú]
digito            [0-9]
guion             _

identificador     {letra}({letra}|{digito}|{guion}({letra}|{digito}))*

entero            [0-9]+
real              [0-9]+\.[0-9]+
not_cient         [0-9]+(\.[0-9]*)?([eE][+-]?[0-9]+)?

cadena            \'([^'\\]|\\.)*\'

/* Definicion de estados */

%x COMENTARIO_LARGO COMENTARIO_CORTO

/***** Zona de las reglas *****/
%%

inicio                  {fprintf(yyout, "\n Palabra reservada reconocida: %s \n", yytext);}
fin                     {fprintf(yyout, "\n Palabra reservada reconocida: %s \n", yytext);}
leer                    {fprintf(yyout, "\n Palabra reservada reconocida: %s \n", yytext);}
escribir                {fprintf(yyout, "\n Palabra reservada reconocida: %s \n", yytext);}
si                      {fprintf(yyout, "\n Palabra reservada reconocida: %s \n", yytext);}
entonces                {fprintf(yyout, "\n Palabra reservada reconocida: %s \n", yytext);}
si_no                   {fprintf(yyout, "\n Palabra reservada reconocida: %s \n", yytext);}
fin_si                  {fprintf(yyout, "\n Palabra reservada reconocida: %s \n", yytext);}
mientras                {fprintf(yyout, "\n Palabra reservada reconocida: %s \n", yytext);}
hacer                   {fprintf(yyout, "\n Palabra reservada reconocida: %s \n", yytext);}
fin_mientras            {fprintf(yyout, "\n Palabra reservada reconocida: %s \n", yytext);}
repetir                 {fprintf(yyout, "\n Palabra reservada reconocida: %s \n", yytext);}
hasta_que               {fprintf(yyout, "\n Palabra reservada reconocida: %s \n", yytext);}
para                    {fprintf(yyout, "\n Palabra reservada reconocida: %s \n", yytext);}
desde                   {fprintf(yyout, "\n Palabra reservada reconocida: %s \n", yytext);}
hasta                   {fprintf(yyout, "\n Palabra reservada reconocida: %s \n", yytext);}
paso                    {fprintf(yyout, "\n Palabra reservada reconocida: %s \n", yytext);}
fin_para                {fprintf(yyout, "\n Palabra reservada reconocida: %s \n", yytext);}

{identificador}         {fprintf(yyout, "\n Identificador reconocido: %s \n", yytext);}

{entero}                {fprintf(yyout, "\n Numero reconocido: %s \n", yytext);}
{real}                  {fprintf(yyout, "\n Numero reconocido: %s \n", yytext);}
{not_cient}             {fprintf(yyout, "\n Numero reconocido: %s \n", yytext);}

{cadena}                {fprintf(yyout, "\n Cadena reconocida: %s \n", yytext);}

:=                      {fprintf(yyout, "\n Asignacion reconocida: %s \n", yytext);}
\+=                     {fprintf(yyout, "\n Asignacion reconocida: %s \n", yytext);}
\-=                     {fprintf(yyout, "\n Asignacion reconocida: %s \n", yytext);}
\*=                     {fprintf(yyout, "\n Asignacion reconocida: %s \n", yytext);}
\/=                     {fprintf(yyout, "\n Asignacion reconocida: %s \n", yytext);}

\+                      {fprintf(yyout, "\n Suma reconocida: %s \n", yytext);}
\+\+                    {fprintf(yyout, "\n Incremento reconocido: %s \n", yytext);}
\-                      {fprintf(yyout, "\n Resta reconocida: %s \n", yytext);}
\-\-                    {fprintf(yyout, "\n Decremento reconocido: %s \n", yytext);}
\*                      {fprintf(yyout, "\n Producto reconocido: %s \n", yytext);}
\/                      {fprintf(yyout, "\n Division reconocida: %s \n", yytext);}
\/\/                    {fprintf(yyout, "\n Division entera reconocida: %s \n", yytext);}
%                       {fprintf(yyout, "\n Modulo reconocido: %s \n", yytext);}
\*\*                    {fprintf(yyout, "\n Potencia reconocida: %s \n", yytext);}

\|\|                    {fprintf(yyout, "\n Concatenacion reconocida: %s \n", yytext);}

\<                      {fprintf(yyout, "\n Menor que reconocido: %s \n", yytext);}
\<=                     {fprintf(yyout, "\n Menor o igual que reconocido: %s \n", yytext);}
\>                      {fprintf(yyout, "\n Mayor que reconocido: %s \n", yytext);}
\>=                     {fprintf(yyout, "\n Mayor o igula que reconocido: %s \n", yytext);}
==                      {fprintf(yyout, "\n Igual que reconocido: %s \n", yytext);}
\<\>                    {fprintf(yyout, "\n Distinto que reconocido: %s \n", yytext);}

\<\<                    {BEGIN COMENTARIO_LARGO; fprintf(yyout, "\n Comienza comentario \n");}

<COMENTARIO_LARGO>\>\>  {BEGIN INITIAL; fprintf(yyout, "\n Fin del comentario \n");}

<COMENTARIO_LARGO>.*    {fprintf(yyout, "\n Comentario reconocido: %s \n", yytext);}

!!                      {BEGIN COMENTARIO_CORTO; fprintf(yyout, "\n Comienza comentario \n");}

<COMENTARIO_CORTO>\n    {BEGIN INITIAL; fprintf(yyout, "\n Termina comentario \n");}

<COMENTARIO_CORTO>.*    {fprintf(yyout, "\n Comentario reconocido: %s \n", yytext);}

%%

/*^#                {fprintf(yyout, "\n Fin del programa \n"); return 0;}*/

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
