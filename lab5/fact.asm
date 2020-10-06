.model small
.data
        notification db 'Insert a 3 digit number no greater than 128$'
	inputerror_message db 'ERROR: Invalid input$'

	num db 00h

	cont db 00h
	tmp db 00h

.stack
.code
program:
        mov ax,@data
        mov ds,ax
        xor ax,ax
        xor bx,bx

;-----------------------------------------------------------------------
        ;Print new line
        mov dl,0ah
        mov ah,02h
        int 21h

        ;Ask for the input number
        mov dx, offset notification
        mov ah,09h
        int 21h

        ;Print new line
        mov dl,0ah
        mov ah,02h
        int 21h

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
        mov num,bl             	;Store in variable
        inc cont               	;Add 1 to cont

        cmp cont,02h            ;Check if 2 digits have been inserted
        je checknum         	;If yes, go to checknum

        jmp numtag
;-----------------------------------------------------------------------

        ;Check if num is not greater than 128
        checknum:

	mov bl,num

	cmp bl,80h
	jg inputerror

	call factorial 		;If not, call factorial procedure
	;Print factorial
	jmp finalize 		;Finalize

;-----------------------------------------------------------------------
	;Show input error message
	inputerror:

        ;Print new line
        mov dl,0ah
        mov ah,02h
        int 21h

        mov dx,offset inputerror_message
        mov ah,09h
        int 21h

        ;Finalize program
        finalize:
        mov ah,4Ch
        int 21h
;-----------------------------------------------------------------------
	factorial:

	cmp bl,01h
	jg calculate
	mov ax,01h

	ret
;-----------------------------------------------------------------------
	calculate:

	dec bl
	call factorial
	inc bl
	mul bl

	ret
;-----------------------------------------------------------------------
END program
