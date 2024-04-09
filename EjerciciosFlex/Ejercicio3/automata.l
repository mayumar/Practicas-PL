/**************************** automata.l ***********************************/
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

/* Definicion de estados */

%x Q1 Q2


/***** Zona de las reglas *****/
%%

encender             {BEGIN Q1; fprintf(yyout, "\n Encendiendo (Pasamos a Q1) \n");}

<Q1>acelerar         {fprintf(yyout, "\n Acelerando (Seguimos en Q1) \n");}

<Q1>frenar           {fprintf(yyout, "\n Frenando (Seguimos en Q1) \n");}

<Q1>embragar         {BEGIN Q2; fprintf(yyout, "\n Embragando (Pasamos a Q2) \n");}

<Q1>apagar           {BEGIN INITIAL; fprintf(yyout, "\n Apagando (Pasamos a Q0) \n");}

<Q2>frenar           {fprintf(yyout, "\n Frenando (Seguimos en Q2) \n");}

<Q2>cambiar          {BEGIN Q1; fprintf(yyout, "\n Cambiando marcha (Pasamos a Q1) \n");}

.*                   {fprintf(yyout,"\n %s ---> Secuencia incorrecta \n", yytext);}

<Q1>.*               {fprintf(yyout,"\n %s ---> Secuencia incorrecta \n", yytext);}

<Q2>.*               {fprintf(yyout,"\n %s ---> Secuencia incorrecta \n", yytext);}
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
