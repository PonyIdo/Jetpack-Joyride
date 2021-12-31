IDEAL

MODEL small

STACK 100h

DATASEG
WINDOW_WIDTH DW 140h ; width of the window
WINDOW_HEIGHT DW 0c8h ; height of the window



; Image and graphics
picFilename db 'pic.bmp', 0 ;ASCIZ (Null-terminated string)
tmpHeader db 54 dup (0)
Palette db 1024 dup (0) ; All files should have the same palette, so we apply it once.
picture db 100 dup (0)


CODESEG






; Open a file. Parameters are:
; 1. reference to filename on dx (ASCIZ format)
; Returns file handle to ax or 0 on error
proc OpenFile
  mov ah, 3Dh
  xor al, al
  int 21h
  jc openerror
  jmp openFinish
openerror:
  mov ax, 0
  call ExitProgram
openFinish:
  ret
endp OpenFile










; Read BMP file color palette, 256 colors * 4 bytes (400h)
; Params:
; 1. BX = file handle
; 2. DX = palette buffer
proc ReadBMPPalette
  push ax
  push cx
  push dx
  push bx
  push sp
  push bp
  push si
  push di


  mov ah, 3fh
  mov cx, 400h
  int 21h


  pop di
  pop si
  pop bp
  pop sp
  pop bx
  pop dx
  pop cx
  pop ax
  ret
endp ReadBMPPalette



; Copy the colors palette to the video memory registers
; The number of the first color should be sent to port 3C8h
; The palette is sent to port 3C9h
; si = palette buffer
proc CopyBMPPalette
  push ax
  push cx
  push dx
  push bx
  push sp
  push bp
  push si
  push di


  mov cx,256
  mov dx,3C8h
  mov al,0
  ; Copy starting color to port 3C8h
  out dx,al
  ; Copy palette itself to port 3C9h
  inc dx
PalLoop:
  ; Note: Colors in a BMP file are saved as BGR values rather than RGB.
  mov al,[si+2] ; Get red value.
  shr al,2 ; Max. is 255, but video palette maximal
   ; value is 63. Therefore dividing by 4.
  out dx,al ; Send it.
  mov al,[si+1] ; Get green value.
  shr al,2
  out dx,al ; Send it.
  mov al,[si] ; Get blue value.
  shr al,2
  out dx,al ; Send it.
  add si,4 ; Point to next color.
   ; (There is a null chr. after every color.)
  loop PalLoop


  pop di
  pop si
  pop bp
  pop sp
  pop bx
  pop dx
  pop cx
  pop ax
  ret
endp CopyBMPPalette


; Copy bitmap to memory
; Params:
; 1. bx = file handle
; 2. dx = buffer
; 3. cx = height
; 4. ax = width
; Note: BMP graphics are saved upside-down.
proc CopyBMPToMemory
  push ax
  push cx
  push dx
  push bx
  push sp
  push bp
  push si
  push di
  push ax ; backup width
  push dx ; backup buffer
  mul cx ; Image size cannot be more than 16bit (max size is 320x200 = 64,000; 16bit register can hold up to 2^16-1 = 65535), so we ignore dx
  pop dx ; dx = buffer
  add dx, ax ; dx = end of buffer
  pop di ; di = width
  sub dx, di ; start of last line
  mov bp, cx ; bp = height
  mov cx, di ; cx = width
ReadLine:
  mov ax, 03F00h
  int 21h; Read from file. BX = file handle, CX = number of bytes to read, DX = buffer
  sub dx, cx
  dec bp
  cmp bp, 0
  jne ReadLine
  pop di
  pop si
  pop bp
  pop sp
  pop bx
  pop dx
  pop cx
  pop ax
  ret
endp CopyBMPToMemory


; Close file. Bx = file handle
proc CloseFile
  push ax
  push cx
  push dx
  push bx
  push sp
  push bp
  push si
  push di
  mov ah,3Eh
  int 21h
  pop di
  pop si
  pop bp
  pop sp
  pop bx
  pop dx
  pop cx
  pop ax
  ret
endp CloseFile




; Draw from memory. Parameters are:
; 1. buffer
; 2. width
; 3. height
; 4. startX
; 5. startY
proc DrawFromMemory
  push bp
  mov bp, sp
  push ax
  push cx
  push dx
  push bx
  push sp
  push bp
  push si
  push di
  mov ax, 0A000h
  mov es, ax
  mov ax, [bp + 4] ; start y
  mov bx, 320
  mul bx ;ax = start of the line
  cld ; for movsb
  mov di, ax ; di = start of the length
  add di, [bp + 6] ; add startX
  mov si, [bp + 12] ; si = buffer
  mov cx, [bp + 8] ;height
CPLoop:
  push cx
  mov cx, [bp + 10]; width
  rep movsb
  pop cx
  sub di, [bp + 10] ; sub the width
  add di, 320 ; go to next row
  loop CPLoop
  pop di
  pop si
  pop bp
  pop sp
  pop bx
  pop dx
  pop cx
  pop ax
  pop bp


  ret 10
endp DrawFromMemory






; Read file. Paramters:
; 1. bx = file handle
; 2. cx = number of bytes
; 3. dx = buffer reference
proc ReadFile
  push ax
  push cx
  push dx
  push bx
  push sp
  push bp
  push si
  push di


  mov ah,3Fh
  int 21h
  
  pop di
  pop si
  pop bp
  pop sp
  pop bx
  pop dx
  pop cx
  pop ax
  ret
endp readFile


; Read BMP file header, 54 bytes, into [dx]
; Params:
; 1. BX = file handle
; 2. DX = bmp header buffer
proc ReadBMPHeader
  push ax
  push cx
  push dx
  push bx
  push sp
  push bp
  push si
  push di

  mov ah,3fh
  mov cx,54
  int 21h
  
  pop di
  pop si
  pop bp
  pop sp
  pop bx
  pop dx
  pop cx
  pop ax
  ret
endp ReadBMPHeader


proc ClearScreen
	mov ax, 013h ; set vga mode
	int 10h

	; background configuration
	mov ah, 0Bh
	mov bh, 00h
	mov bl, 00h ; setting the background color to black
	int 10h ;execute the configurations
	ret
endp ClearScreen

proc ExitProgram
	; set to text mode
	; mov ah, 00h
	; mov al, 02h
	; int 10h


	; terminate program
	; mov ah, 4Ch
	; int 21h
endp ExitProgram

start:
	mov ax, @data
	mov ds, ax

	call ClearScreen

	; BMP Character graphics
	mov dx, offset picFilename
	call OpenFile

	mov bx, ax ; AX is the file handle from OpenFile
	mov dx, offset tmpHeader ; 54 bytes on memory
	call ReadBMPHeader

	mov dx, offset Palette
	call ReadBMPPalette

	mov si, dx
	call CopyBMPPalette


	mov dx, offset picture
	mov cx, 10 ; height
	mov ax, 10 ; width
	call CopyBMPToMemory


	call CloseFile




	
exit:

	mov ax, 4c00h
	int 21h
END start


