proc low_sound
	push cx
	mov al,182
	out 43h,al
	mov ax,4063

	out 42h, al
	mov al,ah
	out 42h,al
	in al,61h

	or al,00000011b
	out 61h, al

	push ax
	push cx
	mov ah,86h
	mov cx,02d
	int 15h
	pop cx
	pop ax

	in al,61h
	and al,11111100b
	out 61h,al
	pop cx
	ret
endp low_sound
proc high_sound
	push cx
	mov al,182
	out 43h,al
	mov ax,2711

	out 42h, al
	mov al,ah
	out 42h,al
	in al,61h

	or al,00000011b
	out 61h, al

	push ax
	push cx
	mov ah,86h
	mov cx,02d
	int 15h
	pop cx
	pop ax

	in al,61h
	and al,11111100b
	out 61h,al
	pop cx
	ret
endp high_sound