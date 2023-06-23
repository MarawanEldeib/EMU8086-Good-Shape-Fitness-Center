INCLUDE EMU8086.INC

GETC MACRO P1 ; define a user macro
     MOV AH, 7
     INT 21H
     MOV [P1], AL
ENDM

ORG 100H

.CODE
START: 
       ;initialize data segment        
       MOV  AX, @data
       MOV  DS, AX 
       
       MOV TOTAL, 0
       
       call display_welcome_msg 
       call display_classes_menu

       LEA DX, ENROLL_NUMBER  ;display single line
       MOV AH,9
       INT 21H


       LEA DI, NUMBEROFCLASSES
       GETC DI
       MOV BL, [DI] 
       PUTC BL
       PRINTN ''
       SUB BL, 30H
       MOV [DI], BL
       
       LEA DI, CLASSES ; array of class index (1-5)
       MOV CX, BX
LOOPCLASSES:
       PRINTN ''

       LEA DX, CLASS_NUMBER       ;display single line
       MOV AH,9
       INT 21H


       GETC DI
       MOV BL, [DI] 
       PUTC BL
       PRINTN ''
       SUB BL, 30H
       MOV [DI], BL      
       INC DI
       LOOP LOOPCLASSES  
      
       call display_training_menu

       LEA DX, TRAINING_INDEX       ;display single line
       MOV AH,9
       INT 21H


       LEA DI,TRAININGINDEX 
       GETC DI
       MOV BL, [DI] 
       PUTC BL
       PRINTN ''
       SUB BL, 30H
       MOV [DI], BL
       
;;;ASK IF USER IS NEW OR NOT
       PRINTN ''

       LEA DX, YOU_CUSTOMER       ;display single line
       MOV AH,9
       INT 21H


       LEA DI, NEW_CUSTOMER
       GETC DI
       MOV BL, [DI] 
       PUTC BL
       call display_breakdown
;; Print Breakdown
       LEA DI, NUMBEROFCLASSES 
       MOV BL, [DI]
       MOV CX, BX
       LEA DI, CLASSES
       MOV BL, [DI]
LOOP_PRINT_CLASSES:
       CMP BL, 1           
       je CALL PRINT_PILATES 
       CMP BL, 2           
       je CALL PRINT_KICKBOXING
       CMP BL, 3           
       je CALL PRINT_ZUMBA 
       CMP BL, 4           
       je CALL PRINT_AEROBICS
       CMP BL, 5           
       je CALL PRINT_YOGA
RET_HERE:
       INC DI
       MOV BL, [DI]
       LOOP LOOP_PRINT_CLASSES
PRINT_TRAINING:
       LEA DI, TRAININGINDEX
       MOV BL, [DI]
       CMP BL, 1
       JE CALL PRINT_HOURLY
       CMP BL, 2
       JE CALL PRINT_DAILY
       CMP BL, 3
       JE CALL PRINT_WEEKLY
       CMP BL, 4
       JE CALL PRINT_MONTHLY
RET_HERE1:
       
;;;; PRINT DISCOUNTS
       LEA DI,NUMBEROFCLASSES
       MOV BL, [DI] 
       CMP BL, 2
       JE  CALL DISCOUNT_10RM
       CMP BL, 3
       JE  CALL DISCOUNT_20RM
       CMP BL, 3
       JG  CALL DISCOUNT_40RM
RET_HERE2:
       LEA DI, NEW_CUSTOMER 
       MOV BL, [DI]
       CMP BL, 'y'
       JE CALL DISCOUNT_NEW_USER 
       CMP BL, 'Y'
       JE CALL DISCOUNT_NEW_USER
RET_HERE3: 
       ;PRINT TOTAL
       call display_total

       ;PRINTN ''
       mov ax, TOTAL  
       print_total
       call display_thankyou
      

EXIT:
       RET

DISCOUNT_10RM:

       LEA DX, DISCOUNT_10RM_MSG       ;display single line
       MOV AH,9
       INT 21H

       ;SUB DX, 10 
       SUB TOTAL, 10
       JMP RET_HERE2
DISCOUNT_20RM: 
       LEA DX, DISCOUNT_20RM_MSG       ;display single line
       MOV AH,9
       INT 21H

       ;SUB DX, 20 
       SUB TOTAL, 20
       JMP RET_HERE2 
