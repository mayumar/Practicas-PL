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

float coordenadas[6];

int triangulos = 0;
int cuadrados = 0;
int circulos = 0;

int n_coordenadas = 0;

%}

%option case-insensitive


/* Definiciones regulares */

numero          [0-9]+\.[0-9]+
coordenada      \({numero}\ {numero}\)

cuadrado        cuadrado
triangulo       tri(a|á)ngulo
circulo         c(i|í)rculo

/*   Definicion de estados   */

%x TRIANGULO_Q1 TRIANGULO_Q2 TRIANGULO_Q3 CUADRADO_Q1 CUADRADO_Q2 CIRCULO_Q1 CIRCULO_Q2

/***** Zona de las reglas *****/
%%

^{triangulo}                {BEGIN TRIANGULO_Q1;}
^{cuadrado}                 {BEGIN CUADRADO_Q1;}
^{circulo}                  {BEGIN CIRCULO_Q1;}

<TRIANGULO_Q1>{coordenada}  {BEGIN TRIANGULO_Q2;
                             sscanf(yytext, "(%f %f)", &(coordenadas[0]), &(coordenadas[1]));
                             fprintf(yyout, "\n Coordenada 1 del triangulo (%f %f) \n", coordenadas[0], coordenadas[1]);}

<TRIANGULO_Q2>{coordenada}  {BEGIN TRIANGULO_Q3;
                             sscanf(yytext, "(%f %f)", &(coordenadas[2]), &(coordenadas[3]));
                             fprintf(yyout, "\n Coordenada 2 del triangulo (%f %f) \n", coordenadas[2], coordenadas[3]);}

<TRIANGULO_Q3>{coordenada}  {BEGIN INITIAL;
                             triangulos++;
                             sscanf(yytext, "(%f %f)", &(coordenadas[4]), &(coordenadas[5]));
                             fprintf(yyout, "\n Coordenada 3 del triangulo (%f %f) \n", coordenadas[4], coordenadas[5]);
                             float area = calcularArea(coordenadas, TRIANGULO);
                             fprintf(yyout, "\n Area del triangulo: %f", area);
                             float perimetro = calcularPerimetro(coordenadas, TRIANGULO);
                             fprintf(yyout, "\n Perimetro del triangulo: %f \n", perimetro);}


<CUADRADO_Q1>{coordenada}   {BEGIN CUADRADO_Q2;
                             sscanf(yytext, "(%f %f)", &(coordenadas[0]), &(coordenadas[1]));
                             fprintf(yyout, "\n Coordenada 1 del cuadrado (%f %f) \n", coordenadas[0], coordenadas[1]);}

<CUADRADO_Q2>{coordenada}   {BEGIN INITIAL;
                             cuadrados++;
                             sscanf(yytext, "(%f %f)", &(coordenadas[2]), &(coordenadas[3]));
                             fprintf(yyout, "\n Coordenada 2 del cuadrado (%f %f) \n", coordenadas[2], coordenadas[3]);
                             float area = calcularArea(coordenadas, CUADRADO);
                             fprintf(yyout, "\n Area del cuadrado: %f", area);
                             float perimetro = calcularPerimetro(coordenadas, CUADRADO);
                             fprintf(yyout, "\n Perimetro del cuadrado: %f \n", perimetro);}


<CIRCULO_Q1>{coordenada}    {BEGIN CIRCULO_Q2;
                             sscanf(yytext, "(%f %f)", &(coordenadas[0]), &(coordenadas[1]));
                             fprintf(yyout, "\n Coordenada del circulo (%f %f) \n", coordenadas[0], coordenadas[1]);}

<CIRCULO_Q2>{numero}        {BEGIN INITIAL;
                             circulos++;
                             sscanf(yytext, "%f", &(coordenadas[2]));
                             fprintf(yyout, "\n Radio del circulo %f \n", coordenadas[2]);
                             float area = calcularArea(coordenadas, CIRCULO);
                             fprintf(yyout, "\n Area del circulo: %f", area);
                             float perimetro = calcularPerimetro(coordenadas, CIRCULO);
                             fprintf(yyout, "\n Perimetro del circulo: %f \n", perimetro);}

^#                          {fprintf(yyout,"\n Fin del programa \n"); return 0;}
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

  fprintf(yyout, "\nSe han reconocido %d triangulos, %d cuadrados y %d circulos\n", triangulos, cuadrados, circulos);

  return 0;
}

float calcularArea(float coords[], int tipo){
  float sol = 0;

  switch(tipo){
    case TRIANGULO:
      sol = fabs(coords[0]*(coords[3] - coords[5]) + coords[2]*(coords[5] - coords[1]) + coords[4]*(coords[1] - coords[3]));
      sol /= 2;
      break;
    
    case CUADRADO:
      float diagonal = sqrt(pow(coords[2]-coords[0],2) + pow(coords[3]-coords[1],2));
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

  switch(tipo){
    case TRIANGULO:
      sol = sqrt(pow(coords[2]-coords[0],2) + pow(coords[3]-coords[1],2));
      sol += sqrt(pow(coords[4]-coords[2],2) + pow(coords[5]-coords[3],2));
      sol += sqrt(pow(coords[0]-coords[4],2) + pow(coords[1]-coords[5],2));
      break;
    
    case CUADRADO:
      float diagonal = sqrt(pow(coords[2]-coords[0],2) + pow(coords[3]-coords[1],2));
      sol = pow(diagonal,2)/2;
      sol *= 4;
      break;

    case CIRCULO:
      sol = 2*3.14*coords[2];
      break;
  }

  return sol;
}