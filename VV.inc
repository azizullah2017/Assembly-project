TITLE Procedure for Checking of Voted Voters
;By Najeeb Khan


.data
InID BYTE "0000",0
flag BYTE 0
ReadSize1 BYTE 5 DUP(?)
handle1 WORD ?
EndOfFile BYTE "0000",0
File1  BYTE "VotedVoters.txt",0
File2  BYTE "VotedVoters.txt",0
handle3 WORD ?
.code

Validate_Voter PROC
	 mov  ax,@data
	 mov  ds,ax
mov flag, 0
;Open existing file
	mov  ax, 716Ch             	; Extended Open/Create
	mov  bx, 2	; read-write-both
	mov  cx, 0      ; normal attribute
	mov  dx, 1	; open existing file
	mov  si, OFFSET File1
	int  21h
	mov  handle1, ax        	; file handle

;set file pointer
mov ah, 42h
mov al, 0
mov bx, handle1
mov cx, 0
mov dx, 0
int 21h


 ;Read the input file
Read:
	mov ah, 3Fh	; read file or device
	mov bx, handle	; file handle
	mov cx, 4	; max bytes to read
	mov dx, OFFSET ReadSize	; buffer pointer
	int 21h
;	jc  quit	; quit if error

invoke	str_compare, ADDR EndOfFile, ADDR ReadSize1
	jz quit1
invoke	str_compare, ADDR InID, ADDR ReadSize1
	jz Voted
	loop Read
Voted:
mov flag, 1
quit1: 
;       Close the file
	mov  ah, 3Eh    	; function: close file
	mov  bx, handle1	; input file handle
	int  21h       	; call MS-DOS

ret
Validate_Voter endp



;---------------------------------------------------------
 jmp_to_startpoling proc  
   
   mov  ax,@data
   mov  ds,ax

   ; Switch to a graphics mode
    	mov  ah,0   	; set video mode
    	mov  al,Mode_6A	; 800 X 600, 16 colors
    	int  10h
    	
    mov dl, 16
    mov dh, 7
    call gotoxy
    mWrite<"|QUIT|">
      	
   ;  Draw the X-axis
    			mov  cx,0; X-coord of start of line
    			mov  dx,30	; Y-coord of start of line
    			mov  ax,640 	; length of line
    			mov  bl,lightcyan	; line color (see IRVINE16.inc)
   		call DrawHorizLine	; draw the line now
    mov dl,5
    mov dh,13
    call gotoxy
    mwrite <"  Enter Your Name   ">
    
    ; Draw the X-axis
    	mov  cx,300; X-coord of start of line
    	mov  dx,200	; Y-coord of start of line
    	mov  ax,200 	; length of line
    	mov  bl,white	; line color (see IRVINE16.inc)
    	call DrawHorizLine	; draw the line now
    	
    	mov  cx,300; X-coord of start of line
    	mov  dx,230	; Y-coord of start of line
    	mov  ax,200 	; length of line
    	mov  bl,white	; line color (see IRVINE16.inc)
    	call DrawHorizLine	; draw the line now
    	
    ; Draw the Y-axis
    	mov  cx,300; X-coord of start of line
    	mov  dx,200	; Y-coord of start of line
    	mov  ax,30	; length of line
    	mov  bl,yellow	; line color
    	call DrawVerticalLine	; draw the line now
    	
            mov  cx,500; X-coord of start of line
    	mov  dx,200	; Y-coord of start of line
    	mov  ax,30	; length of line
    	mov  bl,yellow	; line color
    	call DrawVerticalLine	; draw the line now
    
   
     mov dl,5
     mov dh,19
     call gotoxy
     mwrite <"  Enter Your CINC  ">
    
    ; Draw the X-axis
    	mov  cx,300; X-coord of start of line
    	mov  dx,300	; Y-coord of start of line
    	mov  ax,200 	; length of line
    	mov  bl,white	; line color (see IRVINE16.inc)
    	call DrawHorizLine	; draw the line now
    	
    	mov  cx,300; X-coord of start of line
    	mov  dx,330	; Y-coord of start of line
    	mov  ax,200 	; length of line
    	mov  bl,white	; line color (see IRVINE16.inc)
    	call DrawHorizLine	; draw the line now
    	
    ; Draw the Y-axis
    	mov  cx,300; X-coord of start of line
    	mov  dx,300	; Y-coord of start of line
    	mov  ax,30	; length of line
    	mov  bl,yellow	; line color
    	call DrawVerticalLine	; draw the line now
    	
            mov  cx,500; X-coord of start of line
    	mov  dx,300	; Y-coord of start of line
    	mov  ax,30	; length of line
    	mov  bl,yellow	; line color
    	call DrawVerticalLine	; draw the line now
    
    mov dl,40
    mov dh,13
    call gotoxy
    mov si,offset InID
    call input_keyboard
        
     	
    mov dl,40
    mov dh,19
    call gotoxy
    mov si,offset InID
    call input_keyboard
    call waitmsg
    call Validate_Voter
    .IF (flag == 1)
    mov dl, 5
    mov dh, 25
    call gotoxy
    mWrite<"Sorry! You have Already Voted, You Cannot Vote : ">
    call waitmsg
    call jmp_to_startpoling
    .ENDIF
    mWrite<"You Can Now Vote..">
    call vote_cast 
ret  
jmp_to_startpoling endp


VoterVoted PROC
	 mov  ax,@data
	 mov  ds,ax
;Open existing file
	mov  ax, 716Ch             	; Extended Open/Create
	mov  bx, 2	; read-write-both
	mov  cx, 0      ; normal attribute
	mov  dx, 1	; open existing file
	mov  si, OFFSET File2
	int  21h
	mov  handle3, ax        	; file handle

;set file pointer
mov ah, 42h
mov al, 1
mov bx, handle3
mov cx, 0
mov dx, -4
int 21h

;write to file
mov ah, 40h
mov bx, handle3
mov cx, SIZEOF InID
mov dx, OFFSET InID
int 21h

 ;      Close the file
	mov  ah,3Eh    	; function: close file
	mov  bx,handle1	; input file handle
	int  21h       	; call MS-DOS
	call jmp_to_startpoling

ret
VoterVoted endp


