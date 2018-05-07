TITLE Tracking the Mouse                      (mouse.asm)

; This simple mouse demo program is designed to show off some
; of the basic mouse functions available through INT 33h.
; Last update: 8/21/01
;
; In Standard DOS mode, each character position in the DOS window
; is equal to 8 mouse units (called "mickeys").

INCLUDE Irvine16.inc
include macros.inc
include validatevoter.inc
include DisVoters.inc
include addvoter.inc
include names.inc


voter struct
voter_Name byte "         "
voter_cnic byte "          "
vote_count byte 0
voter ends

candidate struct
candidate_Name byte "           "
candidate_cnic byte "           "
candidate ends

NF BYTE "my_text_file.txt",0
hdl WORD 0

Mode_6A = 12h           ; 800 X 600, 16 colors
.data

hd WORD ?
User_Name byte "            ",0
User_cnic byte "                ",0
User_password byte "1234",0
password_count byte 0
check byte "         ",0
test1 byte 0
cand candidate 4 dup (<>)
vot voter 6 dup (<>)
Number_candidate byte 0
Number_Voter byte 0
equality_check byte 0
Password BYTE "Enter Password",0

ESCkey = 1Bh
GreetingMsg BYTE "Press Esc to quit",0dh,0ah,0
StatusLine  BYTE "Left button:                              "
                BYTE "Mouse position: ",0
blanks      BYTE "                ",0
Xcoordinate WORD 0      ; current X-position
Ycoordinate WORD 0      ; current Y-position
Xclick      WORD 0      ; X-pos of last button click
Yclick      WORD 0      ; Y-pos of last button click
saveMode BYTE ?
xVal WORD ?
yVal WORD ?
var1 word ?
var2 word ?
store  DWORD ?
val     WORD ?

man1 byte 0
man2 byte 0
man3 byte 0
man4 byte 0
.code
main PROC

mov  ax,@data
mov  ds,ax


 ;Save the current video mode
mov  ah,0Fh     ; get video mode
int  10h
mov  saveMode,al
           ;call first_page
           ;call print_char
           ;call waitmsg
           ;call pass_word
           ;call loading
           
call SetScreenBackground
   ;Hide the text cursor and display the mouse.
call HideCursor
call clrscr
call menu
; Hide the mouse, restore the text cursor, clear
; the screen, and display "Press any key to continue."

call HideMousePointer
call ShowCursor
call Clrscr
call WaitMsg
exit
main ENDP
;-----------------------------------------------------------
loading proc

; Switch to a graphics mode
        mov  ah,0       ; set 2video mode
        mov  al,Mode_6A ; 800 X 600, 16 colors
        int  10h

; Draw the X-axis
                                mov  cx,0; X-coord of start of line
                                mov  dx,30      ; Y-coord of start of line
                                mov  ax,640     ; length of line
                                mov  bl,lightcyan       ; line color (see IRVINE16.inc)
                call DrawHorizLine      ; draw the line now
mov dl,11
mov dh,10
call gotoxy
mwrite <" Loading  : ">
; Draw the X-axis
        mov  cx,100; X-coord of start of line
        mov  dx,200     ; Y-coord of start of line
        mov  ax,400     ; length of line
        mov  bl,white   ; line color (see IRVINE16.inc)
        call DrawHorizLine      ; draw the line now

        mov  cx,100; X-coord of start of line
        mov  dx,250     ; Y-coord of start of line
        mov  ax,400     ; length of line
        mov  bl,white   ; line color (see IRVINE16.inc)
        call DrawHorizLine      ; draw the line now


; Draw the Y-axis
        mov  cx,100; X-coord of start of line
        mov  dx,200     ; Y-coord of start of line
        mov  ax,50      ; length of line
        mov  bl,yellow  ; line color
        call DrawVerticalLine   ; draw the line now

        mov  cx,500; X-coord of start of line
        mov  dx,200     ; Y-coord of start of line
        mov  ax,50      ; length of line
        mov  bl,yellow  ; line color
        call DrawVerticalLine   ; draw the line now

