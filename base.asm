IDEAL

MODEL small

STACK 100h

DATASEG
WINDOW_WIDTH DW 140h ; width of the window
WINDOW_HEIGHT DW 0c8h ; height of the window

NextRandom dw 0





; Ports
pit db 43h
pit2 db 42h



; delay
default_delay dw 1200
game_over_delay dw 1700
slow_delay dw 2700



delay dw 0 
count_slow dw 0
count_pause dw 0


filename_wav_game_over db "GameOver.wav", 0 
filename_wav_music db "music.wav", 0 

filehandle_wav dw 0


Buffer db 0
slow_music dw 0




; First Game status (Yes(1)\No(0))
first_game DB 1h




; Game active status (Yes(1)\No(0))
game_active DB 0h

; Exit the game (Yes(1)\No(0))
exit_game DB 0h

character_x DW 30 ; X postion of the character
character_y DW 0Ah ; Y postion of the character
character_height DW 0Eh
enemy_height DW 01Ch
time_last DB 0 ; used to check if the time has changed
velocity DW 04h ; speed of the character

enemies_velocity DW 8h ; speed of the enemies
missile_velocity DW 15 ; speed of the enemies

rand_fast DW 2000
; enemies loc

; enemy 1 property
enemy_1_x DW 140h ; X postion of the enemy 1
enemy_1_y DW 8h ; Y postion of the enemy 1 - 100

; enemy 2 property
enemy_2_x DW 140h ; X postion of the enemy 2
enemy_2_y DW 70 ; Y postion of the enemy 2 - 200

; enemy 3 property
enemy_3_x DW 140h ; X postion of the enemy 3
enemy_3_y DW 84h ; Y postion of the enemy 3 - 300



; coin property
coin_x DW 140h ; X postion of the coin
coin_y DW 50h ; Y postion of the coin

; slow property
slow_x DW 140h ; X postion of the coin
slow_y DW 50h ; Y postion of the coin

; pause property
pause_x DW 140h ; X postion of the coin
pause_y DW 50h ; Y postion of the coin

; heart property
heart_x DW 140h ; X postion of the heart
heart_y DW 50h ; Y postion of the heart


; missile property
missile_x DW 140h ; X postion of the missile
missile_y DW 40 ; Y postion of the missile




current_height DW 40
current_width DW 12

score_text db "Score:$"
score dw 0


scrollX DW 320


player_paused DW 0
paused_y_loc DW 0

; enemies move status
enemy_1_move DB 0
enemy_2_move DB 0
enemy_3_move DB 0
coin_move DB 0
pause_move DB 0
slow_move DB 0
heart_move DB 0
missile_move DB 0



player_lives DB 3 ;Player lives - always starts with 3
player_coins DB 0

; texts to print on screen

TEXT_PLAYER_COINS DB '0', '$'
TEXT_GAME_END_MENU DB 'GAME OVER', '$'
TEXT_PLAY_AGAIN DB 'Press enter to play again', '$'
TEXT_EXPLANATION DB 'Tutorial:To go up press the SPACE button     You need to avoid the obstacles!', '$'
TEXT_COINS_HEADER DB 'MadanimCoins:', '$'
TEXT_PAUSED DB 'You get paused, not the enemies', '$'
TEXT_SCORE_HEADER DB 'score:', '$'


filename_player db 'pic.bmp',0
filename_enemy db 'pics.bmp',0
filename_missile db 'missile.bmp',0
filename_coin db 'coin.bmp',0
filename_pause db 'pause.bmp',0
filename_slow db 'time.bmp',0
filename_heart db 'heart.bmp',0
filename_heart1 db 'heart1.bmp',0
filename_heart2 db 'heart2.bmp',0
filename_heart3 db 'heart3.bmp',0

filename_bg1 db 'bg1.bmp',0
filename_bg2 db 'bg2.bmp',0

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


proc OpenFileBg1
	; Open file
	mov ah, 3Dh
	xor al, al
	mov dx, offset filename_bg1
	int 21h
	jc openerror8
	mov [filehandle], ax

	ret
	openerror8 :
	call ExitProgram
	ret
endp OpenFileBg1

proc OpenFileBg2
	; Open file
	mov ah, 3Dh
	xor al, al
	mov dx, offset filename_bg2
	int 21h
	jc openerror10
	mov [filehandle], ax

	ret
	openerror10 :
	call ExitProgram
	ret
