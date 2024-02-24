; Une implementation des instructions :
; printf("Veuillez entrer m : ");
; scanf("%d", &m) - du langage C (version 2 octets) -
DATA SEGMENT 
    MSG1 DB 'Veuillez entrer m : $'
    n DB 5 DUP('$')
    m DW 2 DUP(0)  
ENDS
STACK SEGMENT 
    DW 128 (0)
ENDS
CODE SEGMENT
    ; Initialisation des registres segment 
    MOV AX, DATA
    MOV DS, AX
    MOV ES, AX
    MOV SP, 0
    ; Affichage du message MSG1
    MOV AH, 09H
    LEA DX, MSG1
    INT 021H
    ; Lecture de l'entier n
    MOV AH, 0AH
    LEA DX, n
    INT 021H
    ; Passage par pile des parametres de la fonction integer
    MOV CX, 5
    MOV SI, 0
      passage:
        ADD SI, 1
        MOV AH, 00H 
        MOV AL, n[SI+1]
        PUSH AX
      loop passage
    ; Appel de la fonction integer
    CALL integer
    MOV m, AX
    ; Fin du programme 
    INT 020H
    ; La fonction integer a pour role de formater l'entier dans la memoire
    integer:
      PUSH BP
      MOV BP, SP
      MOV AX, 0000H
      MOV CX, 5
      MOV DI, 0
      tst:
        MOV SI, CX
        SAL SI, 1
        MOV AX, [BP+SI+2]
        SUB AX, 30H
        PUSH CX
        DEC CX
        JZ last
      puissance:
        MOV BX, 0AH
        MUL BX
      loop puissance
      last:
        POP CX
        ADD DI, AX 
      loop tst  
      MOV AX, DI
      POP BP
      RET  
ENDS