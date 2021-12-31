IDEAL

MODEL small

STACK 100h

DATASEG
WINDOW_WIDTH DW 140h ; width of the window
WINDOW_HEIGHT DW 0c8h ; height of the window


; Game active status (Yes(1)\No(0))
game_active DB 1h

; Exit the game (Yes(1)\No(0))
exit_game DB 0h

character_x DW 0Ah ; X postion of the charcter
character_y DW 0Ah ; Y postion of the charcter
character_height DW 0Eh
enemy_height DW 01Ch
time_last DB 0 ; used to check if the time has changed
velocity DW 01h ; speed of the character

enemies_velocity DW 4h ; speed of the enemies

; enemies loc

; enemy 1 property
enemy_1_x DW 140h ; X postion of the enemy 1
enemy_1_y DW 32h ; Y postion of the enemy 1 - 100

; enemy 2 property
enemy_2_x DW 140h ; X postion of the enemy 2
enemy_2_y DW 64h ; Y postion of the enemy 2 - 200

; enemy 3 property
enemy_3_x DW 140h ; X postion of the enemy 3
enemy_3_y DW 96h ; Y postion of the enemy 3 - 300


; enemies move status
enemy_1_move DB 0
enemy_2_move DB 0
enemy_3_move DB 0



player_lives DB 1 ;Player lives - always starts with 3

; texts to print on screen

TEXT_PLAYER_LIVES DB '0', '$'
TEXT_GAME_END_MENU DB 'GAME OVER', '$'
TEXT_PLAY_AGAIN DB 'Press enter to play again', '$'



; Image and graphics
picFilename db 'pic.bmp', 0 ;ASCIZ (Null-terminated string)
tmpHeader db 54 dup (0)
Palette db 1024 dup (0) ; All files should have the same palette, so we apply it once.
picture db 100 dup (0)


CODESEG



proc DRAW_GAME_OVER_MENU
	call ClearScreen

	; Displaying game menu
	mov ah, 02h ; cursor position
	mov bh, 00h ; page number
	mov dh, 04h ; row
	mov dl, 10h ; column
	int 10h 

	mov ah, 09h ; write string to standart output
	lea dx, [TEXT_GAME_END_MENU]
	int 21h


	; Displaying play again message
	mov ah, 02h ; cursor position
	mov bh, 00h ; page number
	mov dh, 08h ; row
	mov dl, 02h ; column
	int 10h

	mov ah, 09h ; write string to standart output
	lea dx, [TEXT_PLAY_AGAIN]
	int 21h




	KEY_PRESS_WAIT:

	; Wait for key press
	mov ah, 00h
	int 16h


	cmp al, 01Bh ; if the key is espace - leave the game
	je LEAVE_GAME


	cmp al, 00Dh ; if it's not enter
	jne KEY_PRESS_WAIT

	

	; Game active status - starts the game
	mov [game_active], 01h


	ret


	LEAVE_GAME:
	mov [exit_game], 01h
	ret


endp DRAW_GAME_OVER_MENU













proc CheckGameOver
	cmp [player_lives], 0
	je END_GAME

	ret

	END_GAME:
	; reset lives
	mov [player_lives], 3
	; reset player location
	mov [character_x], 0Ah
	mov [character_y], 0Ah

	; reset enemies move status
	mov [enemy_1_move], 0
	mov [enemy_2_move], 0
	mov [enemy_3_move], 0
	
	; reset enemies x location
	mov [enemy_1_x], 140h
	mov [enemy_2_x], 140h
	mov [enemy_3_x], 140h

	; Game active status - stops the game
	mov [game_active], 00h
endp CheckGameOver