endp OpenFileBg2







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


proc OpenFilemissile
	; Open file
	mov ah, 3Dh
	xor al, al
	mov dx, offset filename_missile
	int 21h
	jc openerror11
	mov [filehandle], ax

	ret
	openerror11 :
	call ExitProgram
	ret
endp OpenFilemissile


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


proc OpenFilePause
	; Open file
	mov ah, 3Dh
	xor al, al
	mov dx, offset filename_pause
	int 21h
	jc openerror32
	mov [filehandle], ax

	ret
	openerror32 :
	call ExitProgram
	ret
endp OpenFilePause

proc OpenFileSlow
	; Open file
	mov ah, 3Dh
	xor al, al
	mov dx, offset filename_slow
	int 21h
	jc openerror31
	mov [filehandle], ax

	ret
	openerror31 :
	call ExitProgram
	ret
endp OpenFileSlow

proc OpenFileHeart
	; Open file
	mov ah, 3Dh
	xor al, al
	mov dx, offset filename_heart
	int 21h
	jc openerror13
	mov [filehandle], ax

	ret
	openerror13 :
	call ExitProgram
	ret
endp OpenFileHeart

proc OpenFileHeart1
	; Open file
	mov ah, 3Dh
	xor al, al
	mov dx, offset filename_heart1
	int 21h
	jc openerror4
	mov [filehandle], ax

	ret
	openerror4 :
	call ExitProgram
	ret
endp OpenFileHeart1


proc OpenFileHeart2
	; Open file
	mov ah, 3Dh
	xor al, al
	mov dx, offset filename_heart2
	int 21h
	jc openerror5
	mov [filehandle], ax

	ret
	openerror5 :
	call ExitProgram
	ret
endp OpenFileHeart2


proc OpenFileHeart3
	; Open file
	mov ah, 3Dh
	xor al, al
	mov dx, offset filename_heart3
	int 21h
	jc openerror6
	mov [filehandle], ax

	ret
	openerror6 :
	call ExitProgram
	ret
endp OpenFileHeart3


proc DRAW_GAME_OVER_MENU

	add [scrollX], 10
	call BackgroundMove


	mov [current_y], 50 ; y pos of enemy 1
	mov [current_x], 60 ; x pos of enemy 1
	mov [current_height], 100
	mov [current_width], 164

	call OpenFileBg2
  call ReadHeader
  call ReadPalette
  call CopyPal
  call CopyBitmap
  call CloseFile



	; Displaying play again message
	mov ah, 02h ; cursor position
	mov bh, 00h ; page number
	mov dh, 13h ; row
	mov dl, 04h ; column
	int 10h

	mov ah, 09h ; write string to standart output
	lea dx, [TEXT_PLAY_AGAIN]
	int 21h




	; Displaying play again message
	mov ah, 02h ; cursor position
	mov bh, 00h ; page number
	mov dh, 2h ; row
	mov dl, 00h ; column
	int 10h

	mov ah, 09h ; write string to standart output
	lea dx, [TEXT_EXPLANATION]
	int 21h
	

cmp [first_game], 1
je KEY_PRESS_WAIT
call CloseFileWav
call PlayGameOverSound

	KEY_PRESS_WAIT:

	; Wait for key press
	mov ah, 00h
	int 16h


	cmp al, 01Bh ; if the key is espace - leave the game
	je LEAVE_GAME


	cmp al, 00Dh ; if it's not enter
	jne KEY_PRESS_WAIT

	

	; Game active status - starts the game
	call InitiateMusic
	mov [game_active], 01h


	ret


	LEAVE_GAME:
	mov [exit_game], 01h
	ret


endp DRAW_GAME_OVER_MENU
















proc CheckIntersection

	missileIntersection:
	; X axis intersection - case 1
	mov ax, [missile_x]
	sub ax, [missile_velocity]
	cmp ax, [character_x]

	jge CoinIntersection ; no intersection

	; X axis intersection - case 2
	mov ax, [missile_x]
	cmp ax, [character_x]

	jle CoinIntersection ; no intersection

	mov cx, 4
	mov bx, [missile_y]

	LoopYIntersectionmissile:
	; Y axis intersection - case 1
	mov ax, [character_y]
	add ax, 16
	cmp ax, bx
	jl NoIntersection ; no intersection

	; Y axis intersection - case 2
	mov ax, bx
	add ax, 16
	cmp [character_y], ax 
	jl missileIntersect ; intersection

