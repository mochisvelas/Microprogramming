;Print text
write_text macro text, white_space
	invoke StdOut, addr text
	invoke StdOut, addr white_space
endm
;------------------------------------------------
;Write num
write_num macro number
	add number,30h
	invoke StdOut, addr number
endm
;------------------------------------------------
;Read text
read_text macro text
	invoke StdIn, addr text,10
endm
;------------------------------------------------
;Map positions in matrix
mapping macro i, j, rows, columns, size
	mov al,i
	mov bl,columns
	mul bl
	mov bl,size
	mul bl
	mov cl,al
	mov al,j
	mov bl,size
	mul bl
	add al,cl
endm
;------------------------------------------------

.386
.model flat,stdcall

option casemap:none

INCLUDE \masm32\include\windows.inc
INCLUDE \masm32\include\masm32.inc
INCLUDE \masm32\include\masm32rt.inc
INCLUDE \masm32\include\kernel32.inc

locate PROTO :DWORD,:DWORD

.data
	main_opt 	db "-- Problem 1 --",0

	rows_opt 	db "Insert rows:",0
	columns_opt 	db "Insert columns:",0

	result_prompt 	db "Matrix size:",0

	cell_prompt 	db "Insert number:",0

	i 		db 0,0
	j 		db 0,0
	rows 		db 0,0
	columns 	db 0,0
	matrix 		db 200 dup('$')

	cont 		db 0,0
	matrix_size 	db 0,0

	cursor 		db 0,0

	units 		db 0,0
	tens 		db 0,0

	cell 		db 0,0

	new_line 	db 0Ah
	new_space 	db 20h

.const

.code
program:

	tag_main:

	call main_proc

	jmp tag_main

;------------------------------------------------
;Main procedure
main_proc proc near

	xor ax,ax
	xor bx,bx

	;Output main prompt
	write_text main_opt, new_line

	;Ask and read rows
	write_text rows_opt, new_space
	read_text rows

	mov al,rows

	;Exit if nothing inserted
	cmp al,00h
	je tag_exit

	sub al,30h

	;Exit if greater than 9
	cmp al,09h
	jg tag_exit

	mov rows,al

	;Ask and read columns
	invoke StdOut, addr new_space
	write_text columns_opt, new_space
	read_text columns

	mov bl,columns

	;Exit if nothing inserted
	cmp bl,00h
	je tag_exit

	sub bl,30h

	;Exit if greater than 9
	cmp bl,09h
	jg tag_exit

	mov columns,bl

	xor ax,ax
	xor bx,bx

	;Calculate matrix size
	mov al,rows
	mov bl,columns

	mul bl

	;Store and write size in cont
	mov cont,al

	invoke StdOut, addr new_space
	write_text result_prompt,new_space
	mov bl,cont
	mov matrix_size,bl
	call print_num
	read_text cont

	;Call fill_matrix procedure
	call fill_matrix

	call order_matrix

	;Call print_matrix procedure
	call print_matrix
	read_text cont

	;Clear screen
	call clear_screen

	ret
main_proc endp
;------------------------------------------------
;Procedure to fill matrix
fill_matrix proc near

	mov cont,00h
	lea esi,matrix

	l_fill:
		mov cl,cont
		cmp cl,matrix_size
		je ret_fill

		write_text cell_prompt,new_space
		read_text cell
		sub cell,30h

	  	xor ebx,ebx
	  	mov bl,cell
	  	mov [esi],ebx

		inc esi
		inc cont

	jmp l_fill

	ret_fill:

	ret
fill_matrix endp
;------------------------------------------------
;Procedure to order matrix
order_matrix proc near
	
	xor ax,ax
	xor bx,bx
	xor cx,cx
	mov i,00h
	mov j,00h
	mov bl,matrix_size
	mov cont,bl

	i_order:

		mov al,cont
		sub al,i
		dec al

		mov cursor,al
		lea esi,matrix
		lea edi,matrix
		inc edi

		mov j,00h

		j_order:
			
			mov bl,[esi]
			cmp bl,[edi]
			jng no_swap

			mov al,[edi]
			mov [esi],al
			mov [edi],bl

			no_swap:

			inc esi
			inc edi

			inc j
			mov cl,j
			cmp cl,cursor
			jl j_order

			inc i
			mov cl,i
			cmp cl,cont
			jl i_order

	ret
order_matrix endp
;------------------------------------------------
;Procedure to print number
print_matrix proc near

	mov i,00h

	i_pmatrix:

		mov j,00h
		invoke StdOut, addr new_line

		j_pmatrix:

		   lea esi,matrix
		   mapping i, j, rows, columns, 01h
		   add esi,eax

		   mov bl,[esi]
		   mov units,bl
		   write_num units

		   invoke StdOut, addr new_space

		   inc j
		   mov cl,j
		   cmp cl,columns

		jl j_pmatrix

		   inc i
		   mov cl,i
		   cmp cl,rows

	jl i_pmatrix

	ret
print_matrix endp
;------------------------------------------------
;Procedure to print number
print_num proc near

        ;Reset tens
        mov tens,00h

        ;If single digit printcont
        cmp bl,09h
        jle printcont

        ;If is not a single digit sub tens
        jmp subtens

        ;Count tens in result if any
        subtens:

        cmp bl,0Ah
        jl printcont

        sub bl,0Ah

        inc tens

        jmp subtens

        ;Print number
        printcont:

        ;Print tens
        write_num tens

        ;Print units
        mov units,bl
        write_num units

        ret_print:

        ret
print_num endp
;------------------------------------------------
;Procedure to clear screen found in masm32\m32lib\clearscr.asm
clear_screen proc

    LOCAL hOutPut:DWORD
    LOCAL noc    :DWORD
    LOCAL cnt    :DWORD
    LOCAL sbi    :CONSOLE_SCREEN_BUFFER_INFO

    invoke GetStdHandle,STD_OUTPUT_HANDLE
    mov hOutPut, eax

    invoke GetConsoleScreenBufferInfo,hOutPut,ADDR sbi

    mov eax, sbi.dwSize    

    push ax
    rol eax, 16
    mov cx, ax
    pop ax
    mul cx
    cwde
    mov cnt, eax

    invoke FillConsoleOutputCharacter,hOutPut,32,cnt,NULL,ADDR noc

    invoke locate,0,0

    ret

clear_screen endp
;------------------------------------------------
	tag_exit:

	;Exit program
	invoke ExitProcess,0
END program
