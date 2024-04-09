/**************************** figura.l ***********************************/
/***** Zona de las declaraciones o definiciones *****/
%{
   /* Descripcion
      El analizador léxico reconoce figuras geometricas

      Nota:  permite leer desde un fichero y escribir la salida en otro fichero

   */

/* Fichero que contiene la declaracion de los componentes lexicos o tokens */

#include <string.h>
#include <math.h>

float calcularArea(float coords[], int tipo);
float calcularPerimetro(float coords[], int tipo);

/* Variables globales */

enum TIPO{
  TRIANGULO,
  CUADRADO,
  CIRCULO
};

float coordenadas[6] = {0.0};

int triangulos = 0;
int cuadrados = 0;
int circulos = 0;

%}

%option case-insensitive


/* Definiciones regulares */

numero          [0-9]+(\.[0-9]*)?([eE][+-]?[0-9]+)?
coordenada      \({numero}\ {numero}\)

cuadrado        cuadrado\ {coordenada}\ {coordenada}
triangulo       tri(a|á)ngulo\ {coordenada}\ {coordenada}\ {coordenada}
circulo         c(i|í)rculo\ {coordenada}\ {numero}

/*   Definicion de estados   */

/***** Zona de las reglas *****/
%%

{triangulo}                {fprintf(yyout, "\n Triangulo reconocido \n");
                            triangulos++;
                            if(sscanf(yytext, "triángulo (%f %f) (%f %f) (%f %f)", &(coordenadas[0]), &(coordenadas[1]),
                                      &(coordenadas[2]), &(coordenadas[3]), &(coordenadas[4]), &(coordenadas[5])) == 0){
                              sscanf(yytext, "triangulo (%f %f) (%f %f) (%f %f)", &(coordenadas[0]), &(coordenadas[1]),
                                     &(coordenadas[2]), &(coordenadas[3]), &(coordenadas[4]), &(coordenadas[5]));
                            }
                            float area = calcularArea(coordenadas, TRIANGULO);
                            fprintf(yyout, "\n Area del triangulo: %f", area);
                            float perimetro = calcularPerimetro(coordenadas, TRIANGULO);
                            fprintf(yyout, "\n Perimetro del triangulo: %f \n", perimetro);}

^{cuadrado}                 {fprintf(yyout, "\n Cuadrado reconocido \n");
                            cuadrados++;
                            sscanf(yytext, "cuadrado (%f %f) (%f %f)", &(coordenadas[0]), &(coordenadas[1]),
                                   &(coordenadas[2]), &(coordenadas[3]));
                            float area = calcularArea(coordenadas, CUADRADO);
                            fprintf(yyout, "\n Area del cuadrado: %f", area);
                            float perimetro = calcularPerimetro(coordenadas, CUADRADO);
                            fprintf(yyout, "\n Perimetro del cuadrado: %f \n", perimetro);}

^{circulo}                  {fprintf(yyout, "\n Circulo reconocido \n");
                            circulos++;
                            if(sscanf(yytext, "círculo (%f %f) %f", &(coordenadas[0]), &(coordenadas[1]), &(coordenadas[2])) == 0){
                              sscanf(yytext, "circulo (%f %f) %f", &(coordenadas[0]), &(coordenadas[1]), &(coordenadas[2]));
                            }
                            float area = calcularArea(coordenadas, CIRCULO);
                            fprintf(yyout, "\n Area del circulo: %f", area);
                            float perimetro = calcularPerimetro(coordenadas, CIRCULO);
                            fprintf(yyout, "\n Perimetro del circulo: %f \n", perimetro);}

^#                          {fprintf(yyout,"\n Fin del programa \n"); return 0;}

.*                          {fprintf(yyout, "\n Figura no reconocida --> %s \n", yytext);}
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

  fprintf(yyout, "\nSe han reconocido %d triangulos, %d cuadrados y %d circulos\n", triangulos, cuadrados, circulos);

  return 0;
}

float calcularArea(float coords[], int tipo){
  float sol = 0;
  float diagonal;

  switch(tipo){
    case TRIANGULO:
      sol = fabs(coords[0]*(coords[3] - coords[5]) + coords[2]*(coords[5] - coords[1]) + coords[4]*(coords[1] - coords[3]));
      sol /= 2;
      break;
    
    case CUADRADO:
      diagonal = sqrt(pow(coords[2]-coords[0],2) + pow(coords[3]-coords[1],2));
      sol = pow(diagonal,2)/2;
      break;

    case CIRCULO:
      sol = 3.14*pow(coords[2],2);
      break;
  }

  return sol;
}

float calcularPerimetro(float coords[], int tipo){
  float sol = 0;
  float diagonal;

  switch(tipo){
    case TRIANGULO:
      sol = sqrt(pow(coords[2]-coords[0],2) + pow(coords[3]-coords[1],2));
      sol += sqrt(pow(coords[4]-coords[2],2) + pow(coords[5]-coords[3],2));
      sol += sqrt(pow(coords[0]-coords[4],2) + pow(coords[1]-coords[5],2));
      break;
    
    case CUADRADO:
      diagonal = sqrt(pow(coords[2]-coords[0],2) + pow(coords[3]-coords[1],2));
      sol = pow(diagonal,2)/2;
      sol *= 4;
      break;

    case CIRCULO:
      sol = 2*3.14*coords[2];
      break;
  }

  return sol;
}