NoIntersection:
	add bx, 40
	loop LoopYIntersectionmissile

	jmp CoinIntersection ; no intersection



	missileIntersect:
		; Here we have an intersection
	dec [player_lives]

	ret ; exit because there was an intersection





	CoinIntersection:
	; X axis intersection - case 1
	mov ax, [coin_x]
	sub ax, [enemies_velocity]
	cmp ax, [character_x]

	jge PauseIntersection ; no intersection

	; X axis intersection - case 2
	mov ax, [coin_x]
	cmp ax, [character_x]

	jle PauseIntersection ; no intersection


	; Y axis intersection - case 1
	mov ax, [character_y]
	add ax, [character_height]
	cmp ax, [coin_y]
	jle PauseIntersection ; no intersection

	; Y axis intersection - case 2
	mov ax, [coin_y]
	add ax, [enemy_height]
	cmp [character_y], ax 
	jge PauseIntersection ; no intersection

	; Here we have an intersection
	inc [player_coins]

	; hide coin
	mov [coin_x], 140h
	mov [coin_move], 0 ; reset the enemie's move status

	ret ; exit because there was an intersection


	PauseIntersection:
	; X axis intersection - case 1
	mov ax, [pause_x]
	sub ax, [enemies_velocity]
	cmp ax, [character_x]

	jge SlowIntersection ; no intersection

	; X axis intersection - case 2
	mov ax, [pause_x]
	cmp ax, [character_x]

	jle SlowIntersection ; no intersection


	; Y axis intersection - case 1
	mov ax, [character_y]
	add ax, [character_height]
	cmp ax, [pause_y]
	jle SlowIntersection ; no intersection

	; Y axis intersection - case 2
	mov ax, [pause_y]
	add ax, [enemy_height]
	cmp [character_y], ax 
	jge SlowIntersection ; no intersection

	; Here we have an intersection
	mov [player_paused], 1
	mov ax, [character_y]
	mov [paused_y_loc], ax
	mov [count_pause], 0

	; hide coin
	mov [pause_x], 140h
	mov [pause_move], 0 ; reset the enemie's move status

	ret ; exit because there was an intersection



	SlowIntersection:
	; X axis intersection - case 1
	mov ax, [slow_x]
	sub ax, [enemies_velocity]
	cmp ax, [character_x]

	jge HeartIntersection ; no intersection

	; X axis intersection - case 2
	mov ax, [slow_x]
	cmp ax, [character_x]

	jle HeartIntersection ; no intersection


	; Y axis intersection - case 1
	mov ax, [character_y]
	add ax, [character_height]
	cmp ax, [slow_y]
	jle HeartIntersection ; no intersection

	; Y axis intersection - case 2
	mov ax, [slow_y]
	add ax, [enemy_height]
	cmp [character_y], ax 
	jge HeartIntersection ; no intersection

	; Here we have an intersection
	mov [slow_music], 1
	mov [count_slow], 0

	; hide slow
	mov [slow_x], 140h
	mov [slow_move], 0 ; reset the enemie's move status

	ret ; exit because there was an intersection



	HeartIntersection:
	; X axis intersection - case 1
	mov ax, [heart_x]
	sub ax, [enemies_velocity]
	cmp ax, [character_x]

	jge Enemy1Intersection ; no intersection

	; X axis intersection - case 2
	mov ax, [heart_x]
	cmp ax, [character_x]

	jle Enemy1Intersection ; no intersection


	; Y axis intersection - case 1
	mov ax, [character_y]
	add ax, [character_height]
	cmp ax, [heart_y]
	jle Enemy1Intersection ; no intersection

	; Y axis intersection - case 2
	mov ax, [heart_y]
	add ax, [enemy_height]
	cmp [character_y], ax 
	jge Enemy1Intersection ; no intersection

	; Here we have an intersection
	inc [player_lives]

	; hide heart
	mov [heart_x], 140h
	mov [heart_move], 0 ; reset the enemie's move status

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

	call UpdateCoinsText
	; Draws the coins status
	mov ah, 02h ; cursor position
	mov bh, 00h ; page number
	mov dh, 03h ; row
	mov dl, 14h ; column
	int 10h 

	mov ah, 09h ; write string to standart output
	lea dx, [TEXT_PLAYER_COINS]
	int 21h



	
	; Draws the coins header
	mov ah, 02h ; cursor position
	mov bh, 00h ; page number
	mov dh, 03h ; row
	mov dl, 7h ; column
	int 10h 

	mov ah, 09h ; write string to standart output
	lea dx, [TEXT_COINS_HEADER]
	int 21h





	; Draws the coins header
	mov ah, 02h ; cursor position
	mov bh, 00h ; page number
	mov dh, 05h ; row
	mov dl, 7h ; column
	int 10h 

	mov ah, 09h ; write string to standart output
	lea dx, [TEXT_SCORE_HEADER]
	int 21h





		mov dl, 6
		mov ax, [offset score]
		call PrintNumber


	ret