mov ecx,1000
mov val,100
l:
mov store,ecx
        mov  cx,val; X-coord of start of line
        mov  dx,200     ; Y-coord of start of line
        mov  ax,50      ; length of line
        mov  bl,yellow  ; line color
        call DrawVerticalLine   ; draw the line now

add val,1
cmp val,500
je next
mov ecx,store
loop l
next:
call delay
ret
loading endp
;--------------------------------------------------------
pass_word proc

loop1:

; Switch to a graphics mode
        mov  ah,0       ; set 2video mode
        mov  al,Mode_6A ; 800 X 600, 16 colors
        int  10h

; Draw the X-axis
                        mov  cx,0; X-coord of start of line
                        mov  dx,30      ; Y-coord of start of line
                        mov  ax,640     ; length of line
                        mov  bl,lightcyan       ; line color (see IRVINE16.inc)
                call DrawHorizLine      ; draw the line now
; Draw the X-axis
        mov  cx,150; X-coord of start of line
        mov  dx,200     ; Y-coord of start of line
        mov  ax,300     ; length of line
        mov  bl,white   ; line color (see IRVINE16.inc)
        call DrawHorizLine      ; draw the line now

                mov  cx,150; X-coord of start of line
                mov  dx,250     ; Y-coord of start of line
                mov  ax,300     ; length of line
                mov  bl,white   ; line color (see IRVINE16.inc)
                call DrawHorizLine      ; draw the line now

; Draw the Y-axis
        mov  cx,150; X-coord of start of line
        mov  dx,200     ; Y-coord of start of line
        mov  ax,50      ; length of line
        mov  bl,yellow  ; line color
        call DrawVerticalLine   ; draw the line now

        mov  cx,450; X-coord of start of line
                mov  dx,200     ; Y-coord of start of line
                mov  ax,50      ; length of line
                mov  bl,yellow  ; line color
        call DrawVerticalLine   ; draw the line now
        .if(password_count==1)
        mov dl,20
        mov dh,20
        call gotoxy

        mwrite <"Password Incorrect">
       .endif

mov dl,17
mov dh,11
call gotoxy
mwrite <"  Enter the Password  ">
mov dl,20
mov dh,13
call gotoxy

;.if(password_count==1)
;mov dl,20
;mov dh,20
;call gotoxy
;mwrite "Password Incorrect"
;.endif
mov password_count,0

mov si,offset check
call check_password
invoke str_compare,ADDR User_password,ADDR check
.if(zero?)
ret
.else
mov password_count,1
jmp loop1
.endif

pass_word endp
 ;-------------------------------------------------------
 menu proc

 call clrscr
 ; Switch to a graphics mode
        mov  ah,0       ; set video mode
        mov  al,Mode_6A ; 800 X 600, 16 colors
        int  10h

