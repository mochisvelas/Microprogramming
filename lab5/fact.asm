.model small
.data
        notification db 'Insert a 3 digit number no greater than 128$'
        inputerror_message db 'ERROR: Invalid input$'

	string db 300 dup ('$')

	aux_string db 300 dup ('$')

        carry db 00h

        ;Input num
        num db 00h

        ;Aux variables
        cont db 00h
        cont2 db 00h

.stack
.code
program:
        mov ax,@data
        mov ds,ax
        xor ax,ax
        xor bx,bx
;-----------------------------------------------------------------------
	call store_input

        ;Check if num is not greater than 128
        checknum:

	xor ax,ax

	mov al,num
        cmp ax,80h
        jg error

        call factorial          	;Call factorial procedure

        call print_factorial    	;Print factorial

	jmp finalize

	error:
	call print_error

        ;Finalize program
        finalize:
        mov ah,4Ch
        int 21h
;-----------------------------------------------------------------------
        factorial proc  near

	call num2string 		;Proc to convert input num to string
	call dup_string 		;Proc to duplicate string

        fact_loop:

	cmp num,00h
        je end_fact_loop

	dec num

	call mult_strings

	call dup_string

        jmp fact_loop

        end_fact_loop:

        ret
        factorial endp
;-----------------------------------------------------------------------
        mult_strings proc  near

	xor cx,cx
	xor ax,ax
	xor bx,bx
	mov al,num
	mov cont2,al
	mov carry,00h
	xor ax,ax

	lea si,string
	lea di,aux_string

	;Multiply strings loop
	mult_loop:

	mov cl,cont2
	cmp cl,00h
	je eval_carry

	mov al,[si]
	mov bl,[di]

	add al,bl
	add al,carry

	call calc_carry_proc

	mov [si],al

	inc si
	inc di
	dec cont2

	jmp mult_loop

	eval_carry:

	cmp carry,00h
	je end_mult_loop

	;Loop to shift string if there's a carry in the end
	shift_string:

	mov al,[si]

	cmp al,24h
	je add_last_carry

	add al,carry

	call calc_carry_proc

	mov [si],al

	inc si

	jmp shift_string

	add_last_carry:
	cmp carry,00h
	je end_mult_loop

	mov al,carry
	mov [si],al

	end_mult_loop:
	xor ax,ax
	xor bx,bx

        ret
        mult_strings endp
;-----------------------------------------------------------------------
        num2string proc  near

	mov bl,num
	lea si,string
	mov cont,00h
	mov cont2,00h

        subhundreds:

        cmp bl,64h
        jl subtens

        sub bl,64h

        inc cont

        cmp bl,09h
        jle store_num

        jmp subhundreds

        ;Count tens in result if any
        subtens:

        cmp bl,0Ah
        jl store_num

        sub bl,0Ah

        inc cont2

        jmp subtens

        store_num:
	mov [si],bl

	inc si
	mov al,cont2
	mov [si],al

	inc si
	mov al,cont
	mov [si],al

	xor bx,bx
	xor ax,ax

        ret
        num2string endp
;-----------------------------------------------------------------------
	dup_string proc near

	lea si,string
	lea di,aux_string

	copy_string:

	mov bl,[si]

	cmp bl,24h
	je end_copy

	mov [di],bl

	inc si
	inc di

	jmp copy_string
	
	end_copy:
	xor bx,bx

	ret
	dup_string endp
;-----------------------------------------------------------------------
        calc_carry_proc proc near

	mov carry,00h

        calc_carry_loop:

        cmp al,0Ah
        jl end_carry_loop

        sub al,0Ah

        inc carry

        jmp calc_carry_loop

        end_carry_loop:

        ret
        calc_carry_proc endp
;-----------------------------------------------------------------------
        print_factorial proc  near

	call newline

	mov cont,00h
	lea si,string

	traverse_string:

	mov al,[si]
	cmp al,24h
	je print_loop

	inc si
	inc cont

	jmp traverse_string

	print_loop:

	mov cl,cont
	dec si

	print_reverse:

	mov cl,cont
	cmp cl,00h
	je end_print

	mov al,[si]
	add al,30h

	mov ah,02h
	mov dl,al
	int 21h

	dec cont

	jmp print_reverse

	end_print:

        ret
        print_factorial endp
;-----------------------------------------------------------------------
        newline proc  near

        ;Print new line
        mov dl,0ah
        mov ah,02h
        int 21h

        ret
        newline endp
;-----------------------------------------------------------------------
        store_input proc near

        call newline

        ;Ask for the input number
        mov dx, offset notification
        mov ah,09h
        int 21h

        call newline

        numtag:
        mov ah,01h              ;Get digit
        int 21h

        cmp al,0Dh              ;Check if is an enter
        jne bridge
	call print_error
	jmp return_input
        bridge:

        sub al,30h              ;Convert to real number
        xor ah,ah               ;Clear ah

        ;Store the tens and hundreds if existent
        shl bl,01h              ;Multiply itself by 2
        mov cont2,bl
        mov cl,02h
        shl bl,cl               ;Multiply itself by 4, so by 8 in total
        add bl,cont2            ;By 10 in total
        add bl,al
        mov num,bl              ;Store in variable
        inc cont                ;Add 1 to cont

        cmp cont,03h            ;Check if 3 digits have been inserted
        je return_input         ;If yes, go to checknum

	jmp numtag

	return_input:
	xor ax,ax
	xor bx,bx
	xor cx,cx
	mov cont,00h
	mov cont2,00h

        ret
        store_input endp
;-----------------------------------------------------------------------
        print_error proc near

	call newline

        mov dx,offset inputerror_message
        mov ah,09h
        int 21h

        ret
        print_error endp
;-----------------------------------------------------------------------
END program
