.model small
.data
        notification db 'Insert option number$'
        multPrompt db '1.Multiply$'
        divPrompt db '2.Divide$'

	num1Prompt db 'Insert first number: $'
	num2Prompt db 'Insert second number: $'

	inputerror_message db 'ERROR: Invalid input$'

        num1 db 00h 		;Will store first input number 
        num2 db 00h             ;Will store second input number
	optnum db 00h 		;Will store input option number

        cont db 00h
	cont2 db 00h
	cont3 db 00h
        tmp db 00h

.stack
.code
program:
        mov ax,@data
        mov ds,ax
        xor ax,ax

        ;Ask for option number
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

	;Get digit
        mov ah,01h   
        int 21h
	sub al,30h
	mov optnum,al

        cmp optnum,01h          ;Check if input is 1
        je getnum              	;If yes, go get numbers

        cmp optnum,02h          ;Check if input is 2
        je getnum              	;If yes, go get numbers

	jmp inputerror

;-----------------------------------------------------------------------
	getnum:
	
        ;Print new line
        mov dl,0ah
        mov ah,02h
        int 21h

        ;Ask for first number
        mov dx,offset num1Prompt
        mov ah,09h
        int 21h
	
	xor ax,ax

	num1tag:
        mov ah,01h              ;Get digit
        int 21h

        cmp al,0Dh              ;Check if is an enter
	jne bridge
        jmp inputerror          ;If yes, show error
	bridge:

        sub al,30h              ;Convert to real number
        xor ah,ah               ;Clear ah

        ;Store the tens and hundreds if existent
        shl bl,01h              ;Multiply itself by 2
        mov tmp,bl
        mov cl,02h
        shl bl,cl               ;Multiply itself by 4, so by 8 in total
        add bl,tmp              ;By 10 in total
        add bl,al
        mov num1,bl             ;Store in variable
        inc cont               	;Add 1 to cont

        cmp cont,02h            ;Check if 2 digits have been inserted
        je nextnum              ;If yes, go to nextnum

        jmp num1tag

;-----------------------------------------------------------------------
	nextnum:
	
        ;Print new line
        mov dl,0ah
        mov ah,02h
        int 21h
	
        ;Ask for second number
        mov dx,offset num2Prompt
        mov ah,09h
        int 21h

	xor ax,ax
	xor bx,bx
	xor cx,cx
	mov cont,00h
	mov tmp,00h

	num2tag:
        mov ah,01h              ;Get digit
        int 21h

        cmp al,0Dh              ;Check if is an enter
	jne tunnel
        jmp inputerror          ;If yes, show error
	tunnel:

        sub al,30h              ;Convert to real number
        xor ah,ah               ;Clear ah

        ;Store the tens and hundreds if existent
        shl bl,01h              ;Multiply itself by 2
        mov tmp,bl
        mov cl,02h
        shl bl,cl               ;Multiply itself by 4, so by 8 in total
        add bl,tmp              ;By 10 in total
        add bl,al
        mov num2,bl             ;Store in variable
        inc cont               	;Add 1 to cont

        cmp cont,02h             ;Check if 2 digits have been inserted
        je operation            ;If yes, go to operation

        jmp num2tag

;-----------------------------------------------------------------------
	operation:

        cmp optnum,01h          ;Check if input is 1
        je multiply             ;If yes, go to multiply

        cmp optnum,02h          ;Check if input is 2
        je divide               ;If yes, go to divide

;-----------------------------------------------------------------------
	multiply:

	xor ax,ax
	xor bx,bx
	xor cx,cx

	;Store nums in registers
	mov cl,num1
	mov al,num2

	;Check if al is 0, if yes go to printresult
	cmp al,00h
	je printresult

	;Multiply numbers
	multag:

	;Check if cl is 0, if yes go to printresult
	cmp cl,00h
	je printresult

	add bx,ax

	dec cl
	jmp multag
;-----------------------------------------------------------------------
	divide:

	mov cl,63h 		;Store 100 in cl
	mov al,num1 		;Store num1 in al

	xor bx,bx

	;If divider is 0 show error
	cmp num2,00h
	jne divloop
	jmp inputerror

	;Division loop
	divloop:

	;If dividend is 0 printresult
	cmp al,00h
	je printresult

	;If al is less than num2 printresult
	cmp al,num2
	jl printresult

	sub al,num2 		;Substract num2 to al

	inc bx 			;Add 1 to bx

	loop divloop 		;Iterate again
;-----------------------------------------------------------------------
	printresult:

	;If single digit go to print single
	cmp bx,09h
	jle printsingle

	mov cont,00h 		;Reset cont

	jmp subthousands 	;If is not a single digit go to subthousands

;-----------------------------------------------------------------------
	printsingle:

        ;Print new line
        mov dl,0ah
        mov ah,02h
        int 21h

	;Print digit
	mov dl,bl
	add dl,30h
	int 21h

	jmp finalize 		;Go to finalize

;-----------------------------------------------------------------------
	;Count thounsands in result if any
	subthousands:

	cmp bx,3E8h
	jl subhundreds

	sub bx,3E8h

	inc cont

	cmp bx,09h
	jle printcont

	jmp subthousands

;-----------------------------------------------------------------------
	;Count hundreds in result if any
	subhundreds:

	cmp bx,64h
	jl subtens

	sub bx,64h

	inc cont2

	cmp bx,09h
	jle printcont

	jmp subhundreds
;-----------------------------------------------------------------------
	;Count tens in result if any
	subtens:

	cmp bx,0Ah
	jl printcont

	sub bx,0Ah

	inc cont3

	jmp subtens
;-----------------------------------------------------------------------
	;Print number
	printcont:

        ;Print new line
        mov dl,0ah
        mov ah,02h
        int 21h

	;Print thounsands
	mov dl,cont
	add dl,30h
	int 21h

	;Print hundreds
	mov dl,cont2
	add dl,30h
	int 21h

	;Print tens
	mov dl,cont3
	add dl,30h
	int 21h

	;Print units
	mov dl,bl
	add dl,30h
	int 21h

	jmp finalize
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
