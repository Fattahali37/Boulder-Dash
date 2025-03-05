[org 0x100]

jmp start


;------------------------------------------------------------;
			;Memory Variables
;------------------------------------------------------------;
buffer: times 1600 db 0
buffer2: times 1600 db '0'
fname: db 'cave1.txt',0
lvl2: db 'cave2.txt',0
handle: dw 0
handle2: dw 0
title: db 'Boulder Dash - By Fattah$'
keys: db 'Arrow keys: Move$' 
esc: db 'Esc Key: Exit$'
score: db 'Score:$'
count: dw 0
wrong: db 'No file exists, exiting$'
intro: db 'Welcome to boulder game, Please enter file name(cave1.txt)$'
wr: db 'Filename: $'
levelprint:db 'level:$'
data: times 10 db '0'
oldsir: dd 0
opening: db 'opening file.....Press any key to continue$'
crash: db 'Game Over!!!!$'
win: db 'You Win$'
incc: db 'File is incomplete, exiting$'
r: db 0
l: db 0
u: db 0
d: db 0
nextlevel: db 'Want to play again? y/n$'
levelcount: dw 0
treasurecount:dw 0					;for help in you win msg
lives: db 'lives:$'
livescount: dw 3
;-------------------------------------------------------------;



;-------------------------------------------------------------;
			;wrong file opening
;-------------------------------------------------------------;
wfile:
	push 3
	push 0
	call curserset
	push wrong
	call printmsg
	jmp end
;-------------------------------------------------------------;



;-------------------------------------------------------------;
			;opening file
;-------------------------------------------------------------;
open:
	push 2
	push 0
	call curserset
	push opening
	call printmsg
	call delay

	mov ah,3dh
	mov dx,fname
	mov al,2
	int 21h
	jc wfile
	mov word[handle],ax
	ret
;-------------------------------------------------------------;




;-------------------------------------------------------------;
			;Clearscreen
;-------------------------------------------------------------;
clrscr: 
		push es
		push ax
		push di

		mov ax, 0xb800
		mov es, ax 
		mov di, 0

nextloc:
		mov word [es:di], 0x0720 
		add di, 2 
		cmp di, 4000 
		jne nextloc

		pop di
		pop ax
		pop es

		ret
;-------------------------------------------------------------;




;-------------------------------------------------------------;
			;Kbsir
;-------------------------------------------------------------;
kbsir:
	pusha
	mov ax,0xb800
	mov es,ax
	in al, 0x60
	cmp al,0x50						;scan code for down key

	jne skip1
	mov byte[cs:d],1
	mov byte[cs:r],0
	mov byte[cs:l],0
	mov byte[cs:u],0
	call move

skip1:
	cmp al,0x4D						;scan code for right key

	jne skip2
	mov byte[cs:d],0
	mov byte[cs:r],1
	mov byte[cs:l],0
	mov byte[cs:u],0
	call move

skip2:
	cmp al,0x48						;scan code for up key

	jne skip3
	mov byte[cs:d],0
	mov byte[cs:r],0
	mov byte[cs:l],0
	mov byte[cs:u],1
	call move

skip3:
	cmp al,0x4B					;scan code for left key

	jne skip4
	mov byte[cs:d],0
	mov byte[cs:r],0
	mov byte[cs:l],1
	mov byte[cs:u],0
	call move

skip4:
	mov al,0x20
	out 0x20,al
	popa
	iret
;-------------------------------------------------------------;




;-------------------------------------------------------------;
			;Reading from file
;-------------------------------------------------------------;
read:
	mov ah,3fh
	mov dx,buffer
	mov bx,[handle]
	mov cx,1600
	int 21h
	;cmp ax,1600
	;jne incc
	ret
;-------------------------------------------------------------;





;-------------------------------------------------------------;
			;incomplete code
;-------------------------------------------------------------;
incomplete:
	push 3
	push 0
	call curserset
	
	push incc
	call printmsg
	ret
;-------------------------------------------------------------;



;-------------------------------------------------------------;
			;Boulder crash
;-------------------------------------------------------------;
boulder:
clr:
	mov ax,0xb800
	mov es,ax
	mov di,0
again:
	mov word[es:di],0x0720
	add di,2
	cmp di,320
	jne again

	push 0
	push 35
	call curserset	
	

	push crash
	call printmsg

	push 23
	push 0
	call curserset
	
	call sound
	
	jmp end
;-------------------------------------------------------------;





;-------------------------------------------------------------;
			;Sound
;-------------------------------------------------------------;
sound:
	mov ah, 0Eh       ; BIOS teletype function
	mov al, 7         ; ASCII bell character
	int 10h           ; print the character
	ret
;-------------------------------------------------------------;