; Draw the X-axis
                        mov  cx,0; X-coord of start of line
                        mov  dx,40      ; Y-coord of start of line
                        mov  ax,640     ; length of line
                        mov  bl,lightcyan       ; line color (see IRVINE16.inc)
                call DrawHorizLine      ; draw the line now
  mov cx,26
  mov var1,590
  mov var2,6

 mov cx,100
 mov var1,80
 mov var2,80


 l00:
 push cx
 ; Draw the X-axis
        mov  cx,var1; X-coord of start of line
        mov  dx,var2    ; Y-coord of start of line
        mov  ax,200     ; length of line
        mov  bl,blue    ; line color (see IRVINE16.inc)
        call DrawHorizLine      ; draw the line now

  add var2,1
  pop cx
  loop l00

 mov cx,100
 mov var1,350
 mov var2,80

 l0:
 push cx
 ; Draw the X-axis
        mov  cx,var1; X-coord of start of line
        mov  dx,var2    ; Y-coord of start of line
        mov  ax,200     ; length of line
        mov  bl,white   ; line color (see IRVINE16.inc)
        call DrawHorizLine      ; draw the line now

  add var2,1
  pop cx
  loop l0


 mov cx,100
 mov var1,80
 mov var2,215
 l1:
 push cx
 ; Draw the X-axis
        mov  cx,var1; X-coord of start of line
        mov  dx,var2    ; Y-coord of start of line
        mov  ax,200     ; length of line
        mov  bl,blue    ; line color (see IRVINE16.inc)
        call DrawHorizLine      ; draw the line now

  add var2,1
  pop cx
  loop l1

 mov cx,  100
 mov var1,350
 mov var2,215
 l2:
 push cx
        ; Draw the X-axis
                mov  cx,var1     ; X-coord of start of line
                mov  dx,var2    ; Y-coord of start of line
                mov  ax,200     ; length of line
                mov  bl,white   ; line color (see IRVINE16.inc)
                call DrawHorizLine      ; draw the line now
 add var2,1
 pop cx
 loop l2

 mov cx,100
 mov var1,80
 mov var2,350
 l3:
 push cx
 ; Draw the X-axis
        mov  cx,var1; X-coord of start of line
        mov  dx,var2    ; Y-coord of start of line
        mov  ax,200     ; length of line
        mov  bl,blue    ; line color (see IRVINE16.inc)
        call DrawHorizLine      ; draw the line now

  add var2,1
  pop cx
  loop l3


 mov cx,100
 mov var1,350
 mov var2,350
 l4:
 push cx
        ; Draw the X-axis
                mov  cx,var1     ; X-coord of start of line
                mov  dx,var2    ; Y-coord of start of line
                mov  ax,200     ; length of line
                mov  bl,white   ; line color (see IRVINE16.inc)
                call DrawHorizLine      ; draw the line now
 add var2,1
 pop cx
 loop l4

 mov dl,15
 mov dh,7
 call gotoxy
 mwrite <" Cast Vote ">

 mov dl,49
 mov dh,7
 call gotoxy
 mwrite <" Show Result ">

 mov dl,14
 mov dh,16
 call gotoxy
 mwrite <" Show Voter list ">

 mov dl,46
 mov dh,16
 call gotoxy
 mwrite <" Add Voter  ">


 mov dl,18
 mov dh,24
 call gotoxy
 mwrite <" Quit ">

 mov dl,51
 mov dh,24
 call gotoxy
 mwrite <"Candidates Details">
 call ShowMousePointer
 mn:
 xor bx,bx
 call LeftButtonClick
 loop mn
 ret
 menu endp
 ;--------------------------------------------------------
 results proc
 ; Switch to a graphics mode
        mov  ah,0       ; set video mode
        mov  al,Mode_6A ; 800 X 600, 16 colors
        int  10h

        mov  cx,0; X-coord of start of line
                        mov  dx,30      ; Y-coord of start of line
                        mov  ax,640     ; length of line
                        mov  bl,lightcyan       ; line color (see IRVINE16.inc)
                call DrawHorizLine      ; draw the line now


 ; Draw the X-axis
        mov  cx,80; X-coord of start of line
        mov  dx,80      ; Y-coord of start of line
        mov  ax,400     ; length of line
        mov  bl,white   ; line color (see IRVINE16.inc)
        call DrawHorizLine      ; draw the line now

  ; Draw the X-axis
        mov  cx,80; X-coord of start of line
        mov  dx,120     ; Y-coord of start of line
        mov  ax,400     ; length of line
        mov  bl,white   ; line color (see IRVINE16.inc)
        call DrawHorizLine      ; draw the line now


                mov  cx,80; X-coord of start of line
                mov  dx,280     ; Y-coord of start of line
                mov  ax,400     ; length of line
                mov  bl,white   ; line color (see IRVINE16.inc)
                call DrawHorizLine      ; draw the line now

 ; Draw the Y-axis
        mov  cx,80; X-coord of start of line
        mov  dx,80      ; Y-coord of start of line
        mov  ax,200     ; length of line
        mov  bl,yellow  ; line color
        call DrawVerticalLine   ; draw the line now

        mov  cx,480; X-coord of start of line
                mov  dx,80      ; Y-coord of start of line
                mov  ax,200     ; length of line
                mov  bl,yellow  ; line color
        call DrawVerticalLine   ; draw the line now

  mov dl,28
  mov dh,6
  call gotoxy
  mwrite <"  Results ">
  mov al, man1


 mov dl,12
 mov dh,10
 call gotoxy
 mwrite <"  Aziz Ullah ">
 mov al, man1
 call writedec

 mov dl,12
 mov dh,13
 call gotoxy
 mwrite <"  Hassan ">
 mov al, man2
 call writedec

 mov dl,40
 mov dh,10
 call gotoxy
 mwrite <"  Abdul ">
 mov al, man3
 call writedec


 mov dl,40
 mov dh,13
 call gotoxy
 mwrite <"  Atif ">
 mov al, man4
 call writedec
 ret
 results endp
 ;------------------------------------------------------------
