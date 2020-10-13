.model small
.data
        notification db 'Insert a 3 digit number no greater than 128$'
        inputerror_message db 'ERROR: Invalid input$'

        string db 500 dup ('$')

        carry dw 00h

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
;------------------------------------------------------------------
        call store_input

        xor ax,ax

        mov al,num
        cmp ax,80h
        jg error

        call factorial_proc             ;Call factorial procedure

        call print_fact                 ;Print factorial

        jmp finalize

        error:
        call print_error

        ;Finalize program
        finalize:
        mov ah,4Ch
        int 21h
;------------------------------------------------------------------
        factorial_proc proc near

        ;Store a 1 in string
	xor ax,ax
        lea si, string
        mov al,01h
        mov [si],al
        mov cont,02h

        ;Main factorial loop
        factorial_loop:

        xor ax,ax
        xor bx,bx

        ;Check if cont is not greater than num
        mov al,cont
        mov bl,num
        cmp bl,al
        jl end_fact_loop

        call multiply_proc              ;Call multiply_proc

        inc cont                        ;Add 1 to var

        jmp factorial_loop

        end_fact_loop:

        ret
        factorial_proc endp
;------------------------------------------------------------------
        multiply_proc proc near

        lea si,string
        mov carry,00h

        ;Main multiply_loop
        multiply_loop:

        xor ax,ax
        xor bx,bx

        ;Check if i is not $
        mov al,[si]
        cmp al,24h
        je shift_string

        mov bl,cont
        ;mul bl
        mul bx
        add ax,carry

        xor bx,bx
        xor dx,dx
        mov bx,0Ah

        div bx
        mov carry,ax

        mov [si],dl

        inc si

        jmp multiply_loop

        ;Shift string if carry is not 0
        shift_string:

        xor ax,ax
        mov ax,carry
        cmp ax,00h
        ;cmp al,00h
        je end_mult

        xor bx,bx
        xor dx,dx
        xor ax,ax

        mov ax,carry

        mov bx,0Ah
        div bx

        mov carry,ax

        mov [si],dl

        inc si

        jmp shift_string

        end_mult:

        ret
        multiply_proc endp
;------------------------------------------------------------------
        carry_proc proc near

        mov carry,00h
        xor bx,bx
        xor dx,dx
        mov bx,0Ah

        div bx
        mov carry,ax

        ret
        carry_proc endp
;------------------------------------------------------------------
        print_fact proc near

        call newline

        mov cont,00h
        lea si,string

        ;Go to last char of string
        traverse_string:

        xor ax,ax

        mov al,[si]
        cmp al,24h
        je print_loop

        inc si
        inc cont

        jmp traverse_string

        print_loop:

        xor bx,bx
        dec si

        print_reverse:

        xor ax,ax

        mov bl,cont
        cmp bl,00h
        je end_print

        mov ah,02h
        mov dl,[si]
        add dl,30h
        int 21h

        dec cont

        jmp print_reverse

        end_print:

        ret
        print_fact endp
;------------------------------------------------------------------
        newline proc  near

        ;Print new line
        mov dl,0ah
        mov ah,02h
        int 21h

        ret
        newline endp
;------------------------------------------------------------------
        store_input proc near

        call newline

        xor ax,ax
        xor bx,bx
        xor cx,cx
        mov cont,00h
        mov cont2,00h

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

        ret
        store_input endp
;------------------------------------------------------------------
        print_error proc near

        call newline

        mov dx,offset inputerror_message
        mov ah,09h
        int 21h

        ret
        print_error endp
;------------------------------------------------------------------
END program