endp userInterfaceDraw

proc PrintNumber
	push cx
	push dx
	push bx
    ; initilize count:
    xor cx, cx
    xor dx, dx

    Label1:
        ; if ax is zero:
        cmp ax,0
        je Print1
        
        ; initilize bx to 10:
        mov bx,10
        
		xor dx, dx
        ; extract the last digit:
        div bx
        
        ; push it in the stack:
        push dx
        
        ; increment the count:
        inc cx
        
        jmp Label1

    Print1:
        ; check if count:

        ; is greater than zero:
        cmp cx,0
        je Endprint
        
        ; pop the top of stack:
        pop dx

        ; add 48 so that it represents the ASCII value of digits:
        add dx, '0' 
        
        ; interuppt to print a character:
        mov ah,02h
        int 21h
        
        ; decrease the count:
        dec cx
        jmp Print1
    
    Endprint:
		pop bx
		pop dx
		pop cx
        ret
endp





proc UpdateCoinsText
	xor ax, ax
	mov al, [player_coins]

	add al, 30h ; converting to ascii
	mov [TEXT_PLAYER_COINS], al
endp UpdateCoinsText





proc RandomCoinY
	mov ah, 00h ; interrupts to get system time        
	int 1AH ; CX:DX now hold number of clock ticks since midnight      
	mov ax, dx
	xor dx, dx
	mov cx, 120
	div cx ; here dx contains the remainder of the division
	ret 
endp RandomCoinY


;; returns pseudo random number of 2 bytes in ax. The seed is set and updated in NextRandom.
proc prg
    push dx
    xor dx, dx

    mov ax, [NextRandom]
    mov dx, 25173
    imul dx

    add  ax, 13849
    xor  ax, 62832
    mov  [NextRandom], ax

    pop dx
    ret
endp prg









proc StartSendEnemies

;; get time
mov ah, 2Ch 
int 21h

;; set seed as secs:mi secs
mov [NextRandom], dx
    
;; get (pseudo) random number
call prg


cmp ax, 250 ; check the random number to see if it needs to start moving the missile
jb CheckmissileMove

cmp ax, 500 ; check the random number to see if it needs to start moving the heart
jb CheckHeartMove

cmp ax, 630 ; check the random number to see if it needs to start moving the heart
jb CheckPauseMove

cmp ax, 800 ; check the random number to see if it needs to start moving the slow
jb CheckSlowMove

cmp ax, 1000 ; check the random number to see if it needs to start moving the coin
jb CheckCoinMove


mov bx, [rand_fast]

cmp ax, bx ; check the random number to see if it needs to start moving enemy 1
jb CheckEnemy1Move

add bx, [rand_fast]
cmp ax, bx ; check the random number to see if it needs to start moving enemy 2
jb CheckEnemy2Move


add bx, [rand_fast]
cmp ax, bx ; check the random number to see if it needs to start moving enemy 3
jb CheckEnemy3Move



ret


CheckmissileMove:
cmp [missile_move], 0
je EnableMovemissile
ret

CheckCoinMove:
cmp [coin_move], 0
je EnableMoveCoin
ret


CheckPauseMove:
cmp [pause_move], 0
je EnableMovePause
ret

CheckSlowMove:
cmp [slow_move], 0
je EnableMoveSlow
ret

CheckHeartMove:
cmp [player_lives], 3
je SkipHeartSend
cmp [heart_move], 0
je EnableMoveHeart
SkipHeartSend:
ret

CheckEnemy1Move:
cmp [enemy_1_move], 0
je JumpCall
ret

