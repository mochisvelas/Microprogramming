.model small
.data
        notification db 'Insert a 3 digit number no greater than 128$'
	inputerror_message db 'ERROR: Invalid input$'

	;Aux strings
	units_str db '$'
	tens_str db '0$'
	hundreds_str db '00$'

	;Result string
	res_str db '1$'

	carry db 00h
	remainder db 00h

	;Aux strings indexes
	units_i dw 00h
	tens_i dw 00h
	hundreds_i dw 00h
	res_i dw 00h

	;Conts of operand values
	units_cont db 00h
	tens_cont db 00h
	hundreds_cont db 00h


	;Input num
	num db 00h

	;Aux variables for input num
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
	factorial proc near

	;Store initial addresses of strings
	lea si,units_str
	mov units_i,si

	lea si,tens_str
	inc si
	mov tens_i,si

	lea si,hundreds_str
	inc si
	inc si
	mov hundreds_i,si

	lea si,res_str
	mov res_i,si
	mov cont,00h

	inc cont

	inc num

	fact_loop:

	mov cl,cont
	cmp cl,num
	je end_fact_loop 

	mov bl,cont

	call multiply

	inc cont 			;Add 1 to cont

	jmp fact_loop

	end_fact_loop:

	ret
	factorial endp
;-----------------------------------------------------------------------
	multiply proc near

	mov units_cont,00h
	mov tens_cont,00h
	mov hundreds_cont,00h

	call split_operand

	call mult_units_proc

	call mult_tens_proc

	call mult_hundreds_proc

	call summa_proc

	ret
	multiply endp
;-----------------------------------------------------------------------
	split_operand proc near

	subhundreds:

	cmp bl,64h
	jl subtens

	sub bl,64h

	inc hundreds_cont

	cmp bl,09h
	jle printcont

	jmp subhundreds

	;Count tens in result if any
	subtens:

	cmp bl,0Ah
	jl store_unit

	sub bl,0Ah

	inc tens_cont

	jmp subtens

	store_unit:
	mov units_cont,bl

	ret
	split_operand endp
;-----------------------------------------------------------------------
	mult_units_proc proc near

	mov si,[res_i]
	mov di,[units_i]

	;Multiply units by res_str loop
	mult_units_loop:

	mov al,res_str[si] 			;Store first char of res_str in al
	comp al,24h 				;Compare if current char is $
	je end_units_loop 			;If yes go to end_units_loop
	
	mov bl,units_cont 			;Store units_cont in bl

	mul bl 					;Mult al by units_cont

	add al,carry 				;Add existent carry to al

	call calc_carry_proc 			;Call calc_carry_proc

	mov byte ptr[di],remainder 		;Store remainder in units_str

	inc di 					;Add 1 to di
	inc si 					;Add 1 to si

	jmp mult_units_loop 			;Iterate again

	end_units_loop:
	mov remainder,00h
	mov carry,00h

	ret
	mult_units_proc endp
;-----------------------------------------------------------------------
	mult_tens_proc proc near

	mov si,[res_i]
	mov di,[tens_i]

	;Multiply tens by res_str loop
	mult_tens_loop:

	mov al,res_str[si] 			;Store each char of res_str in al
	comp al,24h 				;Compare if current char is $
	je end_tens_loop 			;If yes go to end_units_loop
	
	mov bl,tens_cont 			;Store units_cont in bl

	mul bl 					;Mult al by units_cont

	add al,carry 				;Add existent carry to al

	call calc_carry_proc 			;Call calc_carry_proc

	mov byte ptr[di],remainder 		;Store remainder in units_str

	inc di 					;Add 1 to di
	inc si 					;Add 1 to si

	jmp mult_tens_loop 			;Iterate again

	end_tens_loop:
	mov remainder,00h
	mov carry,00h

	ret
	mult_tens_proc endp
;-----------------------------------------------------------------------
	mult_hundreds_proc proc near

	mov si,[res_i]
	mov di,[hundreds_i]

	;Multiply hundreds by res_str loop
	mult_hundreds_loop:

	mov al,res_str[si] 			;Store each char of res_str in al
	comp al,24h 				;Compare if current char is $
	je end_hundreds_loop 			;If yes go to end_units_loop
	
	mov bl,hundreds_cont 			;Store units_cont in bl

	mul bl 					;Mult al by units_cont

	add al,carry 				;Add existent carry to al

	call calc_carry_proc 			;Call calc_carry_proc

	mov byte ptr[di],remainder 		;Store remainder in units_str

	inc di 					;Add 1 to di
	inc si 					;Add 1 to si

	jmp mult_hundreds_loop 			;Iterate again

	end_hundreds_loop:
	mov remainder,00h
	mov carry,00h

	ret
	mult_hundreds_proc endp
;-----------------------------------------------------------------------
	calc_carry_proc proc near

	calc_carry_loop:

	cmp al,0Ah
	jl store_remainder

	sub bl,0Ah

	inc carry

	jmp calc_carry_loop

	store_remainder:
	mov remainder,al

	ret
	calc_carry_proc endp
;-----------------------------------------------------------------------
	summa_proc proc near


	ret
	summa_proc endp
;-----------------------------------------------------------------------
	newline proc near

        ;Print new line
        mov dl,0ah
        mov ah,02h
        int 21h

	ret
	newline endp
;-----------------------------------------------------------------------
END program
