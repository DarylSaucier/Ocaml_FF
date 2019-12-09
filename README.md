Projet algorithme Ford-Fulkerson 
Auteurs : Quentin LARREDE, Elie PERIERS

Tous les codes sources se trouvent dans /src.

Pour compiler, un Makefile permet de construire le projet de manière autonome : 
 - `make` pour compiler. Créé un fichier ftest.native executable
 - `make format` pour indenter le projet entier.

Pour executer après le make, la syntaxe est la suivante : 
 - ./fest.native [INFILE] [SOURCE] [SINK] [OUTFILE]

 Exemple : 
 - ./ftest.native graphpasmal.txt 0 5 test1.txt


++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Ford-Fulkerson algorithm project
Authors : Quentin LARREDE, Elie PERIERS

All source codes can be found in /src.

To compile, a makefile also provides basic automation :
 - `make` to compile. This creates an ftest.native executable
 - `make format` to indent the entire project

To execute, please follow this syntaxe : 
 - ./fest.native [INFILE] [SOURCE] [SINK] [OUTFILE]

 Example : 
 - ./ftest.native graphpasmal.txt 0 5 test1.txt