CheckEnemy2Move:
cmp [enemy_2_move], 0
je EnableMove2
ret

CheckEnemy3Move:
cmp [enemy_3_move], 0
je EnableMove3
ret



EnableMovemissile:
mov [missile_move], 1 ; turn on the coin's move status
mov [missile_x], 139h
ret

EnableMoveHeart:
call RandomCoinY ; dx contains the random number
mov [heart_y], dx
mov [heart_move], 1 ; turn on the coin's move status
mov [heart_x], 139h
ret


EnableMovePause:
call RandomCoinY ; dx contains the random number
mov [pause_y], dx
mov [pause_move], 1 ; turn on the coin's move status
mov [pause_x], 139h
ret



EnableMoveSlow:
call RandomCoinY ; dx contains the random number
mov [slow_y], dx
mov [slow_move], 1 ; turn on the coin's move status
mov [slow_x], 139h
ret

EnableMoveCoin:
call RandomCoinY ; dx contains the random number
mov [coin_y], dx
mov [coin_move], 1 ; turn on the coin's move status
mov [coin_x], 139h
ret



JumpCall:
jmp EnableMove1

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

CheckMoveStatusmissile:
cmp [missile_move], 1
je Movemissile

CheckMoveStatusCoin:
cmp [coin_move], 1
je MoveCoin


CheckMoveStatusPause:
cmp [pause_move], 1
je MovePause

CheckMoveStatusSlow:
cmp [slow_move], 1
je MoveSlow

CheckMoveStatusHeart:
cmp [heart_move], 1
je MoveHeart

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

Movemissile:
mov ax, [missile_velocity]
sub [missile_x], ax
mov ax, [enemies_velocity]
jmp CheckMoveStatusCoin

MoveCoin:
sub [coin_x], ax
jmp CheckMoveStatusPause


MovePause:
sub [pause_x], ax
jmp CheckMoveStatusSlow

MoveSlow:
sub [slow_x], ax
jmp CheckMoveStatusHeart

MoveHeart:
sub [heart_x], ax
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

CheckResetmissile:
cmp [missile_x], 10 ; checking if it's about to hit the end of the map
jl ResetmissileX

CheckResetCoin:
cmp [coin_x], 8 ; checking if it's about to hit the end of the map
jl ResetCoinX

CheckResetPause:
cmp [pause_x], 8 ; checking if it's about to hit the end of the map
jl ResetPauseX


CheckResetSlow:
cmp [slow_x], 8 ; checking if it's about to hit the end of the map
jl ResetSlowX

CheckResetHeart:
cmp [heart_x], 8 ; checking if it's about to hit the end of the map
jl ResetHeartX


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

ResetmissileX:
mov [missile_x], 140h
mov [missile_move], 0 ; reset the missile's move status
jmp CheckResetCoin


ResetCoinX:
mov [coin_x], 140h
mov [coin_move], 0 ; reset the coin's move status
jmp CheckResetPause


ResetPauseX:
mov [pause_x], 140h
mov [pause_move], 0 ; reset the coin's move status
jmp CheckResetSlow

ResetSlowX:
mov [slow_x], 140h
mov [slow_move], 0 ; reset the coin's move status
jmp CheckResetHeart

ResetHeartX:
mov [heart_x], 140h
mov [heart_move], 0 ; reset the heart's move status
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
	


	mov ax,0A000h
mov es,ax
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
	add cx, 20
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
	mov ax,0600h
	;mov bh,3h
	mov cx,0h
	mov dx,184fh
	int 10h
	
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


	mov [score], 0

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


proc DrawCoinProc
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
 endp DrawCoinProc

proc DrawPauseProc
	mov [current_height], 16
	mov [current_width], 16

  ;Draw coin
	mov ax, [pause_y] ; y pos of the coin
	mov [current_y], ax ; y pos of the coin
	mov ax, [pause_x] ; x pos of the coin
	mov [current_x], ax ; x pos of the coin


  call OpenFilePause
  call ReadHeader
  call ReadPalette
  call CopyPal
  call CopyBitmap
  call CloseFile
  ret
 endp DrawPauseProc

proc DrawSlowProc
	mov [current_height], 16
	mov [current_width], 16

  ;Draw slow
	mov ax, [slow_y] ; y pos of the coin
	mov [current_y], ax ; y pos of the coin
	mov ax, [slow_x] ; x pos of the coin
	mov [current_x], ax ; x pos of the coin


  call OpenFileSlow
  call ReadHeader
  call ReadPalette
  call CopyPal
  call CopyBitmap
  call CloseFile
  ret
 endp DrawSlowProc

