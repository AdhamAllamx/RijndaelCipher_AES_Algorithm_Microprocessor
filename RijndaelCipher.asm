

org 100h


;------------------------- subBytes MACRO -----------------------
subBytes MACRO ARR
LOCAL new_cell
MOV AX, 0
MOV SI, 0
new_cell:
MOV AX , 0
MOV AL, ARR[SI]
MOV DI, AX
MOV BL, S_BYTES[DI]
MOV ARR[SI], BL
INC SI
CMP SI,16
JNZ new_cell
ENDM




;------------------------- shiftRows MACRO -----------------------
shiftRows MACRO ARR
LOCAL ROW1,ROW2,ROW3
MOV AX, 0
MOV AL , ARR[4]
ROW1:
MOV AH, ARR[5]
MOV ARR[4] , AH
MOV AH, ARR[6]
MOV ARR[5] , AH
MOV AH, ARR[7]
MOV ARR[6] , AH
MOV ARR[7] , AL
MOV AX, 0
MOV AL , ARR[8]
MOV DL , ARR[9]
ROW2:
MOV AH, ARR[10]
MOV ARR[8] , AH
MOV AH, ARR[11]
MOV ARR[9] , AH
MOV ARR[10] , AL
MOV ARR[11] , DL
MOV AX, 0

ROW3:
MOV AL , ARR[12]
MOV DL , ARR[13]
MOV DH , ARR[14]
MOV AH, ARR[15]
MOV ARR[12] , AH
MOV ARR[13] , AL
MOV ARR[14] , DL
MOV ARR[15] , DH
MOV AX, 0
MOV DX, 0
ENDM



;------------------------- MixColumns MACRO -----------------------

mixColumns MACRO A
LOCAL FIRST1, FIRST2, FIRST3, SECOND1, SECOND2, SECOND3, SECOND4, THIRD1, THIRD2, THIRD3, THIRD4, FOURTH1, FOURTH2, FOURTH3, FOURTH4

MOV AX, 0
MOV BX, 0
MOV CX, 0
MOV DX, 0
MOV SI, 0

FIRST1:
MOV AL, A[SI]
SHL AL, 01
MOV BL, A[SI]
CMP BL, 0
JS FIRST2
XOR AL, 1BH

FIRST2:
MOV BL, A[SI+4]
SHL BL, 01
MOV DL, A[SI+4]
CMP DL, 0
JS FIRST3
XOR BL, 1BH

FIRST3:
XOR BL, DL
XOR AL, BL
XOR AL, A[SI+8]
XOR AL, A[SI+12]
MOV CL, AL

SECOND1:
MOV AL, A[SI]
XOR AL, A[SI+12]
MOV DL, AL

SECOND2:
MOV AL, A[SI+4]
SHL AL, 01
MOV BL, A[SI+4]
CMP BL, 0
JS SECOND3
XOR AL, 1BH

SECOND3:
MOV BL, A[SI+8]
SHL BL, 01
MOV BH, A[SI+8]
CMP BH, 0
JS SECOND4
XOR BL, 1BH

SECOND4:
XOR BL, BH
XOR AL, BL
XOR AL, DL
MOV CH, AL

THIRD1:
MOV AL, A[SI]
XOR AL, A[SI+4]
MOV DL, AL

THIRD2:
MOV BL, A[SI+8]
SHL BL,01
MOV BH, A[SI+8]
CMP BH, 0
JS THIRD3
XOR BL, 1BH

THIRD3:
XOR DL, BL
MOV BL, A[SI+12]
SHL BL, 01
MOV BH, A[SI+12]
CMP BH, 0
JS THIRD4
XOR BL, 1BH

THIRD4:
XOR BL, BH
XOR DL, BL

FOURTH1:
MOV AL, A[SI+4]
XOR AL, A[SI+8]
MOV DH, AL

FOURTH2:
MOV AL, A[SI]
SHL AL, 01
MOV AH, A[SI]
CMP AH, 0
JS FOURTH3
XOR AL, 1BH

FOURTH3:
XOR AL, AH
XOR DH, AL
MOV BL, A[SI+12]
SHL BL, 01
MOV BH, A[SI+12]
CMP BH, 0
JS FOURTH4
XOR BL, 1BH

FOURTH4:
XOR DH,BL


MOV A[SI], CL
MOV A[SI+4], CH
MOV A[SI+8], DL
MOV A[SI+12], DH