;-------------------------------------------------------------;
			;Treasure
;-------------------------------------------------------------;
treasure:
	inc word[treasurecount]
	jmp t2
t1:
	push 0
	push 35
	call curserset
	
	push win
	call printmsg
	
t2:
	mov ax,0xb800
	mov es,ax
	mov di,0

again1:
	mov word[es:di],0x0720
	add di,2
	cmp di,320
	jne again1



	push 23
	push 0
	call curserset
	call sound
	call level2
	cmp word[treasurecount],3
	je t1
	;jmp treasure
	;jmp eof
	
;-------------------------------------------------------------;




;-------------------------------------------------------------;
			;Print Score
;-------------------------------------------------------------;
printscore:
	push bp
	mov bp, sp
	push es
	push ax
	push bx
	push cx
	push dx
	push di


	mov ax, 0xb800
	mov es, ax			

	mov ax, [bp+4]		
	mov bx, 10			
	mov cx, 0			

nextdigitz:	
	mov dx, 0			

	div bx		 
	add dl, 0x30	
	push dx				

	inc cx				
	cmp ax, 0		
	jnz nextdigitz	
			
nextposz:			
	pop dx				
	mov di,3960
	mov dh, 0x07		
				
	mov [es:di], dx		
				
	add di, 2					
	loop nextposz				
	pop di	
	pop dx
	pop cx
	pop bx
	pop ax
	pop es
	pop bp
	ret 2
;-------------------------------------------------------------;


;-------------------------------------------------------------;
			;Print lives
;-------------------------------------------------------------;
printslives:
	push bp
	mov bp, sp
	push es
	push ax
	push bx
	push cx
	push dx
	push di


	mov ax, 0xb800
	mov es, ax			

	mov ax, [bp+4]		
	mov bx, 10			
	mov cx, 0			

nextdigitq:	
	mov dx, 0			

	div bx		 
	add dl, 0x30	
	push dx				

	inc cx				
	cmp ax, 0		
	jnz nextdigitq
			
nextposq:			
	pop dx				
	mov di,	300
	mov dh, 0x07		
				
	mov [es:di], dx		
				
	add di, 2					
	loop nextposq				
	pop di	
	pop dx
	pop cx
	pop bx
	pop ax
	pop es
	pop bp
	ret 2
;-------------------------------------------------------------;



;-------------------------------------------------------------;
			;Print level
;-------------------------------------------------------------;
printslevell:
	push bp
	mov bp, sp
	push es
	push ax
	push bx
	push cx
	push dx
	push di


	mov ax, 0xb800
	mov es, ax			

	mov ax, [bp+4]		
	mov bx, 10			
	mov cx, 0			

nextdigitl:	
	mov dx, 0			

	div bx		 
	add dl, 0x30	
	push dx				

	inc cx				
	cmp ax, 0		
	jnz nextdigitl	
			
nextposl:			
	pop dx				
	mov di,3900	
	mov dh, 0x07		
				
	mov [es:di], dx		
				
	add di, 2					
	loop nextposl				
	pop di	
	pop dx
	pop cx
	pop bx
	pop ax
	pop es
	pop bp
	ret 2
;-------------------------------------------------------------;




;-------------------------------------------------------------;
			;movement
;-------------------------------------------------------------;
move:
	mov ax,0xb800
	mov es,ax
	mov di,1602
	mov word [es:di],0x0702
	
	inc word[levelcount]
	push word[levelcount]
	call printslevell

	cmp byte[levelcount],3
	jne temp
	mov word[levelcount],0
	push 0
	push 0
	call curserset

temp1:
	push 23
	push 0
	call curserset
	push nextlevel
	call printmsg

	mov ah,00
	int 16h
yess:
	cmp ah,21
	jne eof2
	mov word[count],0
	call temp2

eof2:
	jmp eof
	ret


temp:
	jmp waitt
terminate:
	mov ax,0x4c00
	int 21h

waitt:
	push word[count]
	call printscore
	mov ah,0x00
	int 16h

	cmp al,27
	je terminate

	cmp ah,0x4D		;right
	je right
	
	cmp ah,0x48		;up
	je up1

	cmp ah,0x50		;down
	je down

	cmp ah,0x4B		;left
	je left1
	
	jmp waitt

up1:							;for short jump issue
	jmp up

left1:
	jmp left

down:
	mov word[es:di],0x0720
	add di,160
	cmp word[es:di],0x0509
	je boulder
	cmp word[es:di],0x0A7f
	je treasure
	cmp word[es:di],0x0304
	jne skipscore
	inc word[count]
skipscore:
	cmp word[es:di],0x1200
	je stopd
	jmp contd
stopd:
	sub di,160
	mov word[es:di],0x0702
	jmp waitt