vote_cast proc
; Switch to a graphics mode
        mov  ah,0       ; set video mode
        mov  al,Mode_6A ; 800 X 600, 16 colors
        int  10h
mov dl, 10
mov dh, 3
call gotoxy
mWrite<"<<<< Please Give Your Vote >>> ">
        ; Draw the X-axis
                        mov  cx,0; X-coord of start of line
                        mov  dx,30      ; Y-coord of start of line
                        mov  ax,630     ; length of line
                        mov  bl,lightcyan       ; line color (see IRVINE16.inc)
                call DrawHorizLine      ; draw the line now

  mov cx,22
  mov var1,590
  mov var2,6

  ex:
  push cx
  ; Draw the X-axis
        mov  cx,var1; X-coord of start of line
        mov  dx,var2    ; Y-coord of start of line
        mov  ax,40      ; length of line
        mov  bl,red     ; line color (see IRVINE16.inc)
        call DrawHorizLine      ; draw the line now
   add var2,1
     pop cx
  loop ex

mov cx,150
mov var1,80
mov var2,80
mov bx,0

l1:
push cx
; Draw the X-axis

        mov  cx,var1; X-coord of start of line
        mov  dx,var2    ; Y-coord of start of line
        mov  ax,200     ; length of line
        mov  bl,blue
        ; line color (see IRVINE16.inc)
        call DrawHorizLine      ; draw the line now

        add var2,1

pop cx
loop    l1

; Draw the Y-axis
        mov  cx,80; X-coord of start of line
        mov  dx,80      ; Y-coord of start of line
        mov  ax,150     ; length of line
        mov  bl,yellow  ; line color
        call DrawVerticalLine   ; draw the line now

        mov  cx,280; X-coord of start of line
        mov  dx,80      ; Y-coord of start of line
        mov  ax,150     ; length of line
        mov  bl,yellow  ; line color
        call DrawVerticalLine   ; draw the line now

mov ecx,200
mov var1,350
mov var2,80
mov ebx,0

l2:
push ecx

        ; Draw the Y-axis
                mov  cx,var1; X-coord of start of line
                mov  dx,var2    ; Y-coord of start of line
                mov  ax,150     ; length of line
                mov  bl,yellow  ; line color
                call DrawVerticalLine   ; draw the line now
                add var1,1
pop ecx
loop l2

mov ecx,200
mov var1,80
mov var2,300
mov bx,0

l3:
push cx

; Draw the Y-axis
        mov  cx,var1; X-coord of start of line
        mov  dx,var2    ; Y-coord of start of line
        mov  ax,150     ; length of line
        mov  bl,yellow  ; line color
        call DrawVerticalLine   ; draw the line now
        add var1,1
