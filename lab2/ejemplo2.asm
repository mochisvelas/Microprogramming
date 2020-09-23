.model small				
.data
	A DB 3h
	B DB 2h
	C DB 1h
.stack
.code					
program:				
		Mov AX,@DATA		; Get data segment start address
		Mov DS,AX		; Assign data segment register to data segment start address

		Xor AX,AX

		;a. A + C
		Mov AL,A		; Assign value to lower part of AX
		Add AL,C
		Add AL,30h
	
		;print a.
		Mov DL,AL
		Mov AH,02h 		; Assign print value to high part of accumulator
		Int 21h			; Invoke DOS 21h interruption

		;print space
		Mov DL,20h
		Mov AH,02h
		Int 21h

		;b. A - B
		Mov AL,A		; Assign value to lower part of AX
		Sub AL,B
		Add AL,30h

		;print b.
		Mov DL,AL		; Store result in DL register
		Mov AH,02h		; Assign print value to high part of accumulator
		Int 21h			; Invoke DOS 21h interruption

		;print space
		Mov DL,20h
		Mov AH,02h
		Int 21h

		;c. A + B + 2C
		Mov AL,A 		; Add both registers
		Add AL,B
		Add AL,C
		Add AL,C
		Add AL,30h

		;print c.
		Mov DL,AL 		; Store the result in DL register
		Mov AH,02		; Assign print value to high part of accumulator
		Int 21h			; Invoke DOS 21h interruption

		;print space
		Mov DL,20h
		Mov AH,02h
		Int 21h

		;d. A - B + C
		Mov AL,A
		Sub AL,B 		; Substract registers
		Add AL,C 		; Add result of A - B to C
		Add AL,30h

		;print d.
		Mov DL,AL 		; Store result in DL register
		Mov AH,02		; Assign print value to high part of accumulator
		Int 21h			; Invoke DOS 21h interruption

		Mov AH,4CH		; Assing finalization value
		Int 21h			; Invoke DOS 21h interruption to finalize
End program
