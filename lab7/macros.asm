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
	mov total_num,al
endm
;------------------------------------------------
;Calculate square and rectangle perimeter
sqr_rect_peri macro width_num, height_num, total_num
	xor bx,bx
	sub width_num,30h
	sub height_num,30h
	add bl,width_num
	add bl,height_num
	shl bl,01h
	mov total_num,bl
endm
;------------------------------------------------
;Calculate triangle perimeter
tri_peri macro width_num, height_num, hypo_num, total_num
	xor bx,bx
	add bl,width_num
	add bl,height_num
	add bl,hypo_num
	sub bl,90h
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
	main_opt 		db "-- Main menu --",0
	first_opt 	db "1. Area and perimeter",0
	second_opt 	db "2. Calculate expressions",0
	third_opt 	db "3. Count strings",0

	area_opt 		db "1. Area",0
	peri_opt 		db "2. Perimeter",0

	square_opt 	db "1. Square",0
	rectangle_opt 	db "2. Rectangle",0
	triangle_opt 	db "3. Triangle",0

	width_opt 	db "Insert width:",0
	height_opt 	db "Insert height:",0
	hyp_opt 		db "Insert second height:",0

	a_opt 		db "Insert first number:",0
	b_opt 		db "Insert second number:",0
	c_opt 		db "Insert third number:",0

	str1_opt 		db "Insert first string:",0
	str2_opt 		db "Insert second string:",0

	input_prompt 	db "Insert option number:",0

	result_prompt 	db "Result:",0

	str1 		dw 500 dup("$")
	str2 		dw 500 dup("$")

	width_num 	db 0,0
	height_num 	db 0,0
	total_num 	db 0,0
	opt_num 		db 0,0
	shp_num 		db 0,0
	hypo_num 		db 0,0
	a_num 		db 0,0
	b_num 		db 0,0
	c_num 		db 0,0
	cont 		db 0,0

	new_line 		db 0Ah
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
	mov bl,shp_num
	cmp bl,33h
	jne ret_shapes

	xor ax,ax
	xor bx,bx
	mov al,total_num
	mov bl,02h

	div bl
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
	xor bx,bx
	mov bl,total_num
	call print_res
	read_text opt_num
	call clear_screen

	ret_expr:

	ret
shapes_proc endp
;------------------------------------------------
;Procedure to calculate expressions
expr_proc proc near

	;Ask and read a
	write_text a_opt, new_space
	read_text a_num
	sub a_num,30h

	;Check if a is a valid input
	cmp a_num,09h
	jg exit_tag
	cmp a_num,00h
	jl exit_tag
	
	;Ask and read b
	write_text b_opt, new_space
	read_text b_num
	sub b_num,30h

	;Check if b is a valid input
	cmp b_num,09h
	jg exit_tag
	cmp b_num,00h
	jl exit_tag

	;Ask and read c
	write_text c_opt, new_space
	read_text c_num
	sub c_num,30h

	;Check if c is a valid input
	cmp c_num,09h
	jg exit_tag
	cmp c_num,00h
	jl exit_tag

	xor ax,ax
	xor bx,bx

	;Expression 2 * b + 3 * (a - c)
	mov al,02h
	mul b_num
	mov total_num,al

	xor ax,ax
	mov al,03h
	mov bl,a_num
	sub bl,c_num
	mul bl
	add total_num,al

	invoke StdOut, addr new_space
	invoke StdOut, addr new_line
	write_text result_prompt, new_space
	xor bx,bx
	mov bl,total_num
	;Avoid negative number
	cmp bl,00h
	jnl no_neg1

	xor bx,bx

	no_neg1:
	call print_res

	;Expression a / b
	xor ax,ax
	xor bx,bx

	mov al,a_num
	mov bl,b_num

	;Avoid division by zero
	cmp bl,00h
	je third_expr

	div bl
	mov total_num,al

	write_text result_prompt, new_space
	xor bx,bx
	mov bl,total_num

	;Avoid negative number
	cmp bl,00h
	jnl no_neg2

	xor bx,bx

	no_neg2:
	call print_res

	third_expr:

	;Expression a * b / c
	xor ax,ax
	xor bx,bx

	mov al,a_num
	mov bl,b_num
	mul bl
	mov bl,c_num

	;Avoid division by zero
	cmp bl,00h
	je fourth_expr

	div bl
	mov total_num,al

	write_text result_prompt, new_space
	xor bx,bx
	mov bl,total_num
	;Avoid negative number
	cmp bl,00h
	jnl no_neg3

	xor bx,bx

	no_neg3:
	call print_res

	fourth_expr:

	;Expression a * (b / c)
	xor ax,ax
	xor bx,bx

	mov al,b_num
	mov bl,c_num

	;Avoid division by zero
	cmp bl,00h
	je ret_expr

	div bl
	mov bl,al
	mov al,a_num
	mul bl
	mov total_num, al

	write_text result_prompt, new_space
	xor bx,bx
	mov bl,total_num
	;Avoid negative number
	cmp bl,00h
	jnl no_neg4

	xor bx,bx

	no_neg4:
	call print_res

	ret_expr:

	;Finalize expressions
	read_text opt_num
	call clear_screen

	ret
expr_proc endp
;------------------------------------------------
;Procedure to find strings within string
str_proc proc near

	;Ask and read first string
	write_text str1_opt, new_space
	invoke StdIn, addr str1, 499
	
	;Ask and read second string
	write_text str2_opt, new_space
	invoke StdIn, addr str2, 499

	xor bx,bx
	mov cont,bl

	;Initialize cursor2
	lea edi,str2

	;Main loop to traverse and compare strings
	cmp_loop:

		;Reset cursor1
		lea esi,str1

		mov bl,00h

		;If cursor2 is $ finish loop
		cmp [edi],bl
		je ret_str

		;Move cursor1 to bl
		mov bl,[esi]

		;If cursors are equal jump to sub_str
		cmp bl,[edi]
		je sub_str

		;Increment cursors
		inc edi

	;Return to main loop
	jmp cmp_loop

	;Sub loop to compare str1 in sub_str
	sub_str:

		;If cursor1 is $ finish and inc_cont
		mov bl,00h
		cmp [esi],bl
		je inc_cont

		;Compare cursors
		mov bl,[edi]
		cmp bl,[esi]
		jne cmp_loop

		;Increment cursor1
		inc esi

		;Increment cursor2
		inc edi

	;Return to sub loop
	jmp sub_str

	;Increment cont
	inc_cont:
	inc cont

	;Return to main loop
	jmp cmp_loop
	
	;Return cont
	ret_str:
	write_text result_prompt, new_space
	xor bx,bx
	mov bl,cont
	call print_res
	read_text opt_num
	call clear_screen

	ret
str_proc endp
;------------------------------------------------
print_res proc near

	;If single digit go to print single
	cmp bl,09h
	jle printsingle

	;Reset cont
	mov cont,00h 		

	;If is not a single digit go to subthousands
	jmp subtens 	

	;Print single number
	printsingle:

	;Print digit
	mov opt_num,bl
	add opt_num,30h
	write_text opt_num, new_line

	jmp ret_print 		

	;Count tens in result if any
	subtens:

	cmp bl,0Ah
	jl printcont

	sub bl,0Ah

	inc cont

	jmp subtens

	;Print number
	printcont:

	;Print tens
	add cont,30h
	invoke StdOut, addr cont

	;Print units
	mov opt_num,bl
	add opt_num,30h
	write_text opt_num, new_line

	ret_print:

	ret
print_res endp
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
