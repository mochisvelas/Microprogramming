.model small
.data
        notification db 'Insert option number$'
        multPrompt db '1.Multiply$'
        divPrompt db '2.Divide$'
	factPrompt db '3.Print factors$'
	biPrompt db '4.Convert to binary$'

	numPrompt db 'Insert number: $'
	num1Prompt db 'Insert first number: $'
	num2Prompt db 'Insert second number: $'

	inputerror_message db 'ERROR: Invalid input$'

        num1 db 00h             
        num2 db 00h            
	optnum db 00h

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
        je getnum              	;If yes, go get numbers

        cmp optnum,02h          ;Check if input is 2
        je getnum              	;If yes, go get numbers
	
        cmp optnum,03h          ;Check if input is 3
        je getnum            	;If yes, go get number

        cmp optnum,04h          ;Check if input is 4
        je getnum            	;If yes, go get number

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
        add cont,01h             ;Add 1 to cont

        cmp cont,02h             ;Check if 2 digits have been inserted
        je nextnum              ;If yes, go to nextnum

        jmp num1tag

;-----------------------------------------------------------------------
	nextnum:
	
        ;Print new line
        mov dl,0ah
        mov ah,02h
        int 21h

        cmp optnum,03h          ;Check if input is 3
        je factors              ;If yes, go to factors

        cmp optnum,04h          ;Check if input is 4
        je binary 		;If yes, go to binary
	
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
        add cont,01h             ;Add 1 to cont

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

	mov cl,num1
	mov al,num2

	multloop:
	add bx,ax
	loop multloop

	;mov cont,00h
	jmp printresult
;-----------------------------------------------------------------------
	divide:

	jmp printresult
;-----------------------------------------------------------------------
	factors:

	jmp printresult
;-----------------------------------------------------------------------
	binary:

	jmp printresult
;-----------------------------------------------------------------------
	printresult:

	xor ax,ax

	;If single digit go to print single
	cmp bx,09h
	jle printsingle

	jmp printcomp 		;If is not a single digit go to print comp

;-----------------------------------------------------------------------
	printsingle:

        ;Print new line
        mov dl,0ah
        mov ah,02h
        int 21h

	;Print digit
	mov ah,02h
	mov dl,bl
	add dl,30h
	int 21h

	jmp finalize

;-----------------------------------------------------------------------
	printcont:

        ;Print new line
        mov dl,0ah
        mov ah,02h
        int 21h

	mov ah,02h
	mov dl,cont
	add dl,30h
	int 21h

	mov ah,02h
	mov dl,cont2
	add dl,30h
	int 21h

	mov ah,02h
	mov dl,cont3
	add dl,30h
	int 21h

	mov ah,02h
	mov dl,bl
	add dl,30h
	int 21h

	jmp finalize
;-----------------------------------------------------------------------
	printcomp:

	mov cont,00h
;-----------------------------------------------------------------------
	printthounsands:

	sub bx,3E8h
	
	cmp bx,00h
	je singlethousand
	jl printhundreds

	inc cont

	cmp bx,09h
	jle printcont

	jmp printthounsands
;-----------------------------------------------------------------------
	printhundreds:

	sub bx,64h

	cmp bx,00h
	je singlehundred 
	jl printens

	inc cont2

	cmp bx,09h
	jle printcont

	jmp printhundreds
;-----------------------------------------------------------------------
	printens:

	sub bx,0Ah

	cmp bx,00h
	je singleten
	jl printcont

	inc cont3

	jmp printens
;-----------------------------------------------------------------------
	singlethousand:

        ;Print new line
        mov dl,0ah
        mov ah,02h
        int 21h

	;Print single digit
	mov ah,02h
	mov dl,01h
	add dl,30h
	int 21h

	;Print single digit
	mov ah,02h
	mov dl,00h
	add dl,30h
	int 21h
	
	;Print single digit
	mov ah,02h
	mov dl,00h
	add dl,30h
	int 21h

	;Print single digit
	mov ah,02h
	mov dl,00h
	add dl,30h
	int 21h

	jmp finalize
;-----------------------------------------------------------------------
	singlehundred:

        ;Print new line
        mov dl,0ah
        mov ah,02h
        int 21h

	;Print single digit
	mov ah,02h
	mov dl,01h
	add dl,30h
	int 21h

	;Print single digit
	mov ah,02h
	mov dl,00h
	add dl,30h
	int 21h

	;Print single digit
	mov ah,02h
	mov dl,00h
	add dl,30h
	int 21h

	jmp finalize
;-----------------------------------------------------------------------
	singleten:

        ;Print new line
        mov dl,0ah
        mov ah,02h
        int 21h

	;Print single digit
	mov ah,02h
	mov dl,01h
	add dl,30h
	int 21h

	;Print single digit
	mov ah,02h
	mov dl,00h
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
