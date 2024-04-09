/**************************** correo.l ***********************************/
/***** Zona de las declaraciones o definiciones *****/
%{
   /* Descripcion
      El analizador léxico reconoce correos electronicos con la estructura usuario@entidad.ext

      Nota:  permite leer desde un fichero y escribir la salida en otro fichero

   */

/* Fichero que contiene la declaracion de los componentes lexicos o tokens */

/* Variables globales */
int correctas = 0;

%}


/* Definiciones regulares */

espacio         [ \t\n]
letra           [a-zA-Z]
numero          [0-9]
punto           \.
guion           _

espacios        {espacio}+
usuario         {letra}({letra}|{numero}|{punto}|{guion}({letra}|{numero}|{punto}))*
entidad         {letra}+
ext             {letra}{2,3}
correo          {usuario}@{entidad}\.{ext}

/***** Zona de las reglas *****/
%%

{espacios}          { /* Se descartan los espacios en blanco */ ; }

{correo}            {fprintf(yyout,"\n %s ---> Correo correcto \n", yytext); correctas++;}

^#                  {fprintf(yyout,"\n Fin del programa \n"); return 0;}

.*                  {fprintf(yyout,"\n %s ---> Correo incorrecto \n", yytext);}
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

  fprintf(yyout, "\n Contador de correos correctos: %d \n", correctas);

  return 0;
}
