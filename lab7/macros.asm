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
;Calculate square and rectangle area
sqr_rect_area macro width_num, height_num, total_num
	xor ax,ax
	mov al,width_num
	sub al,30h
	sub height_num,30h
	mul height_num
	add al,30h
	mov total_num,al
endm
;------------------------------------------------
;Calculate square and rectangle perimeter
sqr_rect_peri macro width_num, height_num, total_num
	xor bx,bx
	add bl,width_num
	add bl,height_num
	shl bl,01h
	sub bl,90h
	mov total_num,bl
endm
;------------------------------------------------
;Calculate triangle perimeter
tri_peri macro width_num, height_num, hypo_num, total_num
	xor bx,bx
	add bl,width_num
	add bl,height_num
	add bl,hypo_num
	sub bl,60h
	mov total_num,bl
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

	result_prompt 	db "Result:",0

	width_num 	db 0,0
	height_num 	db 0,0
	total_num 	db 0,0
	opt_num 	db 0,0
	shp_num 	db 0,0
	hypo_num 	db 0,0
	a_num 		db 0,0
	b_num 		db 0,0

	str1 		dw 100 dup("$")
	str2 		dw 100 dup("$")

	new_line 	db 0Ah
	new_space 	db 20h

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
	read_text opt_num

	xor bx,bx
	mov bl,opt_num

	;Clear screen
	call clear_screen

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
	invoke StdOut, addr new_space
	write_text area_opt, new_line
	write_text peri_opt, new_line

	;Ask and read area or perimeter number
	write_text input_prompt, new_space
	read_text opt_num

	xor bx,bx
	mov bl,opt_num

	;If not an option exit
	cmp bl,32h
	jg exit_tag
	cmp bl,31h
	jl exit_tag

	;Clear screen
	call clear_screen

	;Output shape prompt
	invoke StdOut, addr new_space
	write_text square_opt, new_line
	write_text rectangle_opt, new_line
	write_text triangle_opt, new_line

	;Ask and read shape number
	write_text input_prompt, new_space
	read_text shp_num

	xor bx,bx
	mov bl,shp_num

	;If not an option exit
	cmp bl,33h
	jg exit_tag
	cmp bl,31h
	jl exit_tag

	;Clear screen
	call clear_screen

	;Output width prompt
	invoke StdOut, addr new_space
	write_text width_opt, new_space
	read_text width_num

	;Copy width to height in case square
	xor ax,ax
	mov al,width_num
	mov height_num,al

	xor bx,bx
	mov bl,shp_num

	;If square do not ask height
	cmp bl,31h
	je trig_tag

	;Output height prompt that will overwrite height_num
	invoke StdOut, addr new_space
	write_text height_opt, new_space
	read_text height_num

	;If rectangle do not ask second height
	cmp bl,32h
	je trig_tag

	xor bx,bx
	mov bl,opt_num

	;If area do not ask second height
	cmp bl,31h
	je trig_tag

	;Output second height if triangle and perimeter
	invoke StdOut, addr new_space
	write_text hyp_opt, new_space
	read_text hypo_num

	;Trigonometric tag to calculate result
	trig_tag:

	xor bx,bx
	mov bl,opt_num

	;Jump to area or perimeter
	cmp bl,31h
	je area_tag
	jmp peri_tag

	;Clear screen
	call clear_screen

	area_tag:

	;Square and rectangle area macro
	sqr_rect_area width_num, height_num, total_num

	;If triangle div area by 2
	cmp bl,33h
	jne ret_shapes

	xor ax,ax
	xor bx,bx
	mov al,total_num
	sub al,30h
	mov bl,02h
	div bl
	add al,30h
	mov total_num,al

	;Return result
	jmp ret_shapes

	peri_tag:

	;If triangle jump to tri_peri_tag
	xor bx,bx
	mov bl,shp_num
	cmp bl,33h
	je tri_peri_tag

	;Square and rectangle perimeter macro
	sqr_rect_peri width_num, height_num, total_num

	;Return result
	jmp ret_shapes

	tri_peri_tag:

	;Triangle perimeter macro
	tri_peri width_num, height_num, hypo_num, total_num

	;Return result and clear screen
	ret_shapes:
	invoke StdOut, addr new_space
	write_text result_prompt, new_space
	write_text total_num, new_line
	read_text opt_num
	call clear_screen

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
	exit_tag:

	;Exit program
	invoke ExitProcess,0
END program
