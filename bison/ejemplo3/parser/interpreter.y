/*! 
  \file interpreter.y
  \brief Grammar file
*/


%{
#include <iostream>
#include <string>

/* Error recovery functions */
#include "../error/error.hpp"

/* Macros for the screen */
#include "../includes/macros.hpp"


/*! 
	\brief  Lexical or scanner function
	\return int
	\note   C++ requires that yylex returns an int value
	\sa     yyparser
*/
int yylex();


extern int lineNumber; //!< External line counter

/***********************************************************/
/* NEW in example 2 */
extern std::string progname; //!<  Program name
/***********************************************************/
%}

/* In case of a syntactic error, more information is shown */
/* DEPRECATED */
/* %error-verbose */

/* ALTERNATIVA a %error-verbose */
%define parse.error verbose

/* Initial grammar symbol */
%start program


/* Defined token */

/* Minimum precedence */

/*******************************************/
/* NEW in example 3 */
%token NEWLINE
/*******************************************/

%token NUMBER

/* Left associativity */

/*******************************************/
/* MODIFIED in example 3 */
%left PLUS MINUS 

%left MULTIPLICATION DIVISION

%left LPAREN RPAREN

/* Maximum precedence */
%nonassoc  UNARY
/*******************************************/

%%
//! \name Grammar rules

program : stmtlist
		 { 
			std::cout << "program --> stmtlist" << std::endl;
		 }
; 

		/* MODIFIED in example 3: NEWLINE */ 
stmtlist:  /* empty: epsilon rule */
			{
				std::cout << "stmtlist -->  epsilon " << std::endl;
			}


		| stmtlist NEWLINE     /* empty line */
			{
				std::cout << "stmtlist -->  stmtlist NEWLINE " << std::endl;
			}

        | stmtlist exp NEWLINE
            { 
				std::cout << "stmtlist -->  stmtlist exp NEWLINE " << std::endl;

				std::cout << BIYELLOW; 
				std::cout << "Correct expression " << std::endl << std::endl;
				std::cout << RESET; 
            }

        | stmtlist error NEWLINE 
			{
				// The function yyerror is called
				// If %error-verbose is used then an error message is displayed

				std::cout << "stmtlist -->  stmtlist error NEWLINE " << std::endl;
			}
;

		/* MODIFIED in example 3: tokens PLUS, MINUS, ... */ 
		/* NEW in example 3: unary operators */ 
exp:	NUMBER 
       { std::cout << "exp --> NUMBER" << std::endl;}

	|	exp PLUS exp 
		{ std::cout << "exp --> exp PLUS exp" << std::endl; }

	|	exp MINUS exp
		{ std::cout << "exp --> exp MINUS exp" << std::endl; }

	|	exp MULTIPLICATION exp 
		{ std::cout << "exp --> exp MULTIPLICATION exp" << std::endl; }

	|	exp DIVISION exp 
		{ std::cout << "exp --> exp DIVISION exp" << std::endl; }

	|	LPAREN exp RPAREN
		{ std::cout << "exp --> LPAREN exp RPAREN " << std::endl;}

		/* NEW in example 3 */ 
    | 	PLUS exp %prec UNARY
		{ std::cout << "exp --> PLUS exp" << std::endl; }

		/* NEW in example 3 */ 
    | 	MINUS exp %prec UNARY
		{ std::cout << "exp --> MINUS exp" << std::endl; }
;

 
%%