proc CheckIntersection
	
	Enemy1Intersection:
	; X axis intersection - case 1
	mov ax, [enemy_1_x]
	sub ax, [enemies_velocity]
	cmp ax, [character_x]

	jge Enemy2Intersection ; no intersection

	; X axis intersection - case 2
	mov ax, [enemy_1_x]
	cmp ax, [character_x]

	jle Enemy2Intersection ; no intersection


	; Y axis intersection - case 1
	mov ax, [character_y]
	add ax, [character_height]
	cmp ax, [enemy_1_y]
	jle Enemy2Intersection ; no intersection

	; Y axis intersection - case 2
	mov ax, [enemy_1_y]
	add ax, [enemy_height]
	cmp [character_y], ax 
	jge Enemy2Intersection ; no intersection

	; Here we have an intersection
	dec [player_lives]

	ret ; exit because there was an intersection


	Enemy2Intersection:
	; X axis intersection - case 1
	mov ax, [enemy_2_x]
	sub ax, [enemies_velocity]
	cmp ax, [character_x]

	jge Enemy3Intersection ; no intersection

	; X axis intersection - case 2
	mov ax, [enemy_2_x]
	cmp ax, [character_x]

	jle Enemy3Intersection ; no intersection


	; Y axis intersection - case 1
	mov ax, [character_y]
	add ax, [character_height]
	cmp ax, [enemy_2_y]
	jle Enemy3Intersection ; no intersection

	; Y axis intersection - case 2
	mov ax, [enemy_2_y]
	add ax, [enemy_height]
	cmp [character_y], ax 
	jge Enemy3Intersection ; no intersection

	; Here we have an intersection
	dec [player_lives]

	ret ; exit because there was an intersection




	Enemy3Intersection:
	; X axis intersection - case 1
	mov ax, [enemy_3_x]
	sub ax, [enemies_velocity]
	cmp ax, [character_x]

	jge IntersectionEnd ; no intersection

	; X axis intersection - case 2
	mov ax, [enemy_3_x]
	cmp ax, [character_x]

	jle IntersectionEnd ; no intersection

	; Y axis intersection - case 1
	mov ax, [character_y]
	add ax, [character_height]
	cmp ax, [enemy_3_y]
	jle IntersectionEnd ; no intersection

	; Y axis intersection - case 2
	mov ax, [enemy_3_y]
	add ax, [enemy_height]
	cmp [character_y], ax 
	jge IntersectionEnd ; no intersection

	; Here we have an intersection
	dec [player_lives]

	ret ; exit because there was an intersection

	IntersectionEnd:
	ret ; exit because there was an intersection


endp CheckIntersection


proc userInterfaceDraw
	call UpdateLivesText
	; Draws the lives status
	mov ah, 02h ; cursor position
	mov bh, 00h ; page number
	mov dh, 04h ; row
	mov dl, 20h ; column
	int 10h 

	mov ah, 09h ; write string to standart output
	lea dx, [TEXT_PLAYER_LIVES]
	int 21h
	ret
endp userInterfaceDraw


proc UpdateLivesText
	xor ax, ax
	mov al, [player_lives]

	add al, 30h ; converting to ascii
	mov [TEXT_PLAYER_LIVES], al
endp UpdateLivesText

proc Random
	mov ah, 00h ; interrupts to get system time        
	int 1AH ; CX:DX now hold number of clock ticks since midnight      
	mov ax, dx
	xor dx, dx
	mov cx, 400
	div cx ; here dx contains the remainder of the division - from 0 to 10000
	ret 
endp Random


proc StartSendEnemies

call Random ; dx contains the random number


cmp dx, 100 ; check the random number to see if it needs to start moving enemy 1
je EnableMove1


cmp dx, 200 ; check the random number to see if it needs to start moving enemy 2
je EnableMove2



cmp dx, 300 ; check the random number to see if it needs to start moving enemy 3
je EnableMove3

ret


EnableMove3:
mov [enemy_3_move], 1 ; turn on the enemie's move status
;mov [enemy_3_x], 60h
ret

EnableMove2:
mov [enemy_2_move], 1 ; turn on the enemie's move status
;mov [enemy_2_x], 60h
ret


EnableMove1:
mov [enemy_1_move], 1 ; turn on the enemie's move status
;mov [enemy_1_x], 60h

ret
endp StartSendEnemies




proc MoveEnemies
mov ax, [enemies_velocity]

CheckMoveStatusEnemy1:
cmp [enemy_1_move], 1
je MoveEnemy1

CheckMoveStatusEnemy2:
cmp [enemy_2_move], 1
je MoveEnemy2

CheckMoveStatusEnemy3:
cmp [enemy_3_move], 1
je MoveEnemy3

ret

MoveEnemy1:
sub [enemy_1_x], ax
jmp CheckMoveStatusEnemy2


MoveEnemy2:
sub [enemy_2_x], ax
jmp CheckMoveStatusEnemy3

MoveEnemy3:
sub [enemy_3_x], ax

ret
endp MoveEnemies



proc ResetEnemies

CheckResetEnemy1:
cmp [enemy_1_x], 8 ; checking if it's about to hit the end of the map
jl ResetEnemy1X


CheckResetEnemy2:
cmp [enemy_2_x], 8 ; checking if it's about to hit the end of the map
jl ResetEnemy2X


CheckResetEnemy3:
cmp [enemy_3_x], 8 ; checking if it's about to hit the end of the map
jl ResetEnemy3X

ret