contd:
	mov word[es:di],0x0702
	jmp waitt

right:
	mov word[es:di],0x0720
	add di,2
	cmp word[es:di],0x0509
	je boulder
	cmp word[es:di],0x0A7f
	je treasure
	cmp word[es:di],0x0304
	jne skipscore1
	inc word[count]
skipscore1:
	cmp word[es:di],0x1200
	je stopr
	jmp contr
stopr:
	sub di,2
	mov word[es:di],0x0702
	jmp waitt
contr:
	mov word[es:di],0x0702
	jmp waitt

left:
	mov word[es:di],0x0720
	sub di,2
	cmp word[es:di],0x0509
	je boulder
	cmp word[es:di],0x0A7f
	je treasure
	cmp word[es:di],0x0304
	jne skipscore2
	inc word[count]
skipscore2:
	cmp word[es:di],0x1200
	je stopl
	jmp contl
stopl:
	add di,2
	mov word[es:di],0x0702
	jmp waitt
contl:
	mov word[es:di],0x0702
	jmp waitt

up:
	mov word[es:di],0x0720
	sub di,160
	cmp word[es:di],0x0509
	je boulder
	cmp word[es:di],0x0A7f
	je treasure
	cmp word[es:di],0x0304
	jne skipscore3
	inc word[count]
skipscore3:
	cmp word[es:di],0x1200
	je stopu
	jmp contu
stopu:
	add di,160
	mov word[es:di],0x0702
	jmp waitt
contu:
	mov word[es:di],0x0702
	jmp waitt

;-------------------------------------------------------------;




;-------------------------------------------------------------;
			;Level2
;-------------------------------------------------------------;
level2:
	mov ah,3dh				;opening
	mov dx,lvl2
	mov al,2
	int 21h
	jc wfile
	mov word[handle2],ax

	mov ah,3fh				;reading
	mov dx,buffer2
	mov bx,[handle2]
	mov cx,1600
	int 21h
	
	call fprintt
	call border 
	call move
			
	enddd:
	pop es
	pop di
	pop ax
	pop bp
	ret 

fprintt:
	push bp
	mov bp,sp
	push ax
	push di
	push es

	mov ax,0xb800
	mov es,ax
	mov di,482
	mov si,0

p77:
	cmp si,1600
	je enddd
	cmp byte[buffer2+si],'D'
	je p33
	cmp byte[buffer2+si],'B'
	je p44
	cmp byte[buffer2+si],'T'
	je p55
	cmp byte[buffer2+si],'R'
	je p66
	cmp byte[buffer2+si],'x'
	je p11
	cmp byte[buffer2+si],'W'
	je p22


p11:
	mov ax,0x70B1
	mov word[es:di],ax
	add si,1
	add di,2
	jmp p77

p22:
	mov ax,0x1200
	mov word[es:di],ax
	add si,1
	add di,2
	jmp p77


p33:
	mov ax,0x0304
	mov word[es:di],ax
	add si,1
	add di,2
	jmp p77


p44:
	mov ax,0x0509
	mov word[es:di],ax
	add si,1
	add di,2
	jmp p77

p55:
	mov ax,0x0A7f
	mov word[es:di],ax
	add si,1
	add di,2
	jmp p77

p66:
	mov ax,0x0F02
	mov word[es:di],ax
	add si,1
	add di,2
	jmp p77


;-------------------------------------------------------------;
			;Unhooking
;-------------------------------------------------------------;
unhook:
	mov ax,0
	mov es,ax
	cli
	
	mov ax,[cs:oldsir]
	mov [es:9*4],ax
	
	mov ax,[cs:oldsir+2]
	mov [es:9*4+2],ax

	sti

	jmp end
;-------------------------------------------------------------;
			;Print File
;-------------------------------------------------------------;

endd:
	pop es
	pop di
	pop ax
	pop bp
	ret 

fprint:
	push bp
	mov bp,sp
	push ax
	push di
	push es

	mov ax,0xb800
	mov es,ax
	mov di,482
	mov si,0

p7:
	cmp si,1600
	je endd
	cmp byte[buffer+si],'D'
	je p3
	cmp byte[buffer+si],'B'
	je p4
	cmp byte[buffer+si],'T'
	je p5
	cmp byte[buffer+si],'R'
	je p6
	cmp byte[buffer+si],'x'
	je p1
	cmp byte[buffer+si],'W'
	je p2


p1:
	mov ax,0x70B1
	mov word[es:di],ax
	add si,1
	add di,2
	jmp p7

p2:
	mov ax,0x1200
	mov word[es:di],ax
	add si,1
	add di,2
	jmp p7


p3:
	mov ax,0x0304
	mov word[es:di],ax
	add si,1
	add di,2
	jmp p7


