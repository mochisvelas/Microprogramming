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

	a_opt 		db "Insert first number: ",0
	b_opt 		db "Insert second number: ",0

	str1_opt 	db "Insert first string: ",0
	str2_opt 	db "Insert second string: ",0

	input_prompt 	db "Insert option number: ",0

	new_line 	db 0Ah
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
	invoke StdOut, addr main_opt
	invoke StdOut, addr new_line
	invoke StdOut, addr first_opt
	invoke StdOut, addr new_line
	invoke StdOut, addr second_opt
	invoke StdOut, addr new_line
	invoke StdOut, addr third_opt

	;Ask and read main option number
	invoke StdOut, addr input_prompt
	invoke StdIn, addr opt_num,10

;------------------------------------------------
	;Output area or perimeter prompt
	invoke StdOut, addr area_opt
	invoke StdOut, addr new_line
	invoke StdOut, addr perim_opt
	invoke StdOut, addr new_line

	;Ask and read area or perimeter number
	invoke StdOut, addr input_prompt
	invoke StdIn, addr opt_num,10

	;Output shape prompt
	invoke StdOut, addr square_opt
	invoke StdOut, addr new_line
	invoke StdOut, addr rectangle_opt
	invoke StdOut, addr new_line
	invoke StdOut, addr triangle_opt
	invoke StdOut, addr new_line

	;Ask and read shape number
	invoke StdOut, addr input_prompt
	invoke StdIn, addr opt_num,10

;------------------------------------------------
	;Ask and read numbers
	invoke StdOut, addr a_opt
	invoke StdIn, addr a_num,10
	invoke StdOut, addr new_line
	invoke StdOut, addr b_opt
	invoke StdIn, addr b_num,10
	invoke StdOut, addr new_line

;------------------------------------------------
	;Ask and read strings
	invoke StdOut, addr str1_opt
	invoke StdIn, addr str1,10
	invoke StdOut, addr new_line
	invoke StdOut, addr str2_opt
	invoke StdIn, addr str2,10
	invoke StdOut, addr new_line

;------------------------------------------------
	;Exit program
	invoke ExitProcess,0
END program
