
video_mode macro

   mov     ax, 3
   int     10h 

endm  



drawing macro 
    
    mov     ah, 02h
    int     10h
    mov     al, '*'
    mov     bh,0b 
    mov     cx, 1
    mov     ah, 09h
    int     10h 
     
    
    
endm    


  

echo macro message
    
    
    mov dx,offset message
    mov ah, 09h     
    int 21h  


endm

input macro

  mov ah, 00h
  int 16h      
    
endm    

.model small
;-----------------
.stack 100

;-----------------
.data
    msg_exit         db  0Dh,0Ah,"for exit press any key....$" 
    msg_color         db  0Dh,0Ah,"for color press number 0-7.$"
    msg_help         db  0Dh,0Ah,"for help press f1..$" 
    msg_clear         db  0Dh,0Ah,"for clear page press space!.$"
          
;--------------------------------
.code
  







start:  

set_default_color: 

mov bl,1111b

video_mode 
        
 
    
	    
     
help:

    input
    
    
    cmp ax, 3c00h  
    
    je print_help  
    jmp set_cursor
    
    
print_help:     

    mov ax,@data
    mov ds,ax  
    echo msg_exit
    echo msg_color
    echo msg_help
    echo msg_clear
    
    input
    
    cmp al,20h    
    je clear_two 
    jmp start    


clear_two:
    
    call clearScreen

set_cursor:

    call setCursor
    

stop_draw: 

    call move



    
draw:

    call painting    


clear_one:     

    call clearScreen

    jmp draw    
      
         
exit:   

    mov ah,4ch
    int 21h
    ret     





setCursor PROC  
     

        
     mov dh, 12  
	 mov dl, 40
	 mov bh, 0
	 mov ah, 2
	 int 10h      
   
                 
     mov ch, 6
     mov cl, 7
     mov ah, 1
     int 10h
     
     ret
           
setCursor ENDP    


painting PROC
    
       
    input  
    
    cmp ah, 48h  
    je up

    cmp ah, 50h   
    je down

    cmp ah, 4Dh  
    je right

    cmp ah, 4Bh  
    je left 
    
    cmp al, 70h  
    je stop_draw
    
    cmp al, 20h     
    je clear_one 
    
    cmp ax, 3c00h  
    je print_help  
   
   
   
    cmp al, 30h  
    je set_white

    cmp al, 31h 
    je set_black

    cmp al, 32h  
    je set_magenta

    cmp al, 33h   
    je set_red 
    
    cmp al, 34h  
    je set_blue
    
    cmp al, 35h     
    je set_green

    
    cmp al, 36h    
    je  set_cyan
    
    
    cmp al, 37h     
    je  set_brown
     
     
    set_white:
    mov bl,1111b 
    jmp draw
    
    
    set_black:
    mov bl,0000b
    jmp draw
    
    set_magenta:
    mov bl,1110b
    jmp draw
    
    set_red:
    mov bl,0100b
    jmp draw  
    
    set_blue:
    mov bl,0001b
    jmp draw
    
    set_green:
    mov bl,0010b
    jmp draw
    
    set_cyan:
    mov bl,0011b
    jmp draw 
    
    set_brown:
    mov bl,0110b
    jmp draw 

    jmp exit

up:
    
    drawing                                   
    
    
    mov ah, 3  
    int 10h

    mov ah, 2  
    sub dh, 1
    int 10h

    jmp draw

down:  

    drawing color
    
    mov ah, 3 
    int 10h

    mov ah, 2  
    add dh, 1
    int 10h

    jmp draw

right: 
    
    drawing color
    
    mov ah, 3  
    int 10h

    mov ah, 2  
    add dl, 1
    int 10h

    jmp draw

left:
    
    drawing color 
    
    mov ah, 3  
    int 10h

    mov ah, 2  
    sub dl, 1
    int 10h

    jmp draw

       
    ret
painting ENDP  


move PROC 
    
    input

    cmp ah, 48h   
    je move_up

    cmp ah, 50h  
    je move_down

    cmp ah, 4Dh   
    je move_right

    cmp ah, 4Bh  
    je move_left 
    
    cmp al, 63h  
    je draw 
	
	cmp ax, 3c00h 
    je print_help 
    
    
    cmp ah, 30h  
    je set_white_move

    cmp ah, 31h 
    je set_black_move

    cmp ah, 32h  
    je set_magenta_move

    cmp ah, 33h   
    je set_red_move 
    
    cmp al, 34h  
    je set_blue_move
    
    cmp al, 35h     
    je set_green_move

    
    cmp al, 36h    
    je  set_cyan
    
    
    cmp al, 37h     
    je  set_brown
     
     
    set_white_move:
    mov bl,1111b 
    jmp draw
    
    
    set_black_move:
    mov bl,0000b
    jmp draw
    
    set_magenta_move:
    mov bl,1101b 
    jmp draw
    
    set_red_move:
    mov bl,0100b
    jmp draw  
    
    set_blue_move:
    mov bl,0001b
    jmp draw
    
    set_green_move:
    mov bl,0010b
    jmp draw
    
    set_cyan_move:
    mov bl,0011b
    jmp draw 
    
    set_brown_move:
    mov bl,0110b
    jmp draw  
	
    jmp exit

move_up:
    

    
    mov ah, 3  
    int 10h

    mov ah, 2  
    sub dh, 1
    int 10h

    jmp stop_draw

move_down:  

    
    mov ah, 3  
    int 10h

    mov ah, 2 
    add dh, 1
    int 10h

    jmp stop_draw

move_right: 

    
    mov ah, 3  
    int 10h

    mov ah, 2  
    add dl, 1
    int 10h

    jmp stop_draw

move_left:
    
    
    mov ah, 3  
    int 10h

    mov ah, 2 
    sub dl, 1
    int 10h

    jmp stop_draw
    

    
move ENDP



clearScreen PROC
    
 
    video_mode
    
    jmp set_cursor  
    
    ret
clearScreen ENDP
               
               
               
               