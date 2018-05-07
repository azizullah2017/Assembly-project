TITLE Procedure for Checking of Voted Voters
;By Najeeb Khan


.data
BufSize = 5000
infile    BYTE "my_text_file.txt",0
outfile   BYTE "my_output_file.txt",0
inHandle  WORD ?
outHandle WORD ?
buffer    BYTE BufSize DUP(?)
bytesRead WORD 0
ReadSize BYTE "0000",0
;ReadSize BYTE 5 DUP(0)
EndOfFile BYTE "0000",0
VName BYTE 20 DUP(0)
flag BYTE 0
TotalBytes WORD 0
TByteRead  WORD 0
.code

Validate_Voter PROC
	mov  ax,@data
	mov  ds,ax
	mov flag, 0

	call crlf
	; Open the input file
		mov ax,716Ch   	; extended create or open
		mov bx,2      	; mode = read-only
		mov cx,0	; normal attribute
		mov dx,1	; action: open
		mov si,OFFSET infile
		int 21h       	; call MS-DOS
		mov inHandle, ax
	
	; Read the input file
	Read:	mov ah,3Fh	; read file or device
		mov bx,inHandle	; file handle
		mov cx,4	; max bytes to read
		mov dx,OFFSET buffer	; buffer pointer
		int 21h
		mov bytesRead, ax
		call writedec
		add TByteRead, ax
	invoke	str_compare, ADDR ReadSize, ADDR buffer
		jz c1
	mov ax, TByteRead
	cmp ax, TotalBytes		
	jne Read
		
	;set file pointer
			mov ah, 42h
			mov al, 2
			mov bx, inHandle
			mov cx, 0
			mov dx, 0
			int 21h
	
			
		;Write to  file
			mov ah, 40h	; write file or device
			mov bx, inHandle	  ; output file handle
			mov cx, SIZEOF ReadSize - 1 ; number of bytes
			mov dx, OFFSET ReadSize	  ; buffer pointer
			int 21h
                        add TotalBytes, SIZEOF ReadSize - 1 
	jmp p
	c1:
	mov flag, 1
	call crlf
	p:
	
	
	; Close the file
		mov  ah,3Eh    	; function: close file
		mov  bx,inHandle	; input file handle
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
    mov si,offset VName
    call input_keyboard
        
     	
    mov dl,40
    mov dh,19
    call gotoxy
    mov dx, Offset ReadSize
    call    ReadString
    call    Validate_Voter
    .IF (flag == 1)
    mov dl, 5
    mov dh, 25
    call gotoxy
    mWrite<" Sorry! You have Already Voted, You Cannot Vote : ">
    call waitmsg
    call menu
    .ENDIF
    mov dl, 5
    mov dh, 25
    call gotoxy
    mWrite<"You Can Now Vote..">
    call waitmsg
    call vote_cast 
    ret  
jmp_to_startpoling endp