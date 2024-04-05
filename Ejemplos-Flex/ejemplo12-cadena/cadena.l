%{

  /* Descripcion:
	   El analizador léxico reconoce y muestra las cadenas delimitadas por comillas simples.
     No se muestran las comillas exteriores de las cadenas.

 */

%}

/* Definiciones regulares */
letra          [a-zA-Z]
digito         [0-9]
identificador  {letra}({letra}|{digito})*

cadena         \'([^'\\]|\\.)*\' 


%% 

{identificador}   {printf("identificador = %s\n", yytext);}


{cadena}		      { 
                     /* Se elimina la comilla final */
                     yytext[yyleng-1] = '\0';

                    /* Se elimina la comilla inicial */
                    yytext++;

                    /* Se actualiza el tamaño de la cadena */
                    yyleng--;

               		   /* Se ha reconocido una cadena */
                      printf("\n Cadena reconocida (sin comillas exteriores)\n -->  <%s>\n",yytext);
				          }      

.                 { ECHO; }

%%  

