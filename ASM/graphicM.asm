macro set_pixel Px, Py
	push ax
	push bx
	push cx
	push dx
	mov cx,Px
	mov dx,Py
	mov bh,0h
	mov al,[byte ptr colorVar]
	mov ah,0Ch
	int 10h
	pop dx
	pop cx
	pop bx
	pop ax
endm
macro set_cube x1,x2,y1,y2
	local paint_x, paint_y
	push ax
	push cx
	push bx
	push dx
	xor ax,ax
	mov ax,x2
	sub ax,x1
	mov cx,ax ;put how much x returns
	mov ax,y2
	sub ax,y1
	mov dx,ax
	xor ax,ax
	mov ax,x1
	mov bx,y1
	paint_x:;ax=x bx=y dx= save y's
	push cx
	mov cx,dx
	mov bx,y1
	paint_y:
	set_pixel ax, bx
	inc bx
	loop paint_y
	inc ax
	pop cx
	loop paint_x
	pop dx
	pop bx
	pop cx
	pop ax
endm