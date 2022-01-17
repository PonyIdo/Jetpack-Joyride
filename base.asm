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
velocity DW 04h ; speed of the character

enemies_velocity DW 8h ; speed of the enemies

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



; coin property
coin_x DW 140h ; X postion of the coin
coin_y DW 50h ; Y postion of the coin

current_height DW 40
current_width DW 12



; enemies move status
enemy_1_move DB 0
enemy_2_move DB 0
enemy_3_move DB 0
coin_move DB 0



player_lives DB 3 ;Player lives - always starts with 3
player_coins DB 0

; texts to print on screen

TEXT_PLAYER_LIVES DB '0', '$'
TEXT_PLAYER_COINS DB '0', '$'
TEXT_GAME_END_MENU DB 'GAME OVER', '$'
TEXT_PLAY_AGAIN DB 'Press enter to play again', '$'
TEXT_COINS_HEADER DB 'MadanimCoins:', '$'

filename_player db 'pic.bmp',0
filename_enemy db 'pics.bmp',0
filename_coin db 'coin.bmp',0


current_x DW 0Ah ; X postion of the current object
current_y DW 0Ah ; Y postion of the current object


filehandle dw ?
Header db 54 dup (0)
Palette db 256*4 dup (0)
ScrLine db 2 dup (0)


CODESEG

proc OpenFilePlayer
	; Open file
	mov ah, 3Dh
	xor al, al
	mov dx, offset filename_player
	int 21h
	jc openerror
	mov [filehandle], ax

	ret
	openerror :
	call ExitProgram
	ret
endp OpenFilePlayer


proc OpenFileEnemy
	; Open file
	mov ah, 3Dh
	xor al, al
	mov dx, offset filename_enemy
	int 21h
	jc openerror2
	mov [filehandle], ax

	ret
	openerror2 :
	call ExitProgram
	ret
endp OpenFileEnemy

proc OpenFileCoin
	; Open file
	mov ah, 3Dh
	xor al, al
	mov dx, offset filename_coin
	int 21h
	jc openerror3
	mov [filehandle], ax

	ret
	openerror3 :
	call ExitProgram
	ret
endp OpenFileCoin



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
















proc CheckIntersection

	CoinIntersection:
	; X axis intersection - case 1
	mov ax, [coin_x]
	sub ax, [enemies_velocity]
	cmp ax, [character_x]

	jge Enemy1Intersection ; no intersection

	; X axis intersection - case 2
	mov ax, [coin_x]
	cmp ax, [character_x]

	jle Enemy1Intersection ; no intersection


	; Y axis intersection - case 1
	mov ax, [character_y]
	add ax, [character_height]
	cmp ax, [coin_y]
	jle Enemy2Intersection ; no intersection

	; Y axis intersection - case 2
	mov ax, [coin_y]
	add ax, [enemy_height]
	cmp [character_y], ax 
	jge Enemy1Intersection ; no intersection

	; Here we have an intersection
	inc [player_coins]

	; hide coin
	mov [coin_x], 140h
	mov [coin_move], 0 ; reset the enemie's move status

	ret ; exit because there was an intersection





	
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

	call UpdateCoinsText
	; Draws the coins status
	mov ah, 02h ; cursor position
	mov bh, 00h ; page number
	mov dh, 04h ; row
	mov dl, 14h ; column
	int 10h 

	mov ah, 09h ; write string to standart output
	lea dx, [TEXT_PLAYER_COINS]
	int 21h



	
	; Draws the coins header
	mov ah, 02h ; cursor position
	mov bh, 00h ; page number
	mov dh, 04h ; row
	mov dl, 7h ; column
	int 10h 

	mov ah, 09h ; write string to standart output
	lea dx, [TEXT_COINS_HEADER]
	int 21h
	ret
endp userInterfaceDraw


proc UpdateLivesText
	xor ax, ax
	mov al, [player_lives]

	add al, 30h ; converting to ascii
	mov [TEXT_PLAYER_LIVES], al
endp UpdateLivesText


proc UpdateCoinsText
	xor ax, ax
	mov al, [player_coins]

	add al, 30h ; converting to ascii
	mov [TEXT_PLAYER_COINS], al
endp UpdateCoinsText



proc Random
	mov ah, 00h ; interrupts to get system time        
	int 1AH ; CX:DX now hold number of clock ticks since midnight      
	mov ax, dx
	xor dx, dx
	mov cx, 60
	div cx ; here dx contains the remainder of the division
	ret 
endp Random


proc RandomCoin
	mov ah, 00h ; interrupts to get system time        
	int 1AH ; CX:DX now hold number of clock ticks since midnight      
	mov ax, dx
	xor dx, dx
	mov cx, 91
	div cx ; here dx contains the remainder of the division
	ret 
endp RandomCoin


