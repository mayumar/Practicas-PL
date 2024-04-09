/**************************** impresora.l ***********************************/
/***** Zona de las declaraciones o definiciones *****/
%{
   /* Descripcion
      El analizador léxico reconoce correos electronicos con la estructura usuario@entidad.ext

      Nota:  permite leer desde un fichero y escribir la salida en otro fichero

   */

/* Fichero que contiene la declaracion de los componentes lexicos o tokens */
#include <string.h>
#include <stdbool.h>

bool fechaValida(int day, int month, int year);
bool horaValida(const char *hora);

/* Variables globales */

int day, month, year;
int total_documentos = 0;
int documentos_por_dia[31] = {0};

%}


/* Definiciones regulares */

dia            0[1-9]|[1-2][0-9]|3[0-1]
mes            0[1-9]|1[0-2]
ano            [0-9]{4}

letra          [a-z]
digito         [0-9]
punto          \.
nombre         ({letra}|{digito})+
extension      ({letra}|{digito})+

fecha          {dia}-{mes}-{ano}
hora           [0-9][0-9]:[0-9][0-9]
documento      {nombre}{punto}{extension}


/* Definicion de estados */

%x Q1 Q2


/***** Zona de las reglas *****/
%%

{fecha}                {sscanf(yytext, "%d-%d-%d", &day, &month, &year);
                        if(fechaValida(day, month, year)){
                           BEGIN Q1;
                           fprintf(yyout, "\n Fecha reconocida (Pasamos a Q1) \n");
                        }else{
                           BEGIN INITIAL;
                           fprintf(yyout, "\n Fecha erronea (Vuelve al estado inicial) \n");
                        }}

<Q1>\ {hora}             {BEGIN Q2;
                        if(horaValida(yytext)){
                           fprintf(yyout, "\n Hora reconocida (Pasamos a Q2) \n");
                        }else{
                           BEGIN INITIAL;
                           fprintf(yyout, "\n Hora erronea (Vuelve al estado inicial) \n");
                        }}

<Q2>\ {documento}\n?     {BEGIN INITIAL; fprintf(yyout, "\n Documento reconocido (Pasamos a Q0) \n");
                        total_documentos++; documentos_por_dia[day]++;}

[^0-9].*\n             {fprintf(yyout,"\n Secuencia incorrecta --> %s \n", yytext);}

<Q1>[^0-9\ ].*\n       {fprintf(yyout, "\n Secuencia incorrecta (Vuelve al estado inicial) --> %s \n", yytext); BEGIN INITIAL;}

<Q2>.*               {fprintf(yyout, "\n Secuencia incorrecta (Vuelve al estado inicial) --> %s \n", yytext); BEGIN INITIAL;}

.|\n {}

%%
/*

*/

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

  fprintf(yyout, "\n Se han reconocido %d documentos \n", total_documentos);

   int dias_con_documentos = 0;
   int total_documentos_diarios = 0;
   int i;
   for (i = 0; i < 31; i++) {
      if (documentos_por_dia[i] > 0) {
         dias_con_documentos++;
         total_documentos_diarios += documentos_por_dia[i];
      }
   }

   double promedio_documentos_diarios = total_documentos_diarios / (double)dias_con_documentos;

   printf("El número medio de documentos diarios es: %.2lf\n", promedio_documentos_diarios);

  return 0;
}

bool fechaValida(int day, int month, int year){

   switch(month){
      case 2:
         if((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)){
            return day <= 29;
         }else{
            return day <= 28;
         }
      
      case 4:
         return day <= 30;

      case 6:
         return day <= 30;
      
      case 9:
         return day <= 30;

      case 11:
         return day <= 30;

      default:
         return day <= 31;
   }
}

bool horaValida(const char *hora){
    int hour, minute;

    if (sscanf(hora, "%d:%d", &hour, &minute) != 2)
        return false;

    if (hour < 0 || hour > 23 || minute < 0 || minute > 59)
        return false;

    return true;
}