TITLE Display Voters Procedure
;by Najeeb Khan

.data
handle WORD ?
hn2 WORD ?
CandFile BYTE "cand.txt",0
VotersFile  BYTE "voters1.txt",0
ReadSize1 BYTE 5000 DUP(0)
bytesRead1 WORD ?
.code
ListVoters PROC
	mov  ax,@data
	mov  ds,ax
	
	mov  ah,0   	; set video mode
	mov  al,Mode_6A	; 800 X 600, 16 colors
 	int  10h
        
;Open existing file
mov  ax, 716Ch             	; Extended Open/Create
mov  bx, 2	; read-write-both
mov  cx, 0      ; normal attribute
mov  dx, 1	; open existing file
mov  si, OFFSET VotersFile
int  21h
mov  handle, ax        	; file handle
	
;Read the input file
	mov ah, 3Fh	; read file or device
	mov bx, handle	; file handle
	mov cx, 5000	; max bytes to read
	mov dx, OFFSET ReadSize1	; buffer pointer
	int 21h
	mov bytesRead1, ax

; Display the buffer
	mov ah, 40h	; write file or device
	mov bx, 1	; console output handle
	mov cx, bytesRead1	 ; number of bytes
	mov dx, OFFSET ReadSize1 ; buffer pointer
	int 21h




;Close the file
mov  ah,3Eh    	; function: close file
mov  bx,handle	; input file handle
int  21h       	; call MS-DOS


ret
ListVoters endp


cand_detail PROC

	mov  ax,@data
	mov  ds,ax
	
	mov  ah,0   	; set video mode
	mov  al,Mode_6A	; 800 X 600, 16 colors
 	int  10h
        
;Open existing file
mov  ax, 716Ch             	; Extended Open/Create
mov  bx, 2	; read-write-both
mov  cx, 0      ; normal attribute
mov  dx, 1	; open existing file
mov  si, OFFSET CandFile
int  21h
mov  hn2, ax        	; file handle
	
;Read the input file
	mov ah, 3Fh	; read file or device
	mov bx, hn2	; file handle
	mov cx, 5000	; max bytes to read
	mov dx, OFFSET ReadSize1	; buffer pointer
	int 21h
	mov bytesRead1, ax

; Display the buffer
	mov ah, 40h	; write file or device
	mov bx, 1	; console output handle
	mov cx, bytesRead1	; number of bytes
	mov dx, OFFSET ReadSize1	; buffer pointer
	int 21h




;Close the file
mov  ah,3Eh    	; function: close file
mov  bx,hn2 ; input file handle
int  21h       	; call MS-DOS



ret
cand_detail endp
