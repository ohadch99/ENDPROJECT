IDEAL
MODEL medium
STACK 100h
DATASEG
; --------------------------
; PICTURE VARS
StartPictX   	dw 0
StartPictY   	dw 0
WidthPict    	dw 320 ;(if 320*200 than not necessary. In ;PCX must be even)
HeightPict   	dw 200 
LengthPict   	dw 0
Handle       	dw 0 ;(a number to recognize the file)
FileLength	dw ? 
FileName     	db 'G.pcx', 0
Buffer       	db 64000 dup(?) 
Point_Fname  	dd FileName
Point_Buffer 		dd Buffer


pauseVar db 0
bpm db 60
hundredthSec db 0
newTime_sec_and_hund dw 0
newTime_hour_and_min dw 0
numOfBits db 7
CountNumOfBits db 0
key_pressed db 0
last_pressed db 0
pauseProcVar db 0
colorVar db '0'
restartWorking db 0
; --------------------------
CODESEG
include "graphicM.asm"
macro set_cube_metre number,color
push ax
mov [byte ptr colorVar],color
mov al,number
call setCubeProc;al=color ; ah=number
pop ax
endm
macro pic
	call PrintPictureProc
endm
start:
	mov ax, @data
	mov ds, ax
	mov ax,13h
	int 10h
; --------------------------
; Your code here
pic 
mov ah,0Ch
mov al,01h
int 21h
call PlayAndStopPROC
call h
call calculateHundredthSec
call PlayAndStopPROC
call working

; --------------------------

exit:
	mov  ax,12h
	int 10h
	mov ax, 4c00h
	int 21h
include "Sound.asm"
include "printPic.asm"
include "setCubes.asm"
h:
	mov [StartPictX],0
	mov [StartPictY],0
	mov[WidthPict],320
	mov [HeightPict],200

	mov [FileName],'H'
	pic
	mov ah,0Ch
	mov al,01h
	int 21h
	mov [FileName],'B'
	pic
	call setTempoCubs
	call setTemp
	call setMetre
	ret
PlayAndStopPROC:
	mov [StartPictX],0
	mov [StartPictY],92
	mov[WidthPict],320
	mov [HeightPict],109
	cmp [pauseVar],0 ;The aim of the proc is to Change between Pause and Play
	je play
	mov [FileName],'P'
	pic
	call setTempoCubs
	cmp [pauseProcVar],1
	je not_already_paused
	call pauseProc
	not_already_paused:
	mov [pauseProcVar],0
	mov [pauseVar],0
	jmp endPlayAndStopPROC
	play:
	inc [pauseVar]
	mov [FileName],'O'
	pic
	endPlayAndStopPROC:
	call setTempoCubs
	ret
pauseProc:
	
	pauseStart:
	mov [restartWorking],1
	call CheckMouseProc
	mov [pauseProcVar],1
	cmp [pauseVar],0
	je ExitpauseProc
	jmp pauseStart
	ExitpauseProc:
	ret
setTempoCubs:
	push cx
	push ax
	xor cx,cx
	mov cl,7
	mov al,1; The counting of the cubes starts with 1
	setTempoCubsLoop:
	cmp al,[numOfBits]
	ja gray
	set_cube_metre al,5
	jmp endLoop
	gray:
	set_cube_metre al,7
	endLoop:
	inc al
	loop setTempoCubsLoop
	pop ax
	pop cx
	ret
setTemp:
	mov [StartPictX],0
	mov [StartPictY],0
	mov[WidthPict],320
	mov [HeightPict],38
	cmp [numOfBits],2
	je Bits2
	cmp [numOfBits],3
	je Bits3
	cmp [numOfBits],4
	je Bits4
	cmp [numOfBits],5
	je Bits5
	cmp [numOfBits],6
	je Bits6
	mov [FileName],'7'
	jmp endSetTemp
	Bits2:
	mov [FileName],'2'
	jmp endSetTemp
	Bits3:
	mov [FileName],'3'
	jmp endSetTemp
	Bits4:
	mov [FileName],'4'
	jmp endSetTemp
	Bits5:
	mov [FileName],'5'
	jmp endSetTemp
	Bits6:
	mov [FileName],'6'
	jmp endSetTemp
	endSetTemp:
	pic
	ret
