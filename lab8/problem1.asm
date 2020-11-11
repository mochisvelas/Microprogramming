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

	i 			db 0,0
	j 			db 0,0
	rows 		db 0,0
	columns 	db 0,0

	cont 		db 0,0

	units 		db 0,0
	tens 		db 0,0

	matrix 		db 100 dup('$')

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

	sub rows,30h

	mov al,rows

	;Exit if greater than 9
	cmp al,09h
	jg tag_exit

	;Ask and read columns
	invoke StdOut, addr new_space
	write_text columns_opt, new_space
	read_text columns

	sub columns,30h

	mov bl,columns

	;Exit if greater than 9
	cmp bl,09h
	jg tag_exit

	xor ax,ax
	xor bx,bx

	mov al,rows
	mov bl,columns

	mul bl

	mov cont,al

	invoke StdOut, addr new_space
	write_text result_prompt,new_space
	mov bl,cont
	call print_num
	read_text cont

	;Call fill_matrix procedure
	call fill_matrix
	read_text cont

	;Clear screen
	call clear_screen

	ret
main_proc endp
;------------------------------------------------
;Procedure to fill matrix
fill_matrix proc near

	lea esi,matrix
	mov i,00h

	loop_rows:

		mov j,00h
		invoke StdOut, addr new_line

		loop_columns:

			mapping i, j, rows, columns, 02h
			mov bl,al
			call print_num
			invoke StdOut, addr new_space

			inc j
			mov cl,j
			cmp cl,columns
			jl loop_columns

			inc i
			mov cl,i
			cmp cl,rows
			jl loop_rows

	ret
fill_matrix endp
;------------------------------------------------
inc_cursor proc near

	ret
inc_cursor endp
;------------------------------------------------
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
