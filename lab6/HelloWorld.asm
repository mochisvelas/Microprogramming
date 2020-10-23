.386
.model flat,stdcall

option casemap:none

INCLUDE \masm32\include\windows.inc
INCLUDE \masm32\include\masm32.inc
INCLUDE \masm32\include\masm32rt.inc
INCLUDE \masm32\include\kernel32.inc


.data
	o_hello 	db "Hola ",0
	o_id 		db " su carnet es ",0
	o_welcome	db "Bienvenido a la carrera de ",0
	o_insert_name 	db "Ingrese su nombre",0
	o_insert_career db "Ingrese su carrera",0
	o_insert_id     db "Ingrese su carnet",0
	new_line 	db 0Ah
.data?
	input_name 	db 50 dup(?)
	input_career 	db 50 dup(?)
	input_id 	db 50 dup(?)
.const

.code
program:
	;Ask and read user name
	invoke StdOut, addr o_insert_name
	invoke StdOut, addr new_line
	invoke StdIn, addr input_name,10

	;Ask and read user id
	invoke StdOut, addr o_insert_id
	invoke StdOut, addr new_line
	invoke StdIn, addr input_id,10

	;Ask and read user career
	invoke StdOut, addr o_insert_career
	invoke StdOut, addr new_line
	invoke StdIn, addr input_career,10

	;Display welcome message
	invoke StdOut, addr o_hello
	invoke StdOut, addr input_name
	invoke StdOut, addr o_id
	invoke StdOut, addr input_id
	invoke StdOut, addr new_line
	invoke StdOut, addr o_welcome
	invoke StdOut, addr input_career

	;Exit program
	invoke ExitProcess,0
END program
