.model small
.data 
	Name DB 'Brenner Hernandez $'
	Carne DB '1023718 $'
.stack 
.code
program:
	MOV AX, @DATA
	MOV DS, AX 

	MOV DX, offset Name
	MOV AH, 09h
	INT 21h

	MOV AH, 4Ch
	INT 21h

END program