INC SI
CMP SI, 4
JNZ FIRST1


ENDM



;------------------------- addRoundKey MACRO -----------------------

addRoundKey MACRO ARR
LOCAL Round_key
mov AX,0
MOV SI,0
Round_key:
mov AL,ARR[SI]
XOR AL,R_key[SI]
MOV ARR[SI], AL
inc SI
cmp SI,16
jnz Round_key
ENDM




;------------------------- keyScheduler MACRO -----------------------


keyScheduler MACRO
LOCAL End
;1
MOV AL , R_key[7]
MOV AH , R_key[11]
MOV DL , R_key[15]
MOV DH , R_key[3]
;SUBBYTES
MOV BX ,0
MOV BL ,AL
MOV DI,BX
MOV AL, S_BYTES[DI]

MOV BX ,0
MOV BL ,AH
MOV DI,BX
MOV AH, S_BYTES[DI]

MOV BX ,0
MOV BL ,DL
MOV DI,BX
MOV DL, S_BYTES[DI]

MOV BX ,0
MOV BL ,DH
MOV DI,BX
MOV DH, S_BYTES[DI]


XOR AL, R_key[0]
XOR AH, R_key[4]
XOR DL, R_key[8]
XOR DH, R_key[12]

MOV BX, 0
MOV BL , Rcon_access
INC BL
MOV Rcon_access ,BL
DEC BL
MOV SI, BX

XOR AL, Rcon[SI]
ADD SI,10
XOR AH, Rcon[SI]
ADD SI,10
XOR DL, Rcon[SI]
ADD SI,10
XOR DH, Rcon[SI]

MOV  New_key[0]  ,AL
MOV  New_key[4]  ,AH
MOV  New_key[8]  ,DL
MOV  New_key[12] ,DH

;2

XOR AL, R_key[1]
XOR AH, R_key[5]
XOR DL, R_key[9]
XOR DH, R_key[13]

MOV  New_key[1]  ,AL
MOV  New_key[5]  ,AH
MOV  New_key[9]  ,DL
MOV  New_key[13] ,DH

;3

XOR AL, R_key[2]
XOR AH, R_key[6]
XOR DL, R_key[10]
XOR DH, R_key[14]

MOV  New_key[2]  ,AL
MOV  New_key[6]  ,AH
MOV  New_key[10] ,DL
MOV  New_key[14] ,DH

;4

XOR AL, R_key[3]
XOR AH, R_key[7]
XOR DL, R_key[11]
XOR DH, R_key[15]

MOV  New_key[3]  ,AL
MOV  New_key[7]  ,AH
MOV  New_key[11] ,DL
MOV  New_key[15] ,DH




MOV SI,0
End:
MOV AL,New_key[SI]
MOV R_key[SI] ,AL
INC SI
CMP SI , 16
JNE End



ENDM


.data
array db 16 dup(?) ; to store the inputted byte


R_key DB 02BH, 028H, 0ABH, 009H
DB 07EH, 0AEH, 0F7H, 0CFH
DB 015H, 0D2H, 015H, 04FH
DB 016H, 0A6H, 088H, 03CH

New_key DB 0H, 0H, 0H, 0H
DB 0H, 0H, 0H, 0H
DB 0H, 0H, 0H, 0H
DB 0H, 0H, 0H, 0H