pop cx
loop l3


mov cx,150
mov var1,350
mov var2,300
mov bx,0
 l4:
push ecx
        ; Draw the X-axis
                mov  cx,var1; X-coord of start of line
                mov  dx,var2    ; Y-coord of start of line
                mov  ax,200     ; length of line
                mov  bl,blue    ; line color (see IRVINE16.inc)
                call DrawHorizLine      ; draw the line now
add var2,1

pop ecx
loop l4
        ; Draw the Y-axis
                mov  cx,350; X-coord of start of line
                mov  dx,300     ; Y-coord of start of line
                mov  ax,150     ; length of line
                mov  bl,yellow  ; line color
                call DrawVerticalLine   ; draw the line now

                mov  cx,550; X-coord of start of line
                mov  dx,300     ; Y-coord of start of line
                mov  bl,yellow  ; line color
                mov  ax,150     ; length of line
                call DrawVerticalLine   ; draw the line now

mov dl,18
mov dh,9
call gotoxy
mwrite <"  Aziz   ">
;call delay

mov dl,52
mov dh,9
call gotoxy
mwrite <"  Hassan   ">
;call delay

mov dl,18
mov dh,23
call gotoxy
mwrite <"  Abdul   ">
;call delay

mov dl,52
mov dh,23
call gotoxy
mwrite <"  Atif   ">
call ShowMousePointer
t:
call Click
jmp t

ret
vote_cast endp
;---------------------------------------------------------
first_page proc

; Switch to a graphics mode
        mov  ah,0       ; set video mode
        mov  al,Mode_6A ; 800 X 600, 16 colors
        int  10h

                mov  cx,60; X-coord of start of line
                mov  dx,60      ; Y-coord of start of line
                mov  ax,200     ; length of line
                mov  bl,blue    ; line color (see IRVINE16.inc)
                call DrawHorizLine      ; draw the line now

                mov  cx,60; X-coord of start of line
                mov  dx,60      ; Y-coord of start of line
                mov  ax,200     ; length of line
                mov  bl,yellow  ; line color
                call DrawVerticalLine   ; draw the line now

        ;call   print_char
                                mov  cx,380; X-coord of start of line
                                mov  dx,400     ; Y-coord of start of line
                                mov  ax,200     ; length of line
                                mov  bl,blue    ; line color (see IRVINE16.inc)
                                call DrawHorizLine      ; draw the line now

                                mov  cx,580; X-coord of start of line
                                mov  dx,200     ; Y-coord of start of line
                                mov  ax,200     ; length of line
                                mov  bl,yellow  ; line color
                                call DrawVerticalLine   ; draw the line now