ResetEnemy1X:
mov [enemy_1_x], 140h
mov [enemy_1_move], 0 ; reset the enemie's move status
jmp CheckResetEnemy2

ResetEnemy2X:
mov [enemy_2_x], 140h
mov [enemy_2_move], 0 ; reset the enemie's move status
jmp CheckResetEnemy3

ResetEnemy3X:
mov [enemy_3_x], 140h
mov [enemy_3_move], 0 ; reset the enemie's move status

ret
endp ResetEnemies










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

proc MovementDirectionUpdate
	; Check if any key is being pressed
	mov ah, 01h
	int 16h
	jz DirectionDown

	; Check which key is being pressed
	mov ah, 00h
	int 16h

	cmp al, 20h ; if it's space
	je DirectionUp

	; if the key is not not space
	DirectionDown:
	mov [velocity], 01h
	ret

	; if the key is space 
	DirectionUp:
	mov [velocity], -01h
	ret

endp MovementDirectionUpdate

proc CharacterMove
	mov ax, [velocity]
	mov bx, [WINDOW_HEIGHT]
	mov cx, [character_height]
	sub bx,cx ; the height of the character is cx
	
	add [character_y], ax ; updating the character's initial y pos after moving

	cmp [character_y], 0 ; if we the character intersects with the top then we reset it's loc
	je RESET_LOC_TOP

	cmp [character_y], bx ; if we the character intersects with the bottom then we reset it's loc
	je RESET_LOC_BOTTOM

	
	ret

	RESET_LOC_TOP:
	mov [character_y], 1
	ret

	RESET_LOC_BOTTOM:
	dec [character_y]
	ret
endp CharacterMove



proc DrawCharacter ;Drawing our character
	; ax - character Y pos
	; bx - character_height
	; cx - character X pos


	mov dx, ax
	
	DRAW_CHARACTER_VERTICAL:
		; printring a pixel
		push ax
		push bx
		mov ah, 0Ch ;Drawing a pixel
		mov al, 0Fh ; making the pixel white
		mov bh, 00h ; page number
		int 10h ;execute the configurations
		pop bx
		pop ax


		inc dx ; for drawing another pixel under it

		push dx
		sub dx, ax
		cmp dx, bx ; check if the character's height is the wanted one
		pop dx
		jb DRAW_CHARACTER_VERTICAL ; if not, continue to draw
	ret
endp DrawCharacter


proc ExitProgram
	; set to text mode
	mov ah, 00h
	mov al, 02h
	int 10h


	; terminate program
	mov ah, 4Ch
	int 21h
endp ExitProgram



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
	mov cx, 0Ah ; height
	mov ax, 0Ah ; width
	call CopyBMPToMemory


	call CloseFile


	WAIT_FOR_TIME_CHANGE:

	cmp [exit_game], 1h ; leave the game?
	je EXIT_GAME_PROCESS

	cmp [game_active], 00h ; checking if the game ended
	je SHOW_GAME_OVER

	; system time
	mov ah, 2Ch
	int 21h ; dl= 1/100 seconds

	cmp dl, [time_last]
	je WAIT_FOR_TIME_CHANGE ; if the time hasn't change then we want to check again

	; the time has changed and we can change the new frame
	mov [time_last], dl ; updating the time
	
	call ClearScreen
	call MovementDirectionUpdate
	call CharacterMove
	call ResetEnemies
	call StartSendEnemies
	call MoveEnemies
	call CheckIntersection
	call userInterfaceDraw

	; main character drawing

	push offset picture
	push 0Ah ; width
	push 0Ah ; height
	push [character_x] ; x
	push [character_y] ; y
	call DrawFromMemory


	; enemies are taller :)
	mov bx, 01Ch

	; Draw enemy 1
	mov ax, [enemy_1_y] ; y pos of enemy 1
	mov cx, [enemy_1_x] ; x pos of enemy 1
	call DrawCharacter

	; Draw enemy 2
	mov ax, [enemy_2_y] ; y pos of enemy 2
	mov cx, [enemy_2_x] ; x pos of enemy 2
	call DrawCharacter

	; Draw enemy 3
	mov ax, [enemy_3_y] ; y pos of enemy 3
	mov cx, [enemy_3_x] ; x pos of enemy 3
	call DrawCharacter


	call CheckGameOver



	
	jmp WAIT_FOR_TIME_CHANGE

	EXIT_GAME_PROCESS:
	call ExitProgram
	
	SHOW_GAME_OVER:
		call DRAW_GAME_OVER_MENU
		jmp WAIT_FOR_TIME_CHANGE

	


	
exit:

	mov ax, 4c00h
	int 21h
END start


