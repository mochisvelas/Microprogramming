.model small
.data
        notification db 'Insert option number$'
        factPrompt db '1.Print factors$'
        biPrompt db '2.Convert to binary$'

        numPrompt db 'Insert number: $'

        inputerror_message db 'ERROR: Invalid input$'

        num db 00h
        optnum db 00h

        cont db 00h
        cont2 db 00h
        tmp db 00h

.stack
.code
program:
        mov ax,@data
        mov ds,ax
        xor ax,ax

;-----------------------------------------------------------------------
        ;Ask for number
        mov dx,offset numPrompt
        mov ah,09h
        int 21h

        numtag:
        mov ah,01h              ;Get digit
        int 21h

        cmp al,0Dh              ;Check if is an enter
        jne bridge
        jmp inputerror          ;If yes, show error
        bridge:

        sub al,30h              ;Convert to real number
        xor ah,ah               ;Clear ah

        ;Store the tens and hundreds if existent
        shl bl,01h              ;Multiply itself by 2
        mov tmp,bl
        mov cl,02h
        shl bl,cl               ;Multiply itself by 4, so by 8 in total
        add bl,tmp              ;By 10 in total
        add bl,al
        mov num,bl              ;Store in variable
        inc cont                ;Add 1 to cont

        cmp cont,02h            ;Check if 2 digits have been inserted
        je factors              ;If yes, go to nextnum

        jmp numtag

;-----------------------------------------------------------------------
        factors:

        mov bl,num
        mov tmp,bl
        xor ax,ax
        xor bx,bx
        mov cl,63h
        mov cont,02h

        loopfact:

        mov al,cont
        mul cont

        cmp al,tmp
        jnle compare

        xor ah,ah

        mov al,tmp

        div cont

        cmp ah,00h
        jne increment

        mov tmp,al

        jmp printfact
;-----------------------------------------------------------------------
        increment:

        inc cont

        jmp skip
;-----------------------------------------------------------------------
        compare:

        cmp tmp,01h
        jng finalize

        jmp printemp
;-----------------------------------------------------------------------
        printfact:

        mov bl,cont      
;-----------------------------------------------------------------------
        printsingle:

        ;Print new line
        mov dl,0ah
        mov ah,02h
        int 21h

        ;Print digit
        mov dl,bl
        add dl,30h
        int 21h
	
	skip:

        loop loopfact
;-----------------------------------------------------------------------
        printemp:

        mov bl,tmp
        mov cont2,00h
;-----------------------------------------------------------------------
        subtens:

        cmp bl,0Ah
        jl printcont

        sub bl,0Ah

        inc cont2

        jmp subtens
;-----------------------------------------------------------------------
        printcont:

        ;Print new line
        mov dl,0ah
        mov ah,02h
        int 21h

        mov dl,cont2
        add dl,30h
        int 21h

        mov dl,bl
        add dl,30h
        int 21h

        jmp finalize
;-----------------------------------------------------------------------
        ;Show input error message
        inputerror:
        mov dx,offset inputerror_message
        mov ah,09h
        int 21h

        ;Finalize program
        finalize:
        mov ah,4Ch
        int 21h
END program
