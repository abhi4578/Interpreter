# Interpreter
Interpreter using yacc and  lex

Interpreter is built using yacc and lex tools which have equivalent GNU versions as bison and flex for following grammar:

    <expr> := [ <op> <expr> <expr> ] 
          | <symbol> 
          | <value>

    <symbol> := [a-zA-Z]+

    <value> := [0-9]+
  
    <op> := ‘+’ | ‘*’ | ‘==‘ | ‘<‘
                           
    <prog> :=  [ = <symbol> <expr> ] 
          | [ ; <prog> <prog> ] 
          | [ if <expr> <prog> <prog> ] 
	      	| [ while <expr> <prog> ] 
          |	[ return <expr> ]

# Requirements

To build interpreter you need yacc and lex or their GNU versions bison and flex
To install bison and flex in ubuntu:

      sudo apt install bison 
      sudo apt install flex
  
# Building the file
  
  To build file use the command
    
      bash build
