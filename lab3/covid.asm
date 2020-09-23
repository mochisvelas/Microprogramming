.model small
.data
	tInput DB 'Ingrese la cantidad de pruebas realizadas: $'
	ptInput DB 'Ingrese la cantidad de pruebas positivas: $'

	red DB 'Alerta: Roja$'
	orn DB 'Alerta: Naranja$'
	yll DB 'Alerta: Amarilla$'
	grn DB 'Alerta: Verde$'

	tNum DB ? 		;Tests number
	ptNum DB ? 		;Positiv tests number

	cnt DB 00h

.stack
.code
program:
	MOV AX,@DATA
	MOV DS,AX

	;Ask for tests quantity
	MOV DX,offset tInput
	MOV AH,09h
	INT 21h

	;Loop to store all digits
	tstloop:

	MOV AH,01h 		;Get digit
	INT 21h
	
	CMP AL,0Dh 		;Check if is an enter
	JE nextnum 	 	;If yes, start program

	CMP cnt,03h 		;Check if 3 digits have been inserted
	JE nextnum 	 	;If yes, start program

	SUB AL,30h 		;Convert to real number
	XOR AH,AH 		;Clear AH

	;Store the tens and hundreds if existent
	SLL BX,01h 		;Multiply itself by 2
	MOV CX,BX
	SLL BX,02h 		;Multiply itself by 4, so by 8 in total
	ADD BX,CX 		;By 10 in total
	ADD BX,AX
	MOV tNum,BX 		;Store in variable
	ADD cnt,01h 		;Add 1 to cont

	JMP tstloop

;-----------------------------------------------------------------------
	
	nextnum:

	XOR BX,BX
	XOR AX,AX
	MOV cnt,00h

	;New line
	MOV DL,0AH
	MOV AH,02h
	INT 21h

	;Ask for positive tests quantity
	MOV DX,offset ptInput
	MOV AH,09h
	INT 21h

	;Loop to store all digits
	ptloop:

	MOV AH,01h 		;Get digit
	INT 21h
	
	CMP AL,0Dh 		;Check if is an enter
	JE startprogram 	;If yes, start program

	CMP cnt,03h 		;Check if 3 digits have been inserted
	JE startprogram 	;If yes, start program

	SUB AL,30h 		;Convert to real number
	XOR AH,AH 		;Clear AH

	;Store the tens and hundreds if existent
	SLL BX,01h 		;Multiply itself by 2
	MOV CX,BX
	SLL BX,02h 		;Multiply itself by 4, so by 8 in total
	ADD BX,CX 		;By 10 in total
	ADD BX,AX
	MOV ptNum,BX 		;Store in variable
	ADD cnt,01h 		;Add 1 to cont

;-----------------------------------------------------------------------
	startprogram:

;-----------------------------------------------------------------------

	;Finalize program
	MOV AH,4Ch
	INT 21h
END program