S_BYTES DB 63H, 7cH, 77H, 7bH, 0f2H, 6bH, 6fH, 0c5H, 30H, 01H, 67H, 2BH, 0feH, 0d7H, 0abH, 76H
DB 0caH, 82H, 0c9H, 7dH, 0faH, 59H, 47H, 0f0H, 0adH, 0d4H, 0a2H, 0afH, 9cH, 0a4H, 72H, 0c0H
DB 0b7H, 0fdH, 93H, 26H, 36H, 3fH, 0f7H, 0ccH, 34H, 0a5H, 0e5H, 0f1H, 71H, 0d8H, 31H, 15H
DB 04H, 0c7H, 23H, 0c3H, 18H, 96H, 05H, 9aH, 07H, 12H, 80H, 0e2H, 0ebH, 27H, 0b2H, 75H
DB 09H, 83H, 2cH, 1aH, 1bH, 6eH, 5aH, 0a0H, 52H, 3bH, 0d6H, 0b3H, 29H, 0e3H, 2fH, 84H
DB 53H, 0d1H, 00H, 0edH, 20H, 0fcH, 0b1H, 5bH, 6aH, 0cbH, 0beH, 39H, 4aH, 4cH, 58H, 0cfH
DB 0d0H, 0efH, 0aaH, 0fbH, 43H, 4dH, 33H, 85H, 45H, 0f9H, 02H, 7fH, 50H, 3cH, 9fH, 0a8H
DB 51H, 0a3H, 40H, 8fH, 92H, 9dH, 38H, 0f5H, 0bcH, 0b6H, 0daH, 21H, 10H, 0ffH, 0f3H, 0d2H
DB 0cdH, 0cH, 13H, 0ecH, 5fH, 97H, 44H, 17H, 0c4H, 0a7H, 7eH, 3dH, 64H, 5dH, 19H, 73H
DB 60H, 81H, 4fH, 0dcH, 22H, 2aH, 90H, 88H, 46H, 0eeH, 0b8H, 14H, 0deH, 5eH, 0bH, 0dbH
DB 0e0H, 32H, 3aH, 0aH, 49H, 06H, 24H, 5cH, 0c2H, 0d3H, 0acH, 62H, 91H, 95H, 0e4H, 79H
DB 0e7H, 0c8H, 37H, 6dH, 8dH, 0d5H, 4eH, 0a9H, 6cH, 56H, 0f4H, 0eaH, 65H, 7aH, 0aeH, 08H
DB 0baH, 78H, 25H, 2eH, 1cH, 0a6H, 0b4H, 0c6H, 0e8H, 0ddH, 74H, 1fH, 4bH, 0bdH, 8bH, 8aH
DB 70H, 3eH, 0b5H, 66H, 48H, 03H, 0f6H, 0eH, 61H, 35H, 57H, 0b9H, 86H, 0c1H, 1dH, 9eH
DB 0e1H, 0f8H, 98H, 11H, 69H, 0d9H, 8eH, 94H, 9bH, 1eH, 87H, 0e9H, 0ceH, 55H, 28H, 0dfH
DB 8cH, 0a1H, 89H, 0dH, 0bfH, 0e6H, 42H, 68H, 41H, 99H, 2dH, 0fH, 0b0H, 54H, 0bbH, 16H

Rcon DB 01H, 02H, 04H, 08H, 10H, 20H, 40H, 80H, 1bH, 36H
DB 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H
DB 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H
DB 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H
Rcon_access  DB 00H

Iterations  DB 9





.code

;MAIN


call Input

addRoundKey array

Iterate:

mov cl,Iterations
dec cl
mov Iterations,cl
inc cl
cmp cl,0
je Final_Round

keyScheduler
subBytes array
shiftRows array
mixColumns array
addRoundKey array
jmp Iterate
    
    
    
Final_Round:

keyScheduler
subBytes array
shiftRows array
addRoundKey array

mov ah, 02h
mov dl, 0AH
int 21h
call Output

ret


PROC INPUT
MOV SI, 0
MOV AH, 01H

TAKE:
INT 21H
CMP AL, 61H
JS NOT_LETTER

INPUT_LETTER:
SHL AL, 04
ADD AL, 90H
JMP DONE_LETTER
NOT_LETTER:
SHL AL, 04

DONE_LETTER:
MOV BL, AL
INT 21H
MOV DL, 00001111b
CMP AL, 61H
JS NOT_LETTER2

INPUT_LETTER2:
AND AL, DL
ADD AL, 09H
JMP DONE_LETTER2
NOT_LETTER2:
AND AL, DL
DONE_LETTER2:
OR BL, AL
MOV array[SI], BL
INC SI
CMP SI, 16
JNZ TAKE

RET
ENDP


PROC Output
MOV AH, 02h
MOV CX, 16
mov si, 0
print:
mov dl, array[si]
mov bl, 11110000b
and bl,dl
shr bl, 4
cmp bl, 0Ah
jae letter
jmp number

letter:
add bl, 87
jmp continue

number:
add bl, 30h

continue:
mov dh, dl
mov dl,bl
int 21h
mov dl, dh
mov bl, 00001111b
and bl,dl
cmp bl, 0Ah
jae letter1
jmp number1

letter1:
add bl, 87
jmp continue1

number1:
add bl, 30h

continue1:

mov dl,bl
int 21h

mov dl,'-'
int 21h


inc si
loop print


ret


ENDP











