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

.386
.model flat,stdcall

option casemap:none

INCLUDE \masm32\include\windows.inc
INCLUDE \masm32\include\masm32.inc
INCLUDE \masm32\include\masm32rt.inc
INCLUDE \masm32\include\kernel32.inc


.data
	main_opt 	db "-- Main menu --",0
	first_opt 	db "1. Area and perimeter",0
	second_opt 	db "2. Calculate expressions",0
	third_opt 	db "3. Count strings",0

	area_opt 	db "1. Area",0
	perim_opt 	db "2. Perimeter",0

	square_opt 	db "1. Square",0
	rectangle_opt 	db "2. Rectangle",0
	triangle_opt 	db "3. Triangle",0

	a_opt 		db "Insert first number:",0
	b_opt 		db "Insert second number:",0

	str1_opt 	db "Insert first string:",0
	str2_opt 	db "Insert second string:",0

	input_prompt 	db "Insert option number:",0

	new_line 	db 0Ah
	new_space 	db 20h
.data?
	opt_num 	db 50 dup(?)
	a_num 		db 50 dup(?)
	b_num 		db 50 dup(?)
	str1 		db 100 dup(?)
	str2 		db 100 dup(?)
.const

.code
program:
	;Output main prompt
	write_text main_opt, new_line
	write_text first_opt, new_line
	write_text second_opt, new_line
	write_text third_opt, new_line
	

	;Ask and read main option number
	write_text input_prompt, new_space
	read_text opt_num,10

;------------------------------------------------
	;Output area or perimeter prompt
	write_text area_opt, new_line
	write_text perim_opt, new_line

	;Ask and read area or perimeter number
	write_text input_prompt, new_space
	read_text opt_num,10

	;Output shape prompt
	write_text square_opt, new_line
	write_text rectangle_opt, new_line
	write_text triangle_opt, new_line
	

	;Ask and read shape number
	write_text input_prompt, new_space
	read_text opt_num,10

;------------------------------------------------
	;Ask and read numbers
	write_text a_opt, new_space
	read_text a_num,10
	
	write_text b_opt, new_space
	read_text b_num,10
	

;------------------------------------------------
	;Ask and read strings
	write_text str1_opt, new_space
	read_text str1,10
	
	write_text str2_opt, new_space
	read_text str2,10
	

;------------------------------------------------
	;Exit program
	invoke ExitProcess,0
END program
