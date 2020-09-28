.model small
.data
        notification db 'Insert option number$'
        multPrompt db '1.Multiply$'
        divPrompt db '2.Divide$'
	factPrompt db '3.Print factors$'
	biPrompt db '4.Convert to binary$'

	num1Prompt db 'Insert first number: $'
	num2Prompt db 'Insert second number: $'

        error_message db 'ERROR: Cantidad de pruebas positivas es mayor a pruebas realizadas$'
	inputerror_message db 'ERROR: Invalid input$'

        num1 dw 00h             
        num2 dw 00h            
	optnum db 00h

        cnt db 00h
        tmp dw ?

.stack
.code
program:
        mov ax,@data
        mov ds,ax
        xor ax,ax

        ;Ask 3 digit numbers only
        mov dx, offset notification
        mov ah,09h
        int 21h

        ;Print new line
        mov dl,0ah
        mov ah,02h
        int 21h

        ;Show mult option
        mov dx,offset multPrompt
        mov ah,09h
        int 21h

        ;Print new line
        mov dl,0ah
        mov ah,02h
        int 21h

        ;Show div option
        mov dx,offset divPrompt
        mov ah,09h
        int 21h

        ;Print new line
        mov dl,0ah
        mov ah,02h
        int 21h

        ;Show factors option
        mov dx,offset factPrompt
        mov ah,09h
        int 21h

        ;Print new line
        mov dl,0ah
        mov ah,02h
        int 21h

        ;Show binary option
        mov dx,offset biPrompt
        mov ah,09h
        int 21h

        ;Print new line
        mov dl,0ah
        mov ah,02h
        int 21h

	;Get digit
        mov ah,01h   
        int 21h
	sub al,30h
	mov optnum,al

        cmp optnum,01h          ;Check if input is 1
        je getnum              ;If yes, go get numbers

        cmp optnum,02h          ;Check if input is 2
        je getnum              ;If yes, go get numbers
	
        cmp optnum,03h          ;Check if input is 3
        je getnum              ;If yes, go get numbers

        cmp optnum,04h          ;Check if input is 4
        je getnum              ;If yes, go get numbers

	jmp inputerror

;-----------------------------------------------------------------------
	getnum:
	
        ;Ask for first number
        mov dx,offset num1Prompt
        mov ah,09h
        int 21h
	
	xor ax,ax

	num1:
        mov ah,01h              ;Get digit
        int 21h

        cmp al,0Dh              ;Check if is an enter
        je inputerror           ;If yes, show error

        cmp cnt,01h             ;Check if 2 digits have been inserted
        je nextnum              ;If yes, go to nextnum

        sub al,30h              ;Convert to real number
        xor ah,ah               ;Clear ah

        ;Store the tens and hundreds if existent
        shl bx,01h              ;Multiply itself by 2
        mov tmp,bx
        mov cl,02h
        shl bx,cl               ;Multiply itself by 4, so by 8 in total
        add bx,tmp              ;By 10 in total
        add bx,ax
        mov num1,bx             ;Store in variable
        add cnt,01h             ;Add 1 to cont

        jmp num1

;-----------------------------------------------------------------------
	nextnum:
	
        ;Print new line
        mov dl,0ah
        mov ah,02h
        int 21h
	
        ;Ask for second number
        mov dx,offset num1Prompt
        mov ah,09h
        int 21h

	xor ax,ax
	xor bx,bx
	xor cx,cx

	num2:
        mov ah,01h              ;Get digit
        int 21h

        cmp al,0Dh              ;Check if is an enter
        je inputerror           ;If yes, show error

        cmp cnt,01h             ;Check if 2 digits have been inserted
        je operation            ;If yes, go to operation

        sub al,30h              ;Convert to real number
        xor ah,ah               ;Clear ah

        ;Store the tens and hundreds if existent
        shl bx,01h              ;Multiply itself by 2
        mov tmp,bx
        mov cl,02h
        shl bx,cl               ;Multiply itself by 4, so by 8 in total
        add bx,tmp              ;By 10 in total
        add bx,ax
        mov num2,bx             ;Store in variable
        add cnt,01h             ;Add 1 to cont

        jmp num2

;-----------------------------------------------------------------------
	operation:

        cmp optnum,01h          ;Check if input is 1
        je multiply             ;If yes, go to multiply

        cmp optnum,02h          ;Check if input is 2
        je divide               ;If yes, go to divide
	
        cmp optnum,03h          ;Check if input is 3
        je factors              ;If yes, go to factors

        cmp optnum,04h          ;Check if input is 4
        je binary 		;If yes, go to binary
;-----------------------------------------------------------------------
	multiply:

	jmp finalize
;-----------------------------------------------------------------------
	divide:

	jmp finalize
;-----------------------------------------------------------------------
	factors:

	jmp finalize
;-----------------------------------------------------------------------
	binary:

	jmp finalize
;-----------------------------------------------------------------------

;-----------------------------------------------------------------------

;-----------------------------------------------------------------------

	;Show input error message
	inputerror:
        mov dx,offset inputerror_message
        mov ah,09h
        int 21h

        ;Finalize program
        finalize:
        mov ah,4Ch
        int 21h
END program
