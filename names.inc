TITLE Color String Example              (ColorStr.asm)

; This program writes a multicolor string on the display.
; Last update: 8/21/01


.data

ATTRIB_HI = 10000000b
str0 BYTE "Aziz Ullah ",0
str1 BYTE "Najeeb Khan ",0
str2 BYTE "                                    Rehmat Ullah ",0
msg byte " : Project members :"
color  BYTE 03
.code

print_char PROC

	mov  ax,@data
	mov  ds,ax
	
;	call ClrScr
	call EnableBlinking
	mov  cx, 20
	mov  si, offset msg
mov dl,25
mov dh,8
call gotoxy

L:	push cx	; save loop counter
	mov  ah,9      	; write character/attribute
	mov  al,[si]   	; character to display
	mov  bh,0      	; video page 0
	mov  bl,color	; attribute
	or   bl,ATTRIB_HI	; set blink/intensity bit
	mov  cx,1     	; display it one time
	int  10h
	mov  cx,1	; advance cursor to
	call AdvanceCursor	; next screen column
	;inc  color	; next color
	inc  si	; next character
	pop  cx	; restore loop counter
	Loop L

	
	call Crlf
	
	mov  cx, 12
	mov  si, offset str0

mov dl,20
mov dh,13
call gotoxy

L3:	push cx	; save loop counter
	mov  ah,9      	; write character/attribute
	mov  al,[si]   	; character to display
	mov  bh,0      	; video page 0
	mov  bl,color	; attribute
	or   bl,ATTRIB_HI	; set blink/intensity bit
	mov  cx,1     	; display it one time
	int  10h
	mov  cx,1	; advance cursor to
	call AdvanceCursor	; next screen column
	;inc  color	; next color
	inc  si	; next character
	pop  cx	; restore loop counter
	Loop L3

	
	call Crlf
mov dl,30
mov dh,16
call gotoxy

	mov  cx, 12
	mov  si, offset str1	
L4:	push cx	; save loop counter
	mov  ah,9      	; write character/attribute
	mov  al,[si]   	; character to display
	mov  bh,0      	; video page 0
	mov  bl,color	; attribute
	or   bl,ATTRIB_HI	; set blink/intensity bit
	mov  cx,1     	; display it one time
	int  10h
	mov  cx,1	; advance cursor to
	call AdvanceCursor	; next screen column
	;inc  color	; next color
	inc  si	; next character
	pop  cx	; restore loop counter
	Loop L4


mov dl,25
mov dh,18
call gotoxy
	call Crlf
	mov  cx, 50
	mov  si, offset str2	
L5:	push cx	; save loop counter
	mov  ah,9      	; write character/attribute
	mov  al,[si]   	; character to display
	mov  bh,0      	; video page 0
	mov  bl,color	; attribute
	or   bl,ATTRIB_HI	; set blink/intensity bit
	mov  cx,1     	; display it one time
	int  10h
	mov  cx,1	; advance cursor to
	call AdvanceCursor	; next screen column
	;inc  color	; next color
	inc  si	; next character
	pop  cx	; restore loop counter
	Loop L5

mov dl,100
mov dh,100
call gotoxy

ret
print_char ENDP
;--------------------------------------------------
EnableBlinking PROC
;
; Enable blinking (using the high bit of color
; attributes). In MS-Windows, this only works if
; the program is running in full-screen mode.
; Receives: nothing.
; Returns: nothing
;--------------------------------------------------
	push ax
	push bx
	mov ax,1003h
	mov bl,1	; blinking is enabled
	int 10h
	pop bx
	pop ax
	ret
EnableBlinking ENDP

;--------------------------------------------------
AdvanceCursor PROC
;
; Advances the cursor n columns to the right.
; Receives: CX = number of columns
; Returns: nothing
;--------------------------------------------------
	pusha
L1:
	push cx	; save loop counter
	mov  ah,3      	; get cursor position
	mov  bh,0	; into DH, DL
	int  10h	; changes CX register!
	inc  dl        	; increment column
	mov  ah,2      	; set cursor position
	int  10h
	pop  cx	; restore loop counter
	loop L1	; next column

	popa
	ret
AdvanceCursor ENDP