proc RandomCoinY
	mov ah, 00h ; interrupts to get system time        
	int 1AH ; CX:DX now hold number of clock ticks since midnight      
	mov ax, dx
	xor dx, dx
	mov cx, 120
	div cx ; here dx contains the remainder of the division
	ret 
endp RandomCoinY




proc StartSendEnemies

call RandomCoin ; dx contains the random number

cmp dx, 90 ; check the random number to see if it needs to start moving the coin
je EnableMoveCoin



call Random ; dx contains the random number


cmp dx, 20 ; check the random number to see if it needs to start moving enemy 1
je EnableMove1


cmp dx, 40 ; check the random number to see if it needs to start moving enemy 2
je EnableMove2



cmp dx, 59 ; check the random number to see if it needs to start moving enemy 3
je EnableMove3






ret

EnableMoveCoin:
call RandomCoinY ; dx contains the random number
mov [coin_y], dx
mov [coin_move], 1 ; turn on the coin's move status
mov [coin_x], 139h
ret


EnableMove3:
mov [enemy_3_move], 1 ; turn on the enemie's move status
mov [enemy_3_x], 139h
ret

EnableMove2:
mov [enemy_2_move], 1 ; turn on the enemie's move status
mov [enemy_2_x], 139h
ret


EnableMove1:
mov [enemy_1_move], 1 ; turn on the enemie's move status
mov [enemy_1_x], 139h

ret
endp StartSendEnemies




proc MoveEnemies
mov ax, [enemies_velocity]


CheckMoveStatusCoin:
cmp [coin_move], 1
je MoveCoin

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

MoveCoin:
sub [coin_x], ax
jmp CheckMoveStatusEnemy1

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

CheckResetCoin:
cmp [coin_x], 8 ; checking if it's about to hit the end of the map
jl ResetCoinX


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

ResetCoinX:
mov [coin_x], 140h
mov [coin_move], 0 ; reset the coin's move status
jmp CheckResetEnemy1

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
	


	mov ax,0600h
	;mov bh,3h
	mov cx,0h
	mov dx,184fh
	int 10h
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
	mov [velocity], 04h
	ret

	; if the key is space 
	DirectionUp:
	mov [velocity], -04h
	ret

endp MovementDirectionUpdate

proc CharacterMove
	mov ax, [velocity]
	mov bx, [WINDOW_HEIGHT]
	sub bx, ax ; because we do not want to touch the ground, we want to touch nearby
	mov cx, [character_height]
	sub bx,cx ; the height of the character is cx
	
	add [character_y], ax ; updating the character's initial y pos after moving

	cmp [character_y], ax ; if we the character intersects with the top then we reset it's loc
	jle RESET_LOC_TOP

	cmp [character_y], bx ; if we the character intersects with the bottom then we reset it's loc
	jge RESET_LOC_BOTTOM

	
	ret

	RESET_LOC_TOP:
	mov [character_y], ax
	ret

	RESET_LOC_BOTTOM:
	sub [character_y], ax
	ret
endp CharacterMove




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
	ret
endp CheckGameOver




proc ExitProgram
	; set to text mode
	mov ah, 00h
	mov al, 02h
	int 10h


	; terminate program
	mov ah, 4Ch
	int 21h
endp ExitProgram





proc ReadHeader
	; Read BMP file header, 54 bytes
	mov ah,3fh
	mov bx, [filehandle]
	mov cx,54
	mov dx,offset Header
	int 21h
	ret
endp ReadHeader

proc ReadPalette
	; Read BMP file color palette, 256 colors * 4 bytes (400h)
	mov ah,3fh
	mov cx,400h
	mov dx,offset Palette
	int 21h
	ret
endp ReadPalette

proc CopyPal
	; Copy the colors palette to the video memory
	; The number of the first color should be sent to port 3C8h
	; The palette is sent to port 3C9h
	mov si,offset Palette
	mov cx,256
	mov dx,3C8h
	mov al,0
	; Copy starting color to port 3C8h
	out dx,al
	; Copy palette itself to port 3C9h
	inc dx
	PalLoop:
	; Note: Colors in a BMP file are saved as BGR values rather than RGB .
	mov al,[si+2] ; Get red value .
	shr al,2 ; Max. is 255, but video palette maximal
	; value is 63. Therefore dividing by 4.
	out dx,al ; Send it .
	mov al,[si+1] ; Get green value .
	shr al,2
	out dx,al ; Send it .
	mov al,[si] ; Get blue value .
	shr al,2
	out dx,al ; Send it .
	add si,4 ; Point to next color .
	; (There is a null chr. after every color.)

	loop PalLoop
	ret
endp CopyPal


