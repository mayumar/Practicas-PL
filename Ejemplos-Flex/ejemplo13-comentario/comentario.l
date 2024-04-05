%{
  /* Descripcion:
	  El analizador léxico reconoce y cuenta los comentarios del lenguaje C++.
	  También reconoce a los identificadores.
    
    Se muestra el uso de 
		- BEGIN 
		- Reglas condicionales controladas por un estado de flex usando %x 
 */

/* Indica el número de comentario  de cada tipo */
 int comentario_linea =0;
 int comentario=0;
  /* Indica el número de líneas de cada comentario */
 int lineasComentario;
%}

/* Definiciones regulares */
letra         [a-zA-Z]
digito        [0-9]
identificador {letra}({letra}|{digito})*

/* Se define un nuevo estado: ESTADO_COMENTARIO */
%x ESTADO_COMENTARIO

%% 

{identificador}  { printf("identificador = %s\n", yytext); }

\/\/.*			{ 
					comentario_linea++; 
					printf("Comentario de línea número %d \n <%s>\n",comentario_linea,yytext);
 				}

"/*"	      	{
					/* Se activa el reconocimiento de un comentario */
			  		BEGIN ESTADO_COMENTARIO; 

			    	comentario++; 
			    	lineasComentario=1;
			  		}


<ESTADO_COMENTARIO>"/*"/(.|\n)  {
			          				printf("\n No se pueden anidar comentarios\n"); 

			          				/* Fin del analizador léxico */
			          				return 0;
								 }

<ESTADO_COMENTARIO>"*/"          { 
									/* Fin del comentario: se vuelve al estado por defecto */
				  					BEGIN 0; 
				  					printf("\n nº comentario = %d, lineas del comentario = %d\n",comentario, lineasComentario);
				  				}      

<ESTADO_COMENTARIO>.			{	
									/* Se descarta todo lo que haya contenido en el comentario */
									;
								}

<ESTADO_COMENTARIO>\n       	{
									/* Si hay un salto de línea en el comentario, se cuenta */
									lineasComentario++;
								}

.       	                	{
									/* Se muestran por pantalla el resto de caracteres que haya fuera del comentario */
									ECHO; 
								}
%%  


