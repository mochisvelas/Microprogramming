.model small
.data
        numPrompt db 'Insert number: $'

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

        ;Ask for number
        mov dx,offset numPrompt
        mov ah,09h
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
        mov num,bl              ;Store in variable
        inc cont                ;Add 1 to cont

        cmp cont,02h            ;Check if 2 digits have been inserted
        je evalnum              ;If yes, go to nextnum

        jmp numtag
;-----------------------------------------------------------------------
        evalnum:

	;Clean registers
	xor ax,ax
	xor bx,bx
	xor cx,cx

        mov bl,num 		;Store num in bl
        mov cl,07h 		;Times to iterate the binary loop

	;Print new line
        mov ah,02h
        mov dl,0ah
        int 21h

	;Binary loop
        binary:

        xor al,al

        shl bl,01h 		;Shift to left and store the msb in cf flag
        adc al,00h 		;Add with carry. al = al + cf + 0

	;Print al
	mov ah,02h
        mov dl,al
        add dl,30h
        int 21h

	;Check if cl is 0
        cmp cl,00h
        je finalize

        dec cl 			;Sub 1 to cl

        jmp binary 		;Iterate again
;-----------------------------------------------------------------------
        ;Show input error message
        inputerror:

	;Print new line
        mov ah,02h
        mov dl,0ah
        int 21h

        mov dx,offset inputerror_message
        mov ah,09h
        int 21h

        ;Finalize program
        finalize:
        mov ah,4Ch
        int 21h
END program
