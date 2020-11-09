;Print text
write_text macro text, white_space
	invoke StdOut, addr text
	invoke StdOut, addr white_space
endm
;------------------------------------------------
;Read text
read_text macro text
	invoke StdIn, addr text,10
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

	rows 		db 0,0
	columns 	db 0,0

	cont 		db 0,0

	new_line 	db 0Ah
	new_space 	db 20h

.const

.code
program:

	tag_main:

	;Output main prompt
	write_text main_opt, new_line

	;Ask and read rows
	write_text rows_opt, new_space
	read_text rows

	;Ask and read columns
	invoke StdOut, addr new_space
	write_text columns_opt, new_space
	read_text columns

	sub rows,30h
	sub columns,30h
	xor bx,bx
	xor ax,ax

	mov al,rows

	;Exit if greater than 9
	cmp al,09h
	jg tag_exit

	mov bl,columns

	;Exit if greater than 9
	cmp bl,09h
	jg tag_exit

	mul bl

	mov cont,al
	add cont,30h

	invoke StdOut, addr new_space
	write_text result_prompt,new_space
	write_text cont,new_line
	read_text rows

	;Clear screen
	call clear_screen
	
	jmp tag_exit

;------------------------------------------------
;Procedure to clear screen found in m32lib
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
