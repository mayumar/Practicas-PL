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

/* Variables globales */

int day, month, year;
int total_documentos = 0;
int documentos_por_dia[31] = {0};

%}


/* Definiciones regulares */

dia            0[1-9]|[1-2][0-9]|3[0-1]
mes            0[1-9]|1[0-2]
ano            [0-9]{4}

hora           0[1-9]|1[0-9]|2[0-4]
minuto         [0-5][0-9]

letra          [a-z]
digito         [0-9]
punto          \.
nombre         ({letra}|{digito})+
extension      ({letra}|{digito})+

fecha          {dia}-{mes}-{ano}
tiempo         {hora}:{minuto}
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

<Q1>{tiempo}           {BEGIN Q2; fprintf(yyout, "\n Hora reconocida (Pasamos a Q2) \n");}

<Q2>{documento}\n?     {BEGIN INITIAL; fprintf(yyout, "\n Documento reconocido (Pasamos a Q0) \n");
                        total_documentos++; documentos_por_dia[day]++;}



%%
/*
[^0-9].*\n             {fprintf(yyout,"\n %s ---> Secuencia incorrecta \n", yytext);}

<Q1>[^0-9].*\n         {fprintf(yyout,"\n %s ---> Secuencia incorrecta \n", yytext);}
*/

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