proc CopyBitmap
	; BMP graphics are saved upside-down .
	; Read the graphic line by line (200 lines in VGA format),
	; displaying the lines from bottom to top.
	mov ax, 0A000h
	mov es, ax
	mov cx,[current_height] ; controls y axis
	add cx, [current_y]
	PrintBMPLoop :
	push cx
	; di = cx*320, point to the correct screen line
	mov di,cx
	shl cx,6
	shl di,8
	add di,cx
	add di, [current_x] ; di controls x axis
	; Read one line
	mov ah,3fh
	mov cx,[current_width]
	mov dx,offset ScrLine
	int 21h
	; Copy one line into video memory
	cld ; Clear direction flag, for movsb
	mov cx,[current_width]
	mov si,offset ScrLine

	rep movsb ; Copy line to the screen
	pop cx
	mov ax, [current_y]
	inc ax
	cmp cx, ax
	je Quit
	loop PrintBMPLoop
	Quit:
	ret
endp CopyBitmap







proc CloseFile
  mov  ah, 3Eh
  mov  bx, [filehandle]
  int  21h
  ret
endp CloseFile


proc DrawEnemies

	; enemies are taller
	mov [current_height], 40
	mov [current_width], 12

	CheckDraw1:
	cmp [enemy_1_move], 1
	je Draw1

	CheckDraw2:
	cmp [enemy_2_move], 1
	je Draw2

	CheckDraw3:
	cmp [enemy_3_move], 1
	je Draw3

	CheckCoin:
	cmp [coin_move], 1
	je DrawCoin

ret







	Draw1:
	mov ax, [enemy_1_y] ; y pos of enemy 1
	mov [current_y], ax ; y pos of enemy 1
	mov ax, [enemy_1_x] ; x pos of enemy 1
	mov [current_x], ax ; x pos of enemy 1

	call OpenFileEnemy
  call ReadHeader
  call ReadPalette
  call CopyPal
  call CopyBitmap
  call CloseFile
  jmp CheckDraw2

	

	Draw2:
	mov ax, [enemy_2_y] ; y pos of enemy 2
	mov [current_y], ax ; y pos of enemy 2
	mov ax, [enemy_2_x] ; x pos of enemy 2
	mov [current_x], ax ; x pos of enemy 2

	call OpenFileEnemy
  call ReadHeader
  call ReadPalette
  call CopyPal
  call CopyBitmap
  call CloseFile
  jmp CheckDraw3



	Draw3:
	mov ax, [enemy_3_y] ; y pos of enemy 3
	mov [current_y], ax ; y pos of enemy 3
	mov ax, [enemy_3_x] ; x pos of enemy 3
	mov [current_x], ax ; x pos of enemy 3

	call OpenFileEnemy
  call ReadHeader
  call ReadPalette
  call CopyPal
  call CopyBitmap
  call CloseFile
  jmp CheckCoin



  DrawCoin:
	mov [current_height], 16
	mov [current_width], 16

  ;Draw coin
	mov ax, [coin_y] ; y pos of the coin
	mov [current_y], ax ; y pos of the coin
	mov ax, [coin_x] ; x pos of the coin
	mov [current_x], ax ; x pos of the coin


  call OpenFileCoin
  call ReadHeader
  call ReadPalette
  call CopyPal
  call CopyBitmap
  call CloseFile
  ret

endp DrawEnemies



SHOW_GAME_OVER:
		call DRAW_GAME_OVER_MENU
		jmp WAIT_FOR_TIME_CHANGE

	EXIT_GAME_PROCESS:
	call ExitProgram



start:
	mov ax, @data
	mov ds, ax

	mov ax, 013h ; set vga mode
	int 10h
	call ClearScreen

	WAIT_FOR_TIME_CHANGE:

	cmp [exit_game], 1h ; leave the game?
	je EXIT_GAME_PROCESS

	cmp [game_active], 00h ; checking if the game ended
	je SHOW_GAME_OVER




	; system time
	mov ah, 2Ch
	int 21h ; dl= 1/100 seconds

	cmp dl, [time_last]
	je WAIT_FOR_TIME_CHANGE ; if the time hasn't change we want to check again



	
	; the time has changed and we can change the new frame
	push dx
	
	call ClearScreen
	call MovementDirectionUpdate
	call CharacterMove
	call ResetEnemies
	call StartSendEnemies
	call MoveEnemies
	call CheckIntersection
	call userInterfaceDraw


	; Drawing the player
	mov ax, [character_y] ; y pos of the player
	mov [current_y], ax ; y pos of the player
	mov ax, [character_x] ; x pos of the player
	mov [current_x], ax ; x pos of the player

	mov [current_height], 24
	mov [current_width], 24

	call OpenFilePlayer
  call ReadHeader
  call ReadPalette
  call CopyPal
  call CopyBitmap
  call CloseFile


	call DrawEnemies
	call CheckGameOver

	pop dx


	mov [time_last], dl ; updating the time
	jmp WAIT_FOR_TIME_CHANGE


	
exit:

	mov ax, 4c00h
	int 21h
END start


