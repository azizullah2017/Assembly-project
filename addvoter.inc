TITLE Add Voters Procedure
;by Najeeb Khan

.data
handle2 WORD ?
VotersFile1  BYTE "voters1.txt",0
VoterName BYTE 20 DUP(?)
VoterID BYTE 5 DUP(?)
NL BYTE " ",0dh, 0ah
.code
ADD_VOTER PROC
	mov  ax,@data
	mov  ds,ax

	mov  ah,0   	; set video mode
	mov  al,Mode_6A	; 800 X 600, 16 colors
 	int  10h
mWrite<"Enter Name : ">
mReadStr VoterName
call crlf
mWrite<"Enter ID : ">
mReadStr VoterID
call crlf
;Open existing file
mov  ax, 716Ch             	; Extended Open/Create
mov  bx, 2	; read-write-both
mov  cx, 0      ; normal attribute
mov  dx, 1	; open existing file
mov  si, OFFSET VotersFile1
int  21h
mov  handle2, ax        	; file handle
	
;set file pointer
mov ah, 42h
mov al, 2
mov bx, handle2
mov cx, 0
mov dx, 0
int 21h

;write to file
mov ah, 40h
mov bx, handle2
mov cx, SIZEOF VoterName-1
mov dx, OFFSET VoterName
int 21h


;set file pointer
mov ah, 42h
mov al, 2
mov bx, handle2
mov cx, 0
mov dx, 2
int 21h


mov ah, 40h
mov bx, handle2
mov cx, SIZEOF VoterID-1
mov dx, OFFSET VoterID
int 21h

;set file pointer
mov ah, 42h
mov al, 2
mov bx, handle2
mov cx, 0
mov dx, 2
int 21h


mov ah, 40h
mov bx, handle2
mov cx, SIZEOF NL
mov dx, OFFSET NL
int 21h



;Close the file
mov  ah,3Eh    	; function: close file
mov  bx,handle2	; input file handle
int  21h       	; call MS-DOS

ret
ADD_VOTER endp