proc DrawHeartProc
	mov [current_height], 16
	mov [current_width], 16

  ;Draw heart
	mov ax, [heart_y] ; y pos of the heart
	mov [current_y], ax ; y pos of the heart
	mov ax, [heart_x] ; x pos of the heart
	mov [current_x], ax ; x pos of the heart


  call OpenFileHeart
  call ReadHeader
  call ReadPalette
  call CopyPal
  call CopyBitmap
  call CloseFile
  ret
 endp DrawHeartProc



proc DrawmissileProc
	mov [current_height], 16
	mov [current_width], 32


	mov ax, [missile_y] ; y pos of the missile
	mov [current_y], ax ; y pos of the missile
	mov ax, [missile_x] ; x pos of the missile
	mov [current_x], ax ; x pos of the missile

	mov cx, 4

  missileDrawLoop:
  push cx
  call OpenFilemissile
  call ReadHeader
  call ReadPalette
  call CopyPal
  call CopyBitmap
  call CloseFile
  pop cx
  add [current_y], 40
  loop missileDrawLoop

  ret

endp DrawmissileProc




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

	CheckPause:
	cmp [pause_move], 1
	je DrawPause

	CheckSlow:
	cmp [slow_move], 1
	je DrawSlow


	CheckHeart:
	cmp [Heart_move], 1
	je DrawHeart


	Checkmissile:
	cmp [missile_move], 1
	je Drawmissile

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
call DrawCoinProc
jmp CheckPause


DrawPause:
call DrawPauseProc
jmp CheckSlow

DrawSlow:
call DrawSlowProc
jmp CheckHeart

DrawHeart:
call DrawHeartProc
jmp Checkmissile

Drawmissile:
call DrawmissileProc
ret







  

endp DrawEnemies





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
	dec cx

	; Copy line to the screen
	CopyLine:
	mov ax, [ds:si]
	cmp ax, 0
	je SkipDraw
	mov [es:di], ax
	SkipDraw:
	inc si
	inc di


	loop CopyLine




		
	pop cx
	mov ax, [current_y]
	inc ax
	cmp cx, ax
	je Quit
	loop PrintBMPLoop
	Quit:
	ret
endp CopyBitmap





proc CloseFileWav
  mov  ah, 3Eh
  mov  bx, [filehandle_wav]
  int  21h
  ret
endp CloseFileWav

proc CloseFile
  mov  ah, 3Eh
  mov  bx, [filehandle]
  int  21h
  ret
endp CloseFile



proc DrawHeartBar

	mov [current_y], 25 ; y pos of enemy 1
	mov [current_x], 270 ; x pos of enemy 1
	mov [current_height], 8
	mov [current_width], 28
	mov al, [player_lives]

cmp al, 1
	je DrawHeart1

cmp al, 2
	je DrawHeart2


cmp al,3
	je DrawHeart3

ret


DrawHeart1:
	call OpenFileHeart1
  call ReadHeader
  call ReadPalette
  call CopyPal
  call CopyBitmap
  call CloseFile

  ret


DrawHeart2:
	call OpenFileHeart2
  call ReadHeader
  call ReadPalette
  call CopyPal
  call CopyBitmap
  call CloseFile

  ret


DrawHeart3:
	call OpenFileHeart3
  call ReadHeader
  call ReadPalette
  call CopyPal
  call CopyBitmap
  call CloseFile

  ret





endp DrawHeartBar








proc BackgroundMove
sub [scrollX], 10
mov ax, [scrollX]

mov cx, 4
BgLoopDraw:
push cx
push ax
; Drawing the first background
	mov [current_y], 0 ; y pos of the player
	mov [current_x], ax ; x pos of the player

	mov [current_height], 200
	mov [current_width], 80

	call OpenFileBg1
  call ReadHeader
  call ReadPalette
  call CopyPal
  call CopyBitmap
  call CloseFile
  pop ax
  pop cx
  sub ax, 80

  loop BgLoopDraw



  cmp [scrollX], 0
  jle ResetScrollX

  

  ret

  ResetScrollX:
  mov [scrollX], 320
  ret
endp BackgroundMove