p4:
	mov ax,0x0509
	mov word[es:di],ax
	add si,1
	add di,2
	jmp p7

p5:
	mov ax,0x0A7f
	mov word[es:di],ax
	add si,1
	add di,2
	jmp p7

p6:
	mov ax,0x0F02
	mov word[es:di],ax
	add si,1
	add di,2
	jmp p7

;-------------------------------------------------------------;






;-------------------------------------------------------------;
			;Printing messages
;-------------------------------------------------------------;

printmsg:
	push bp
	mov bp,sp
	push ax
	push dx
	mov ah,9h
	mov dx,[bp+4]
	int 21h
	pop dx
	pop ax
	pop ax
	ret 2
;-------------------------------------------------------------;




;-------------------------------------------------------------;
			;Getting input
;-------------------------------------------------------------;
input_get:
	mov ah,0Ah
	mov dx,data
	mov cx,10
	int 21h
	mov ah,0
	mov al,[data+1]
	mov si,ax
	mov byte[data+2+si],0
	cmp byte [data+3],'0'
	jne change_name
ret
;-------------------------------------------------------------;





;-------------------------------------------------------------;
			;Changing name
;-------------------------------------------------------------;
change_name:
	mov si,2
	mov di,0
c1:
	mov al,[data+si]
	mov [fname+di],al
	add si,1
	add di,1
	cmp byte[data+si],0
	jne c1
ret
;-------------------------------------------------------------;




;-------------------------------------------------------------;
			;Setting cursor
;-------------------------------------------------------------;
curserset:
	push bp
	mov bp,sp
	push ax
	push bx
	push dx

	mov bh,0
	mov dh,[bp+6]
        mov dl,[bp+4]
        mov ah,02h
        int 10h

	pop dx
	pop bx
	pop ax
	pop bp
	ret 4
;482
;-------------------------------------------------------------;



;-------------------------------------------------------------;
			;Delay
;-------------------------------------------------------------;
delay:
	push dx
	push cx
	push ax
	push bx
	push di
	push si
	mov si , 0xffff
	mov di , 0xffff
	mov dx , 0xffff
	mov cx , 0xffff
	mov bx , 0xffff
	mov ax , 0xffff
L1:

	dec dx
	jnz L1
	L2:
	dec cx
	jnz L2
L3:
	dec ax
	jnz L3
L4:
	dec bx
	jnz L4
L5:
	dec si
	jnz L5
L6:
	dec di
	jnz L6
	pop si
	pop di
	pop bx
	pop ax
	pop cx
	pop dx

	ret
	
;-------------------------------------------------------------;
			;borders
;-------------------------------------------------------------;
border:		
	push bp
	mov bp, sp
	pusha
	mov ax, 0xb800
	mov es, ax
	mov di,320

	mov cx, 80
l1:		
	mov word [es:di], 0x1200
	add di, 2
	loop l1
	sub di,2
	mov cx, 22
l2:		
	mov word [es:di], 0x1200		
	add di, 160
	loop l2
	sub di, 160
	mov cx,80
l3:
	mov word [es:di], 0x1200		
	sub di, 2
	loop l3
	add di, 2
	mov cx,21
l4:
	mov word [es:di], 0x1200		
	sub di, 160
	loop l4
	
return:			
	popa
	pop bp
	ret
;-------------------------------------------------------------;


;-------------------------------------------------------------;
			;End of file
;-------------------------------------------------------------;
eof:
mov ah, 3eh
int 21h
ret
;-------------------------------------------------------------;




;-------------------------------------------------------------;
			;Start
;-------------------------------------------------------------;
start:
	mov ah,01h
	mov ch,20h
	mov cl,00h
	int 10h

	mov word[treasurecount],0
	mov word[count],0
	call clrscr
	push 0
	push 0
	call curserset
	push intro
	call printmsg

	push 1
	push 0
	call curserset
	push wr
	call printmsg


	call input_get
	call open
	call read
	call clrscr
	
	push 0					;rows
	push 25					;columns
	call curserset
	push title				;printing title
	call printmsg
temp2:
	push 1					;rows
	push 0					;columns
	call curserset
	push keys
	call printmsg				;for keys
	
	push 1
	push 27
	call curserset
	push esc
	call printmsg

	push 1
	push 60
	call curserset
	push lives
	call printmsg
	push word[livescount]
	call printslives
	
	call fprint
	call border

	push 24
	push 22
	call curserset
	push levelprint
	call printmsg


	push 24
	push 53
	call curserset
	push score
	call printmsg

	call move
	
l11:
	mov ah,0
	int 0x16
	
	cmp al,27
	jne l11
	jmp eof

end:
mov ax,0x4c00
int 21h
