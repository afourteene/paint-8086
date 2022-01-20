
; You may customize this and other start-up templates; 
; for help about emu8086 you can use f1.
get_input macro

  mov ah, 00h
  int 16h      ;get keystroke from keyboard (no echo) 
    
endm    

set_video_mode macro

   mov     ax, 3
   int     10h 

endm  



drawing macro pen_color
    
    mov     ah, 02h
    int     10h
    mov     al, '.'
    mov     bh, 0
    mov     bl,pen_color
    mov     cx, 1
    mov     ah, 09h
    int     10h   
    
    
endm    


  

print_msg macro message
    
    lea dx, message
    mov ah, 09h     ; output string at ds:dx
    int 21h  


endm


org 100h


jmp start       ; jump over data declaration

msg1         db  0Dh,0Ah,"if you want exit program press any key !$" 
msg2         db  0Dh,0Ah,"if you want change font color press number 0-7.$"
msg3         db  0Dh,0Ah,"if you need help press f1..$" 
msg4         db  0Dh,0Ah, "if you want clear screen press space bar.$"

color     db  1111b  ; Defaul White 



start:

set_video_mode 
        

	    
     
help:

    get_input
    
    
    cmp ax, 3c00h  ;f2 key space
    
    je print_help  
    jmp set_cursor
    
    
print_help:
          
    print_msg msg1
    print_msg msg2
    print_msg msg3
    print_msg msg4
    
    get_input
    
    cmp al,20h    
    je clear_two 
    jmp start    


clear_two:
    
    call clearScreen

set_cursor:

    call setCursor
    

stop_draw: 

    call nonPainting



    
draw:

    call painting    


clear_one:     

    call clearScreen

    jmp draw    
      
         
exit:   

    mov     ah, 0 
    int     16h      ; wait for any key....

    ret     





setCursor PROC  
     

        
     mov dh, 12  ; set cursor  position
	 mov dl, 40
	 mov bh, 0
	 mov ah, 2
	 int 10h      
   
                 ; show standard blinking text cursor: 
     mov ch, 6
     mov cl, 7
     mov ah, 1
     int 10h
     
     ret
           
setCursor ENDP    


painting PROC
    
       
    mov ah, 00h
    int 16h      ;get keystroke from keyboard (no echo)

    cmp ah, 48h  ;Up Arrow key 
    je up

    cmp ah, 50h  ;Down Arrow key 
    je down

    cmp ah, 4Dh  ;Right Arrow key 
    je right

    cmp ah, 4Bh  ;Left Arrow key 
    je left 
    
    cmp al, 70h  ;p key
    je stop_draw
    
    cmp al, 20h  ;Clear Screen Space Key   
    je clear_one 
    
    cmp ax, 3c00h  ;f2 key space
    je print_help  
   
   
   
    cmp ah, 30h  ;0 key 
    je set_white

    cmp ah, 31h  ;1 key 
    je set_black

    cmp ah, 32h  ;2 key 
    je set_magenta

    cmp ah, 33h  ;3 key 
    je set_red 
    
    cmp al, 34h  ;4 key
    je set_blue
    
    cmp al, 35h  ;5 Key   
    je set_green

    
    cmp al, 36h  ;6 Key   
    je  set_cyan
    
    
    cmp al, 37h  ;7 Key   
    je  set_brown
     
     
    set_white:
    mov color,1111b 
    jmp draw
    
    
    set_black:
    mov color,0000b
    jmp draw
    
    set_magenta:
    mov color,1110b
    jmp draw
    
    set_red:
    mov color,0100b
    jmp draw  
    
    set_blue:
    mov color,0001b
    jmp draw
    
    set_green:
    mov color,0010b
    jmp draw
    
    set_cyan:
    mov color,0011b
    jmp draw 
    
    set_brown:
    mov color,0110b
    jmp draw 

    jmp exit

up:
    
    drawing color                                  
    
    
    mov ah, 3  ;Get current position
    int 10h

    mov ah, 2  ;Move cursor Up
    sub dh, 1
    int 10h

    jmp draw

down:  

    drawing color
    
    mov ah, 3  ;Get current position
    int 10h

    mov ah, 2  ;Move cursor Down
    add dh, 1
    int 10h

    jmp draw

right: 
    
    drawing color
    
    mov ah, 3  ;Get current position
    int 10h

    mov ah, 2  ;Move cursor Right
    add dl, 1
    int 10h

    jmp draw

left:
    
    drawing color 
    
    mov ah, 3  ;Get current position
    int 10h

    mov ah, 2  ;Move cursor Left
    sub dl, 1
    int 10h

    jmp draw

       
    ret
painting ENDP  


nonPainting PROC 
    
    mov ah, 00h
    int 16h      ;get keystroke from keyboard (no echo)

    cmp ah, 48h  ;Up Arrow key 
    je non_up

    cmp ah, 50h  ;Down Arrow key 
    je non_down

    cmp ah, 4Dh  ;Right Arrow key 
    je non_right

    cmp ah, 4Bh  ;Left Arrow key 
    je non_left 
    
    cmp al, 63h  ;c key
    je draw 
	
	cmp ax, 3c00h  ;f2 key space
    je print_help  
	
    jmp exit

non_up:
    

    
    mov ah, 3  ;Get current position
    int 10h

    mov ah, 2  ;Move cursor Up
    sub dh, 1
    int 10h

    jmp stop_draw

non_down:  

    
    mov ah, 3  ;Get current position
    int 10h

    mov ah, 2  ;Move cursor Down
    add dh, 1
    int 10h

    jmp stop_draw

non_right: 

    
    mov ah, 3  ;Get current position
    int 10h

    mov ah, 2  ;Move cursor Right
    add dl, 1
    int 10h

    jmp stop_draw

non_left:
    
    
    mov ah, 3  ;Get current position
    int 10h

    mov ah, 2  ;Move cursor Left
    sub dl, 1
    int 10h

    jmp stop_draw
    

    
nonPainting ENDP



clearScreen PROC
    
    
    ;clear screen
    ;from 0 to 184fh of the screen
    ;mov ax,00
    ;mov cx,0000h
    ;mov dx,184fh
    ;int 10h
    
    set_video_mode
    
    jmp set_cursor  
    
    ret
clearScreen ENDP


