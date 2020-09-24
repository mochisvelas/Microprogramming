.model small
.data
	tInput DB 'Ingrese la cantidad de pruebas realizadas: $'
	ptInput DB 'Ingrese la cantidad de pruebas positivas: $'

	red DB 'Alerta: Roja$'
	orn DB 'Alerta: Naranja$'
	yll DB 'Alerta: Amarilla$'
	grn DB 'Alerta: Verde$'

	tNum DW ? 		;Tests number
	ptNum DW ? 		;Positiv tests number

	cnt DB 00h
	tmp DW ?

.stack
.code
program:
	MOV AX,@DATA
	MOV DS,AX
	XOR AX,AX
	XOR BX,BX

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

	CMP cnt,02h 		;Check if 3 digits have been inserted
	JE nextnum 	 	;If yes, start program

	SUB AL,30h 		;Convert to real number
	XOR AH,AH 		;Clear AH

	;Store the tens and hundreds if existent
	SHL BX,01h 		;Multiply itself by 2
	MOV tmp,BX
	MOV CL,02h
	SHL BX,CL 		;Multiply itself by 4, so by 8 in total
	ADD BX,tmp 		;By 10 in total
	ADD BX,AX
	MOV tNum,BX 		;Store in variable
	ADD cnt,01h 		;Add 1 to cont

	JMP tstloop

;-----------------------------------------------------------------------
	
	nextnum:

	;New line
	MOV DL,0AH
	MOV AH,02h
	INT 21h


	;Ask for positive tests quantity
	MOV DX,offset ptInput
	MOV AH,09h
	INT 21h

	XOR AX,AX
	XOR BX,BX
	MOV cnt,00h

	;Loop to store all digits
	ptloop:

	MOV AH,01h 		;Get digit
	INT 21h
	
	CMP AL,0Dh 		;Check if is an enter
	JE startprogram 	;If yes, start program

	CMP cnt,02h 		;Check if 3 digits have been inserted
	JE startprogram 	 	;If yes, start program

	SUB AL,30h 		;Convert to real number
	XOR AH,AH 		;Clear AH

	;Store the tens and hundreds if existent
	SHL BX,01h 		;Multiply itself by 2
	MOV tmp,BX
	MOV CL,02h
	SHL BX,CL 		;Multiply itself by 4, so by 8 in total
	ADD BX,tmp 		;By 10 in total
	ADD BX,AX
	MOV ptNum,BX 		;Store in variable
	ADD cnt,01h 		;Add 1 to cont
	
	JMP ptloop

;-----------------------------------------------------------------------
	startprogram:

;-----------------------------------------------------------------------

	;Finalize program
	MOV AH,4Ch
	INT 21h
END program