setMetre:
	mov [StartPictX],0
	mov [StartPictY],55
	mov[WidthPict],320
	mov [HeightPict],42
	cmp [bpm],60d
	je bpm60
	cmp [bpm],70d
	je bpm70
	cmp [bpm],80d
	je bpm80
	cmp [bpm],90d
	je bpm90
	cmp [bpm],100d
	je bpm100
	cmp [bpm],110d
	je bpm110
	
	mov [FileName],'U'
	jmp endSetMetre
	bpm60:
	mov [FileName],'Q'
	jmp endSetMetre
	bpm70:
	mov [FileName],'W'
	jmp endSetMetre
	bpm80:
	mov [FileName],'E'
	jmp endSetMetre
	bpm90:
	mov [FileName],'R'
	jmp endSetMetre
	bpm100:
	mov [FileName],'T'
	jmp endSetMetre
	bpm110:
	mov [FileName],'Y'
	jmp endSetMetre
	endSetMetre:
	pic
	ret
setScreen:
	call setMetre
	call setTemp
	call setTempoCubs
	ret
calculateHundredthSec:
	push ax
	push dx
	push bx
	xor bx,bx
	mov bl,[bpm]
	xor dx,dx
	mov ax,60000d
	div bx
	mov bx,100d
	xor dx,dx
	div bx
	mov [hundredthSec],al
	pop bx
	pop dx
	pop ax
	ret
waitProc:
	push cx
	mov cl,[hundredthSec]
	timingLoop:
	push cx
	mov ah,86h
	mov cx,1d
	int 15h
	call CheckMouseProc

	pop cx
	loop timingLoop
	pop cx
	ret
working:
	call setScreen
	start_working:
	mov [restartWorking],0
	mov [CountNumOfBits],0
	call calculateHundredthSec
	set_cube_metre 1,0bh
	set_cube_metre [numOfBits],5
	call high_sound
	xor cx,cx
	add cl,[numOfBits]
	dec cx
	call waitProc
	
	play_others:
	cmp [restartWorking],1
	je working
	mov al,[numOfBits]
	sub al,cl
	inc al
	set_cube_metre al,0bh
	dec al
	set_cube_metre al,05h
	call low_sound
	call waitProc
	loop play_others
	mov al,[numOfBits]
	set_cube_metre al,05h
	jmp start_working
	ret
CheckMouseProc:
	push ax
	in ax,060h
	cmp al,[last_pressed]
	jne new_key
	cmp ah,[key_pressed]
	je EndCheckMouseProc_midle
	new_key:
	mov [last_pressed],al
	mov [key_pressed],ah
	cmp al,0B9h ; space
	je p
	cmp al,90h;q key
	je q
	cmp al,9Eh;a kay
	je a
	cmp al,91h;w key
	je w
	cmp al,9Fh;s key
	je s
	cmp al,0A3h;h key
	je help
	cmp al,1
	je Escape
	EndCheckMouseProc_midle:
	jmp EndCheckMouseProc
	p:
	call PlayAndStopPROC
	jmp EndCheckMouseProc
	q:
	cmp [bpm],120
	jae nq
	add [bpm],10d
	call calculateHundredthSec
	call setScreen
	mov [restartWorking],1
	nq:
	jmp EndCheckMouseProc
	a:
	cmp [bpm],60
	jbe na
	sub [bpm],10d
	call calculateHundredthSec
	call setScreen
	mov [restartWorking],1
	na:
	jmp EndCheckMouseProc
	w:
	cmp [numOfBits],7
	jae nw
	inc [numOfBits]
	call setScreen
	mov [restartWorking],1
	nw:
	jmp EndCheckMouseProc
	s:
	cmp [numOfBits],2
	jbe ns
	dec [numOfBits]
	call setScreen
	mov [restartWorking],1
	ns:
	jmp EndCheckMouseProc
	help:
	call h
	jmp EndCheckMouseProc
	Escape:
	call exit
	EndCheckMouseProc:
	pop ax
	ret
	 END start
	
