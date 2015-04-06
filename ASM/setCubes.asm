proc setCubeProc;[color]=color ; al=number
cmp al,1
je setCube1
cmp al,2
je setCube2
cmp al,3
je setCube3M
cmp al,4
je setCube4M
cmp al,5
je setCube5M
cmp al,6
je setCube6M
cmp al,7
je setCube7M
setCube1:
set_cube 47d,81d,91d,200d
jmp end_setcube
setCube3M:
jmp setCube3
setCube4M:
jmp setCube4
setCube5M:
jmp setCube5
setCube6M:
jmp setCube6
setCube7M:
jmp setCube7
setCube2:
set_cube 88,119,120,200d
jmp end_setcube

setCube3:
set_cube 130,161 ,120,200d 
jmp end_setcube
setCube4:
set_cube 171,202 ,120,200d 
jmp end_setcube
setCube5:
set_cube 212,243 ,120,200d 
jmp end_setcube
setCube6:
set_cube 252,283 ,120,200d 
jmp end_setcube
setCube7:
set_cube 293,320 ,120,200d 
jmp end_setcube
end_setcube:
ret
endp setCubeProc
