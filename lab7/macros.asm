;Print text
write_text macro text, white_space
	invoke StdOut, addr text
	invoke StdOut, addr white_space
endm
;------------------------------------------------
;Read text
read_text macro text
	invoke StdIn, addr opt_num,10
endm
;------------------------------------------------
;Calculate square and rectangle area
sqr_rect_area macro w, h, total
	xor ax,ax
	mov al,w
	mul h
	add al,30h
	mov total,al
endm
;------------------------------------------------
;Calculate square and rectangle area
sqr_rect_peri macro w, h, total
	xor bx,bx
	add bl,w
	add bl,w
	add bl,h
	add bl,h
	add bl,30h
	mov total,bl
endm
;------------------------------------------------
;Calculate triangle area
tri_area macro w, h, total
	xor ax,ax
	xor bx,bx
	mov al,w
	mul h
	mov bl,02h
	div bl
	add al,30h
	mov total,al
endm
;------------------------------------------------
;Calculate triangle perimeter
tri_peri macro w, h, l, total
	xor bx,bx
	add bl,w
	add bl,h
	add bl,l
	add bl,30h
	mov total,bl
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
	main_opt 	db "-- Main menu --",0
	first_opt 	db "1. Area and perimeter",0
	second_opt 	db "2. Calculate expressions",0
	third_opt 	db "3. Count strings",0

	area_opt 	db "1. Area",0
	peri_opt 	db "2. Perimeter",0

	square_opt 	db "1. Square",0
	rectangle_opt 	db "2. Rectangle",0
	triangle_opt 	db "3. Triangle",0

	width_opt 	db "Insert width:",0
	height_opt 	db "Insert height:",0
	hyp_opt 	db "Insert second height:",0

	a_opt 		db "Insert first number:",0
	b_opt 		db "Insert second number:",0

	str1_opt 	db "Insert first string:",0
	str2_opt 	db "Insert second string:",0

	input_prompt 	db "Insert option number:",0

	new_line 	db 0Ah
	new_space 	db 20h

.data?
	opt_num 	db 50 dup(?)
	shp_num 	db 50 dup(?)
	width_num 	db 50 dup(?)
	height_num 	db 50 dup(?)
	hypo_num 	db 50 dup(?)
	a_num 		db 50 dup(?)
	b_num 		db 50 dup(?)
	total_num 	db 50 dup(?)
	str1 		db 100 dup(?)
	str2 		db 100 dup(?)
.const

.code
program:

	main_tag:

	;Output main prompt
	write_text main_opt, new_line
	write_text first_opt, new_line
	write_text second_opt, new_line
	write_text third_opt, new_line

	;Ask and read main option number
	write_text input_prompt, new_space
	read_text opt_num,10

	;Clear screen
	call clear_screen

	xor bx,bx
	mov bl,opt_num

	;Jump to shapes if option is 1
	cmp bl,31h
	je shapes_tag

	;Jump to expression if option is 2
	cmp bl,32h
	je expr_tag

	;Jump to strings if option is 3
	cmp bl,33h
	je str_tag

	;Exit program if option is greater than 3
	jmp exit_tag

	;Call shapes and return to main
	shapes_tag:
	call shapes_proc
	jmp main_tag

	;Call expressions and return to main
	expr_tag:
	call expr_proc
	jmp main_tag

	;Call strings and return to main
	str_tag:
	call str_proc
	jmp main_tag
;------------------------------------------------
;Procedure to calculate area and perimeter
shapes_proc proc near

	;Output area or perimeter prompt
	write_text area_opt, new_line
	write_text peri_opt, new_line

	;Output shape prompt
	write_text square_opt, new_line
	write_text rectangle_opt, new_line
	write_text triangle_opt, new_line

	;Ask and read shape number
	write_text input_prompt, new_space
	read_text shp_num,10

	;Ask and read area or perimeter number
	write_text input_prompt, new_space
	read_text opt_num,10

	xor bx,bx
	mov bl,shp_num

	;Output height and width prompt
	write_text width_opt, new_space
	read_text width_num,10
	write_text height_opt, new_space
	read_text height_num,10

	cmp bl,01h
	je sqr_tag

	cmp bl,02h
	je sqr_tag

	cmp bl,03h
	jne exit_tag

	;Output second height
	write_text hyp_opt, new_space
	read_text hypo_num,10

	sqr_tag:
	
	xor ax,ax
	mov al,opt_num

	cmp al,01h
	je area_tag

	cmp al,02h
	je peri_tag

	jmp exit_tag

	area_tag:
	sqr_rect_area height_num, width_num, total_num

	peri_tag:
	sqr_rect_peri height_num, width_num, total_num

	ret
shapes_proc endp
;------------------------------------------------
;Procedure to calculate expressions
expr_proc proc near

	;Ask and read numbers
	write_text a_opt, new_space
	read_text a_num,10
	
	write_text b_opt, new_space
	read_text b_num,10

	ret
expr_proc endp
;------------------------------------------------
;Procedure to find strings within string
str_proc proc near

	;Ask and read strings
	write_text str1_opt, new_space
	read_text str1,10
	
	write_text str2_opt, new_space
	read_text str2,10
	
	ret
str_proc endp

;------------------------------------------------
;Procedure found in m32lib
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
	exit_tag:

	;Exit program
	invoke ExitProcess,0
END program
