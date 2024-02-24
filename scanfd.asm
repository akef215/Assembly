; Une implementation des instructions :
; printf("Veuillez entrer m : ");
; scanf("%d", &m) - du langage C (version 2 octets) -
DATA SEGMENT 
    MSG1 DB 'Veuillez entrer m : $'
    n DB 10 DUP('$')
    m DW 2 DUP(0)  
ENDS
STACK SEGMENT 
    DW 128 (0)
ENDS
CODE SEGMENT
START:
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
    ; Appel de la fonction compteur
    CALL compteur
    ; Passage par pile des parametres de la fonction integer
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
    PUSH AX
    ; Fin du programme 
    INT 020H
    ; La fonction integer a pour objet de formater l'entier dans la memoire
    integer:
      PUSH BP
      MOV BP, SP
      MOV AX, 0000H
      ; Appel de la fonction compteur
      CALL compteur
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
      ; La fonction compteur a pour objet de compter le nombre de digit du entier entree
      compteur:
        MOV BX, 0
        MOV CX, 10
        MOV SI, 0
        count:
          ADD SI, 1
          MOV AL, n[SI+1]
          CMP AL, 36
          JE break
          JNE cpt
        break:
          MOV CX, 1
        cpt:
          ADD BX, 1  
        loop count
        MOV CX, BX
        SUB CX, 2
        RET    
ENDS
END START
