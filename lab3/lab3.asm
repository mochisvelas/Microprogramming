.model small
.data
	notification db 'Ingresar cantidades de 3 caracteres$'
	tInput db 'Ingrese la cantidad de pruebas realizadas: $'
	ptInput db 'Ingrese la cantidad de pruebas positivas: $'

	red_message db 'Alerta: Roja$'
	orange_message db 'Alerta: Naranja$'
	yellow_message db 'Alerta: Amarilla$'
	green_message db 'Alerta: Verde$'
	error_message db 'ERROR: Cantidad de pruebas positivas es mayor a pruebas realizadas$'

	tNum dw 00h 		;Tests number
	ptNum dw 00h 		;Positive tests number

	cnt db 00h 		
	tmp dw ?

.stack
.code
program:
	mov ax,@data
	mov ds,ax
	xor ax,ax
	xor bx,bx

	;Ask 3 digit numbers only
	mov dx, offset notification
	mov ah,09h
	int 21h

	;Print new line
	mov dl,0ah
	mov ah,02h
	int 21h

	;Ask for tests quantity
	mov dx,offset tInput
	mov ah,09h
	int 21h

	;Loop to store all digits
	tstloop:

	mov ah,01h 		;Get digit
	int 21h
	
	cmp al,0Dh 		;Check if is an enter
	je nextnum 	 	;If yes, ask for next number

	cmp cnt,02h 		;Check if 3 digits have been inserted
	je nextnum 	 	;If yes, ask for next number

	sub al,30h 		;Convert to real number
	xor ah,ah 		;Clear ah

	;Store the tens and hundreds if existent
	shl bx,01h 		;Multiply itself by 2
	mov tmp,bx
	mov cl,02h
	shl bx,cl 		;Multiply itself by 4, so by 8 in total
	add bx,tmp 		;By 10 in total
	add bx,ax
	mov tNum,bx 		;Store in variable
	add cnt,01h 		;Add 1 to cont

	jmp tstloop

;-----------------------------------------------------------------------
	
	;Ask for next number
	nextnum:

	;Print new line
	mov dl,0ah
	mov ah,02h
	int 21h


	;Ask for positive tests quantity
	mov dx,offset ptInput
	mov ah,09h
	int 21h

	xor ax,ax
	xor bx,bx
	xor cx,cx
	mov cnt,00h

	;Loop to store all digits
	ptloop:

	mov ah,01h 		;Get digit
	int 21h
	
	cmp al,0Dh 		;Check if is an enter
	je startprogram 	;If yes, start program

	cmp cnt,02h 		;Check if 3 digits have been inserted
	je startprogram 	;If yes, start program

	sub al,30h 		;Convert to real number
	xor ah,ah 		;Clear ah

	;Store the tens and hundreds if existent
	shl bx,01h 		;Multiply itself by 2
	mov tmp,bx
	mov cl,02h
	shl bx,cl 		;Multiply itself by 4, so by 8 in total
	add bx,tmp 		;By 10 in total
	add bx,ax
	mov ptNum,bx 		;Store in variable
	add cnt,01h 		;Add 1 to cont
	
	jmp ptloop

;-----------------------------------------------------------------------

	;Start of main program
	startprogram:

	;Print new line
	mov dl,0ah
	mov ah,02h
	int 21h

	mov bx,tNum
	cmp bx,ptNum 		;Check if positive quantity is greater than total quantity
	jl error 		;If so go to error

	xor bx,bx

	mov ax,ptNum
	mov bx,64h
	mul bx  		;Multiply total positive cases by 100
	div tNum 		;Div mul result by total cases to obtain percentage

	;Check percentage value
	cmp ax,14h 		;Check if percentage is greater than 20
	jg red_alert 		;If so go to red alert

	cmp ax,0Fh 		;Check if percentage is between 15 and 20
	jge orange_alert 	;If so go to red alert

	cmp ax,05h 		;Check if percentage is between 5 and 14
	jge yellow_alert 	;If so go to red alert

	cmp ax,00h 		;Check if percentage is between 0 and 4
	jge green_alert 		;If so go to green alert


	;Display red alert message
	red_alert:
	mov dx,offset red_message
	mov ah,09h
	int 21h
	jmp finalize


	;Display orange alert message
	orange_alert:
	mov dx,offset orange_message
	mov ah,09h
	int 21h
	jmp finalize

	
	;Display yellow alert message
	yellow_alert:
	mov dx,offset yellow_message
	mov ah,09h
	int 21h
	jmp finalize


	;Display green alert message
	green_alert:
	mov dx,offset green_message
	mov ah,09h
	int 21h
	jmp finalize


	;Display error message
	error:
	mov dx,offset error_message
	mov ah,09h
	int 21h

;-----------------------------------------------------------------------

	;Finalize program
	finalize:
	mov ah,4Ch
	int 21h
END program