DISCOUNT_40RM:
       LEA DX, DISCOUNT_40RM_MSG       ;display single line
       MOV AH,9
       INT 21H

       SUB TOTAL, 40
       JMP RET_HERE2
DISCOUNT_NEW_USER:
       LEA DX, DISCOUNT_NEW_USER_MSG       ;display single line
       MOV AH,9
       INT 21H

       SUB TOTAL, 30
       JMP RET_HERE3

PRINT_PILATES: 
       LEA DX, PRINT_PILATES_MSG       ;display single line
       MOV AH,9
       INT 21H

      ADD TOTAL, 160 
      JMP RET_HERE
PRINT_KICKBOXING: 
       LEA DX, PRINT_KICKBOXING_MSG       ;display single line
       MOV AH,9
       INT 21H
      ADD TOTAL, 200
      JMP RET_HERE
PRINT_ZUMBA:
      LEA DX, PRINT_ZUMBA_MSG       ;display single line
       MOV AH,9
       INT 21H
      ADD TOTAL, 150 
      JMP RET_HERE 
PRINT_AEROBICS: 
       LEA DX, PRINT_AEROBICS_MSG       ;display single line
       MOV AH,9
       INT 21H
      ADD TOTAL, 120
      JMP RET_HERE 
PRINT_YOGA:
       LEA DX, PRINT_YOGA_MSG       ;display single line
       MOV AH,9
       INT 21H
      ADD TOTAL, 100
      JMP RET_HERE


PRINT_HOURLY: 
       LEA DX, PRINT_HOURLY_MSG       ;display single line
       MOV AH,9
       INT 21H
      ADD TOTAL, 50
      JMP RET_HERE1
PRINT_DAILY: 
       LEA DX, PRINT_DAILY_MSG       ;display single line
       MOV AH,9
       INT 21H
      ADD TOTAL, 200
      JMP RET_HERE1
PRINT_WEEKLY:
      LEA DX, PRINT_WEEKLY_MSG       ;display single line
       MOV AH,9
       INT 21H
      ADD TOTAL, 900 
      JMP RET_HERE1 
PRINT_MONTHLY: 
       LEA DX, PRINT_MONTHLY_MSG       ;display single line
       MOV AH,9
       INT 21H
      ADD TOTAL, 3000
      JMP RET_HERE1 

.DATA
NUMBEROFCLASSES DB 1 DUP (?)
CLASSES DB 9 DUP (?)
TRAININGINDEX DB 1 (?) 
NEW_CUSTOMER DB 1 (?); Y YES, N NO
TOTAL DW 2 (?)   
   
   
WELCOME_MSG   DB 10, 13,  ' ======================================================='         
       DB 10, 13,  '           Welcome to Good Shape Fitness Center!'                 
       DB 10, 13,  ' ======================================================='         
       DB 10, 13,  ''                                                                 
       DB 10, 13,  '  ______________________________________________________________' 
       DB 10, 13,  ' |                                                              |'
       DB 10, 13,  ' |          *Enroll more and save more* promotion               |'
       DB 10, 13,  ' | Enroll in 2 classes and receive a discount of RM10.          |'
       DB 10, 13,  ' | Enroll in 3 classes and receive a discount of RM20.          |'
       DB 10, 13,  ' | Enroll in 4 classes or more and receive a discount of RM40.  |'
       DB 10, 13,  ' |______________________________________________________________|'
       DB 10,13,'$' 

CLASSES_MENU        DB 10, 13,  ''
       DB 10, 13,  ' Please select the fitness classes you want to enroll in:'
       DB 10, 13,  ' 1-Pilates        RM160'
       DB 10, 13,  ' 2-Kickboxing     RM200'
       DB 10, 13,  ' 3-Zumba          RM150'
       DB 10, 13,  ' 4-Aerobics       RM120'
       DB 10, 13,  ' 5-Yoga           RM100'
       DB 10, 13, '$'


TRAINING_MENU  DB 10, 13,  ''
       DB 10, 13,  ' Please select the personal training duration:'
       DB 10, 13,  ' 1-Hourly    RM50'
       DB 10, 13,  ' 2-Daily     RM200'
       DB 10, 13,  ' 3-Weekly    RM900'
       DB 10, 13,  ' 4-Monthly   RM3000' 
       DB 10, 13,  '$'