ret
first_page endp
;---------------------------------------------------------
GetMousePosition PROC
;
; Return the current mouse position and button status.
; Receives: nothing
; Returns:  BX = button status (0 = left button down,
;           (1 = right button down, 2 = center button down)
;           CX = X-coordinate
;           DX = Y-coordinate
;---------------------------------------------------------
        push ax
        mov  ax,3
        int  33h
        pop  ax
        ret
GetMousePosition ENDP

;---------------------------------------------------------
HideCursor proc
;
; Hide the text cursor by setting its top line
; value to an illegal value.
;---------------------------------------------------------
        mov  ah,3       ; get cursor size
        int  10h
        or   ch,30h     ; set upper row to illegal value
        mov  ah,1       ; set cursor size
        int  10h
        ret
HideCursor ENDP

ShowCursor PROC
        mov  ah,3       ; get cursor size
        int  10h
        mov  ah,1       ; set cursor size
        mov  cx,0607h   ; default size
        int  10h
        ret
ShowCursor ENDP

;---------------------------------------------------------
HideMousePointer PROC
;---------------------------------------------------------
        push ax
        mov  ax,2       ; hide mouse cursor
        int  33h
        pop  ax
        ret
HideMousePointer ENDP

;---------------------------------------------------------
ShowMousePointer PROC
;---------------------------------------------------------
        push ax
        mov  ax,1       ; make mouse cursor visible
        int  33h
        pop  ax
        ret
ShowMousePointer ENDP

;---------------------------------------------------------
LeftButtonClick PROC
        mov  ah,0       ; get mouse status
        mov  al,5       ; (button press information)
        mov  bx,0       ; specify the left button
        int  33h

        .IF cx> 80 && cx < 280 && cx >= 80 && dx < 180
         call jmp_to_startpoling
        .ELSEIF cx > 350 && cx < 550 && dx > 80 && dx < 180 && bx==1
         call results
         call waitmsg
         call menu
        .ELSEIF cx >80 && cx < 280 && dx > 215 && dx <= 315  && bx==1
         call ListVoters
         call waitmsg
         call menu
        .ELSEIF cx > 350 && cx < 550 && dx > 215 && dx < 315  && bx==1
         call ADD_VOTER
         call waitmsg
         call menu
        .ELSEIF cx > 80 && cx < 280 && dx > 350 && dx < 450  &&  bx==1
         exit
        .ELSEIF cx > 350 && cx < 550  && dx > 350 && dx < 450  &&  bx == 1
         call cand_detail
         call crlf
	 call waitmsg
	 call menu
        .ENDIF
        ret
LeftButtonClick ENDP
;--------------------------------------------------------
Click PROC

        mov  ah,0       ; get mouse status
        mov  al,5       ; (button press information)
        mov  bx,0       ; specify the left button
        int  33h

         .IF cx > 80 && cx < 280 && cx >= 80 && dx <= 230 && bx==1
           add man1,1
           call menu
         .ELSEIF cx > 350 && cx < 550 && dx > 80 && dx <=230 && bx==1
           add man2,1
           call menu
         .ELSEIF cx >80 && cx <= 280 && dx >= 300 && dx <= 550  && bx==1
           add man3,1
           call menu
         .ELSEIF cx > 350 && cx < 550 && dx >= 300 && dx < 550 && bx==1
           add man4,1
           call menu
          .ELSEIF cx > 590 && cx < 630 && dx > 6 && dx < 32 && bx==1
          exit
         .ENDIF
        ret
Click ENDP
;---------------------------------------------------------
SetMousePosition PROC
;
; Set the mouse's position on the screen.
; Receives: CX = X-coordinate
;           DX = Y-coordinate
; Returns:  nothing
;---------------------------------------------------------
        mov  ax,4
        int  33h
        ret
SetMousePosition ENDP

;---------------------------------------------------------
ShowMousePosition PROC
;
; Get and show the mouse corrdinates at the
; bottom of the screen.
; Receives: nothing
; Returns:  nothing
;---------------------------------------------------------
        pusha
        call GetMousePosition

; Exit proc if the coordinates have not changed.
        cmp  cx,Xcoordinate
        jne  SMP1
        cmp  dx,Ycoordinate
        je   SMP_exit

SMP1:
        mov  Xcoordinate,cx
        mov  Ycoordinate,dx

; Position the cursor, clear the old numbers.
        mov  dh,24                      ; screen row
        mov  dl,60              ; screen column
        call Gotoxy
        push dx
        mov  dx,OFFSET blanks
        call WriteString
        pop  dx

; Show the mouse coordinates.
        call Gotoxy     ; (24,60)
        mov  ax,Xcoordinate
        call WriteDec
        mov  dl,65              ; screen column
        call Gotoxy
        mov  ax,Ycoordinate
        call WriteDec

SMP_exit:
        popa
        ret
ShowMousePosition ENDP

SetScreenBackground PROC
mov dx, 3C8h
mov al, 0
out dx, al
mov dx, 3C9h
mov al, 10
out dx, al
mov al, 8
out dx, al

mov al, 20
out dx, al
ret
SetScreenBackground endp
DrawHorizLine PROC
;
; Draws a horizontal line starting at position X,Y with
; a given length and color.
; Receives: CX = X-coordinate, DX = Y-coordinate,
;           AX = length, and BL = color
; Returns: nothing
;------------------------------------------------------
.data
currX WORD ?

.code
        pusha
        mov  currX,cx   ; save X-coordinate
        mov  cx,ax      ; loop counter

DHL1:
        push cx ; save loop counter
        mov  al,bl      ; color
        mov  ah,0Ch     ; draw pixel
        mov  bh,0       ; video page
        mov  cx,currX   ; retrieve X-coordinate
        int  10h
        inc  currX      ; move 1 pixel to the right
        pop  cx ; restore loop counter
        Loop DHL1

        popa
        ret
DrawHorizLine ENDP

;------------------------------------------------------
DrawVerticalLine PROC
;
; Draws a vertical line starting at position X,Y with
; a given length and color.
; Receives: CX = X-coordinate, DX = Y-coordinate,
;           AX = length, BL = color
; Returns: nothing
;------------------------------------------------------
.data
currY WORD ?

.code
        pusha
        mov  currY,dx   ; save Y-coordinate
        mov  currX,cx   ; save X-coordinate
        mov  cx,ax      ; loop counter

DVL1:
        push cx ; save loop counter
        mov  al,bl      ; color
        mov  ah,0Ch     ; function: draw pixel
        mov  bh,0       ; set video page
        mov  cx,currX   ; set X-coordinate
        mov  dx,currY   ; set Y-coordinate
        int  10h        ; draw the pixel
        inc  currY      ; move down 1 pixel
        pop  cx ; restore loop counter
        Loop DVL1

        popa
        ret
DrawVerticalLine ENDP

input_keyboard proc

 get_string:
    xor cl, cl

  loo:
    mov ah, 10h
    int 16h   ; wait for keypress

    cmp al, 08h    ; backspace pressed?
    je backspace   ; yes, handle it

    cmp al, 0Dh  ; enter pressed?
    je done      ; yes, we're done

    cmp cl, 3Fh  ; 63 chars inputted?
    je loo      ; yes, only let in backspace and enter

    mov [si],al
   call writechar
    ;mov ah, 0Eh
    ;int 10      ; print out character

    inc si
    inc cl
    jmp loo

  backspace:
    cmp cl, 0   ; beginning of string?
    je loo      ; yes, ignore the key

    dec si
   mov byte ptr [si], 0 ; delete character
    dec cl              ; decrement counter as well

    mov ah, 0Eh
    mov al, 08
    int 10h             ; backspace on the screen

    mov al, ' '
    int 10h             ; blank character out

    mov al, 08
    int 10h             ; backspace again

    jmp loo     ; go to the main loop
  done:
 ret
 input_keyboard endp

check_password proc

 get_string:
    xor cl, cl

  loo:
    mov ah, 10h
    int 16h   ; wait for keypress

    cmp al, 08h    ; backspace pressed?
    je backspace   ; yes, handle it

    cmp al, 0Dh  ; enter pressed?
    je done      ; yes, we're done

    cmp cl, 3Fh  ; 63 chars inputted?
    je loo      ; yes, only let in backspace and enter

    mov [si],al
    mwrite '*'
   ;call writechar
    ;mov ah, 0Eh
    ;int 10      ; print out character

    inc si
    inc cl
    jmp loo

  backspace:
    cmp cl, 0   ; beginning of string?
    je loo      ; yes, ignore the key

    dec si
   mov byte ptr [si], 0 ; delete character
    dec cl              ; decrement counter as well

    mov ah, 0Eh
    mov al, 08
    int 10h             ; backspace on the screen

    mov al, ' '
    int 10h             ; blank character out

    mov al, 08
    int 10h             ; backspace again

    jmp loo     ; go to the main loop
  done:
 ret
 check_password endp
 
END main