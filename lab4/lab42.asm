.model small
.data
        notification db 'Insert option number$'
	factPrompt db '1.Print factors$'
	biPrompt db '2.Convert to binary$'

	numPrompt db 'Insert number: $'

	inputerror_message db 'ERROR: Invalid input$'

	num db 00h
	otpnum db 00h

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

        cmp optnum,01h          ;Check if input is 1
        je getnum              	;If yes, go get number

        cmp optnum,02h          ;Check if input is 2
        je getnum              	;If yes, go get number

	jmp inputerror

;-----------------------------------------------------------------------
	getnum:
	
        ;Print new line
        mov dl,0ah
        mov ah,02h
        int 21h

        ;Ask for number
        mov dx,offset numPrompt
        mov ah,09h
        int 21h
	
	xor ax,ax

	numtag:
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
        add cont,01h            ;Add 1 to cont

        cmp cont,02h            ;Check if 2 digits have been inserted
        je operation            ;If yes, go to nextnum

        jmp numtag

;-----------------------------------------------------------------------
	operation:

        cmp optnum,01h          ;Check if input is 1
        je multiply             ;If yes, go to factors

        cmp optnum,02h          ;Check if input is 2
        je divide               ;If yes, go to binary

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

	mov cont,00h

	jmp subthousands 		;If is not a single digit go to print comp

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

	jmp finalize

;-----------------------------------------------------------------------
	subthousands:

	cmp bx,3E8h
	jl subhundreds

	sub bx,3E8h

	inc cont

	cmp bx,09h
	jle printcont

	jmp subthousands

;-----------------------------------------------------------------------
	subhundreds:

	cmp bx,64h
	jl subtens

	sub bx,64h

	inc cont2

	cmp bx,09h
	jle printcont

	jmp subhundreds
;-----------------------------------------------------------------------
	subtens:

	cmp bx,0Ah
	jl printcont

	sub bx,0Ah

	inc cont3

	jmp subtens
;-----------------------------------------------------------------------
	printcont:

        ;Print new line
        mov dl,0ah
        mov ah,02h
        int 21h

	mov dl,cont
	add dl,30h
	int 21h

	mov dl,cont2
	add dl,30h
	int 21h

	mov dl,cont3
	add dl,30h
	int 21h

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