BREAKDONW_MSG  DB 10, 13,  ''
       DB 10, 13,  ''                           
       DB 10, 13,  ' -------------------------------------------------------'
       DB 10, 13,  '                    Breakdown of fees:'
       DB 10, 13,  ' ------------------------------------------------------- $'

TOTAL_MSG        DB 10, 13,  ' -------------------------------------------------------'  
       DB 10, 13,  ' Total: RM $'


THANKYOU_MSG  DB 10, 13,  ''                             
       DB 10, 13,  ' -------------------------------------------------------'
       DB 10, 13,  '   Thank you for choosing Good Shape Fitness Center!'
       DB 10, 13,  ' -------------------------------------------------------'
       DB 10, 13, '$'

ENROLL_NUMBER  DB 10,13,10,13, ' Enter the number of classes you want to enroll in: $'
CLASS_NUMBER  DB 10,13,10,13, ' Enter Class Number: $'
TRAINING_INDEX DB 10,13,10,13, ' Enter the index of the personal training duration: $'
YOU_CUSTOMER DB 10,13,10,13, ' Are you a new customer?(y/n) $'
 
 
 

DISCOUNT_10RM_MSG DB 10,13,10,13, ' Promotion Discount     RM10 $'

DISCOUNT_20RM_MSG DB 10,13,10,13, ' Promotion Discount     RM20 $'

DISCOUNT_40RM_MSG DB 10,13,10,13, ' Promotion Discount     RM40 $'

DISCOUNT_NEW_USER_MSG DB 10,13,10,13, ' New Customer Discount  RM30 $' 



PRINT_PILATES_MSG DB 10,13,10,13, ' Pilates                RM160 $'

PRINT_KICKBOXING_MSG DB 10,13,10,13, ' Kickboxing             RM200 $'

PRINT_ZUMBA_MSG DB 10,13,10,13, ' Zumba                  RM150 $'

PRINT_AEROBICS_MSG  DB 10,13,10,13, ' Aerobics               RM120 $'

PRINT_YOGA_MSG DB 10,13,10,13, ' Yoga                   RM100 $'



PRINT_HOURLY_MSG  DB 10,13,10,13, ' Hourly Basis           RM50 $' 

PRINT_DAILY_MSG  DB 10,13,10,13, ' Daily Basis            RM200 $' 

PRINT_WEEKLY_MSG DB 10,13,10,13, ' Weekly Basis           RM900 $'

PRINT_MONTHLY_MSG DB 10,13,10,13, ' Monthly Basis          RM3000 $'





macro print_total
    local loop1, loop2

    ; save registers
    pusha

    ; initialize counter
    mov cx, 0
    ; store 10 in bx for division
    mov bx, 10

convert_loop:
    ; divide ax by 10
    xor dx, dx
    div bx
    ; push remainder (in dx) onto stack
    push dx
    ; increase counter
    inc cx
    ; repeat while quotient (in ax) is not zero
    test ax, ax
    jnz convert_loop
print_loop:
    ; pop least significant digit from stack
    pop dx
    ; convert it to ascii
    add dl, '0'
    ; print it
    mov ah, 0x02
    int 0x21
    ; decrement counter
    loop print_loop

    ; restore registers
    popa
endm
; Macro definition ends

display_welcome_msg proc
  mov  dx, offset WELCOME_MSG
  mov  ah, 9
  int  21h
  ret
display_welcome_msg endp


display_classes_menu proc
  mov  dx, offset CLASSES_MENU
  mov  ah, 9
  int  21h
  ret
display_classes_menu endp


display_training_menu proc
  mov  dx, offset TRAINING_MENU
  mov  ah, 9
  int  21h
  ret
display_training_menu endp


display_breakdown proc
  mov  dx, offset BREAKDONW_MSG
  mov  ah, 9
  int  21h
  ret
display_breakdown endp


display_total proc
  mov  dx, offset TOTAL_MSG
  mov  ah, 9
  int  21h
  ret
display_total endp


display_thankyou proc
  mov  dx, offset THANKYOU_MSG
  mov  ah, 9
  int  21h
  ret
display_thankyou endp