proc read ; Read next sample
    push bx
    push cx
    push dx
    mov ah, 3Fh
    mov bx, [filehandle_wav]
    mov cx, 1
    lea dx, [Buffer]
    int 21h
   
    mov al, [Buffer]
    xor ah, ah
    mov bx, 54
    mul bx
    ;call PrintAX
    ; mov ax, dx ; Result is in DX because we need to div by 65536 which is all of AX
    shr ax, 8
    pop dx
    pop cx
    pop bx
    ret
endp read





proc RealPlay
	mov cx, 1600
	totalloop1:
	push cx
    call read ; Read file
    out 42h, al ; Send data
    mov bx, ax
    mov cx, [delay]
	portloop1:
    loop portloop1
    mov ax, bx
    out 42h, ax ; Send data
    mov cx, [delay]
	rloop1:
    loop rloop1
    call read
    pop cx
    loop totalloop1
    ret
endp RealPlay


proc PlayGameOverSound
mov cx, [game_over_delay]
mov [delay], cx
	mov ah, 3Dh
    xor al, al
    lea dx, [filename_wav_game_over]
    int 21h
    mov [filehandle_wav], ax
    mov al, 90h
    out 43h, al
    in al, 61h
    or al, 3
    out 61h, al
    cli
    mov ax, 0
mov cx, 65535
	totalloop2:
	push cx
    call read ; Read file
    out 42h, al ; Send data
    mov bx, ax
    mov cx, [delay]
	portloop2:
    loop portloop1
    mov ax, bx
    out 42h, ax ; Send data
    mov cx, [delay]
	rloop2:
    loop rloop2
    call read
    pop cx
    loop totalloop2
    call CloseFileWav
    mov cx, [default_delay]
    mov [delay], cx
    ret
endp PlayGameOverSound


proc InitiateMusic
	mov ah, 3Dh
	mov cx, [default_delay]
    mov [delay], cx
    xor al, al
    lea dx, [filename_wav_music]
    int 21h
    mov [filehandle_wav], ax
    mov al, 90h
    out 43h, al
    in al, 61h
    or al, 3
    out 61h, al
    cli
    mov ax, 0
    ret
endp InitiateMusic


proc MusicDelay

cmp [slow_music], 1
je SlowMusic

mov cx, [default_delay]
mov [delay], cx
ret

SlowMusic:
mov cx, [slow_delay]
mov [delay], cx
inc [count_slow]

cmp [count_slow], 100
je StopSlow
ret

StopSlow:
mov [slow_music], 0
ret
endp MusicDelay


proc PausePlayer
cmp [player_paused], 1
je Pause
ret

Pause:
	mov ax, [paused_y_loc]
	mov [character_y], ax


	call DrawPauseText

inc [count_pause]

cmp [count_pause], 50
je StopPause
ret

StopPause:
mov [player_paused], 0
ret
endp PausePlayer

proc DrawPauseText
; Draws the coins header
	mov ah, 02h ; cursor position
	mov bh, 00h ; page number
	mov dh, 7h ; row
	mov dl, 2h ; column
	int 10h 

	mov ah, 09h ; write string to standart output
	lea dx, [TEXT_PAUSED]
	int 21h
	ret
	endp DrawPauseText


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

	call InitiateMusic
	

	WAIT_FOR_TIME_CHANGE:

	cmp [exit_game], 1h ; leave the game?
	je EXIT_GAME_PROCESS



	cmp [game_active], 00h ; checking if the game ended
	je SHOW_GAME_OVER


	mov [first_game], 0

	; system time
	mov ah, 2Ch
	int 21h ; dl= 1/100 seconds

	cmp dl, [time_last]
	je WAIT_FOR_TIME_CHANGE ; if the time hasn't change we want to check again



	
	; the time has changed and we can change the new frame
	push dx
	
	inc [score]

	call RealPlay

	call ClearScreen

	call MusicDelay
	

	call BackgroundMove


	call MovementDirectionUpdate


	call CharacterMove


	call ResetEnemies


	call StartSendEnemies


	call MoveEnemies
	
	call PausePlayer
	call userInterfaceDraw
	call DrawHeartBar


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

	call CheckIntersection

	pop dx


	mov [time_last], dl ; updating the time
	jmp WAIT_FOR_TIME_CHANGE


	
exit:

	mov ax, 4c00h
	int 21h
END start


