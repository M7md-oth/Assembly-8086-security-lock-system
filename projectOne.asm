.MODEL SMALL
.STACK 100h

.DATA
MAX_EMP EQU 10

HEAD    DB 0Dh, 0Ah, '__Mohammed Othman_1221175 _Security lock_  _Andrew Odeh_1222212_', 0Dh, 0Ah, '$'
MSG_ID  DB 0Dh, 0Ah, 'Enter your ID : $'
MSG_PW  DB 0Dh, 0Ah, 'Enter your Password : $'
NOT_FOUND DB 0Dh, 0Ah, 'ID Not Found...$', 0Dh, 0Ah
WRONG_PW DB 0Dh, 0Ah, 'Wrong Password The Access Denied.$', 0Dh, 0Ah
ALLOW   DB 0Dh, 0Ah, 'Correct Password Access Allowed$', 0Dh, 0Ah
SUCCESS DB 0Dh, 0Ah, 'enc successfully converted$', 0Dh, 0Ah

EmpIDs  DW 65, 148, 526, 2036, 1504, 82, 112, 2840, 940, 1292
OrigPW  DB 125, 84, 29, 37, 187, 219, 62, 75, 141, 243
EncPW   DB 10 DUP(?)

UserID  DW 0
UserPass DB 0

.CODE

enc PROC
    MOV AH, AL
    SHR AL, 7
    SHL AH, 1
    OR AL, AH
    TEST AL, 10000001b
    JZ rot
    RET

rot:
    ROR AL, 2
    RET
enc ENDP

encPass PROC
    MOV CX, MAX_EMP
    MOV SI, 0

encLoop:
    MOV AL, [OrigPW + SI]
    CALL enc
    MOV [EncPW + SI], AL
    INC SI
    LOOP encLoop

    LEA DX, SUCCESS
    MOV AH, 09h
    INT 21h

    RET
encPass ENDP

ValidateLogin PROC
    MOV BX, 0
    XOR SI, SI

SearchID:
    CMP AX, [EmpIDs + SI]
    JE FoundID
    ADD SI, 2
    INC BX
    CMP BX, MAX_EMP
    JB SearchID

    LEA DX, NOT_FOUND
    MOV AH, 09h
    INT 21h
    RET

FoundID:
    LEA DX, MSG_PW
    MOV AH, 09h
    INT 21h

    CALL READPW
    MOV AL, UserPass
    CALL enc
    CMP AL, [EncPW + BX]
    JE AccessGranted

    LEA DX, WRONG_PW
    MOV AH, 09h
    INT 21h
    RET

AccessGranted:
    LEA DX, ALLOW
    MOV AH, 09h
    INT 21h
    MOV AH, 4Ch
    INT 21h
ValidateLogin ENDP

MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    LEA DX, HEAD
    MOV AH, 09h
    INT 21h

    CALL encPass

TryAgain:
    LEA DX, MSG_ID
    MOV AH, 09h
    INT 21h

    CALL READN
    MOV UserID, AX
    CALL ValidateLogin
    JMP TryAgain

    MOV AH, 4Ch
    INT 21h
MAIN ENDP

READN PROC NEAR
    PUSH BX
    PUSH CX
    MOV CX, 10             
    MOV BX, 0               

READN1:    
    MOV AH, 01h
    INT 21h
    CMP AL, 0Dh             
    JE READN2               

    CMP AL, '0'            
    JB READN1               
    CMP AL, '9'
    JA READN1

    SUB AL, '0'            
    PUSH AX                 
    MOV AX, BX             
    MUL CX                  
    MOV BX, AX             
    POP AX                 
    MOV AH, 0               
    ADD BX, AX             
    JMP READN1              

READN2:
    MOV AX, BX              
    POP CX
    POP BX
    RET
READN ENDP

READPW PROC NEAR
    PUSH BX
    PUSH CX
    MOV CX, 10              

    MOV BX, 0               
READPW1:
    MOV AH, 08h
    INT 21h
    CMP AL, 0Dh             
    JE READPW2             

    CMP AL, '0'             
    JB READPW1              
    CMP AL, '9'
    JA READPW1

    SUB AL, '0'            
    PUSH AX                 
    MOV AX, BX             
    MUL CX                  
    MOV BX, AX             
    POP AX                 
    MOV AH, 0               
    ADD BX, AX             
    JMP READPW1             

READPW2:
    MOV UserPass, BL
    MOV AX, BX              
    POP CX
    POP BX
    RET
READPW ENDP

END MAIN
