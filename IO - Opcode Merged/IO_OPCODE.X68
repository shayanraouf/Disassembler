*-----------------------------------------------------------
* Title      : DISSEMBLER
* Written by : PETE
* Date       : TODAY
* Description: I/O
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program
*D2-D3 holds addresses
*D4-D5 for loops
*D6-D7 for error handling
* Put program code here
*____________INTRODUCTION______________________________
                 LEA      INTRO,A1
                 MOVE.B   #14,D0
                 TRAP     #15

*____________Asking for START ADDRESS__________________
REDO             LEA      START_ADDR,A1
                 TRAP     #15
                 MOVE.L   #$0,A1
                 MOVE.B   #2,D0
                 TRAP     #15
                 JSR      ERROR_CHECK       *CHECK FOR INVALID FORMAT
                 CMP.B    #1,D6
                 BEQ      INVALID_START_INPUT
*____________Asking for Ending ADDRESS__________________
ENDING_INPUT     LEA      END_ADDR,A1
                 MOVE.B   #14,D0
                 TRAP     #15
                 MOVE.L   #$100,A1          
                 MOVE.B   #2,D0
                 TRAP     #15
                 JSR      ERROR_CHECK        *CHECK FOR INVALID FORMAT
                 CMP.B    #1,D6
                 BEQ      INVALID_END_INPUT
*____________Turn Start Address into Hex from ASCII____
*At the end of the error checking of the addresses independently
*d0,d1,d4,d5 have TRASH values. a1 points to beginning of start_addr
*and a2 points to beginning of
*end_addr
               CLR             D3
               MOVEA.L         #$0,A0
               MOVEA.L         #$100,A1
               MOVEA.L         #$200,A4

               MOVEM.L         A0,-(SP)
               MOVEM.L         A1,-(SP)

               MOVE.B          #0,D0            *THE NEXT THREE LINES HOLD THE COUNTER FOR THE NUMBER
               MOVE.B          #3,D1            *OF TIMES, WE WILL CONVERT A LONG OF DATA INTO HEX
CONVERT        ADD.B           #1,D0                
               MOVE.L          D7,(A4)+
               CMP.B           D0,D1
               BEQ             END_LOOP
               MOVEM.L         (SP)+,A3
               MOVE.B          #8,D2
               MOVE.B          #0,D3    
FOR_LOOP       CMP.B           D3,D2            *THIS FOR LOOP CONVERTS THE DATA BYTE BY BYTE
               BEQ             CONVERT          *AND PUTS THE RESULT INTO D7
               LSL.L           #4,D7
               MOVE.B          (A3)+,D6
               CMP.B           #$40,D6


               BLE             NUMBER           
LETTER         SUB.B           #$31,D6
               ADD.B           #10,D6
               JMP             END_SUB
NUMBER         SUB.B           #$30,D6

END_SUB        AND.B           #%00001111,D6
               ADD.L            D6,D7           *AT THE END, THE ADDRESSES ARE STORED INTO MEMORY
               ADD.B            #1,D3
               JMP             FOR_LOOP
END_LOOP

*______________COMPARE STARTING AND ENDING ADDRESS FOR ERRORS_________

               MOVEA.L           #$204,A4
               MOVE.L           (A4),D6
               CMP.L            #$00004000,D7              *Check if within set boundary(START ADDR)
               BLT              INVALID_START_INPUT
               CMP.L            #$00FF0000,D6       *Check if within set boundary(END ADDR)   
               BGT              INVALID_END_INPUT
               CMP.L            D6,D7       *D7 HOLDS STARTING ADDR, D6 HOLDS ENDING ADDR
               BGT              RESTART
*______________________YOUR CODE STARTS HERE!!!!!!!!!!___________________

    
OpCodeInterpreter
    MOVEA.L     D7,A0
    MOVEM.L     D1-D7/A2-A6,-(SP)       ; push unused registers to stack
    
shift           EQU         12                      
    LEA         JMP_TABLE,A3       ; offset into table
    MOVE.L      A0,A2                   ; save the start of the data being read
    MOVE.W      (A0),D1                 ; pull the instruction from memory
    MOVE.W      D1,D2                   ; Move instruction into a working space
    MOVE.W      #shift,D3               ; Shift 12 bits to the right
    LSR.W       D3,D2                   ; Move the bits
    MULU        #6,D2                   ; Form offset
    JMP         00(A3,D2)               ; Jump indirect with index
JMP_TABLE
     JMP         OPCODE_0000
     JMP         OPCODE_0001
     JMP         OPCODE_0010
     JMP         OPCODE_0011
     JMP         OPCODE_0100
     JMP         OPCODE_0101
     JMP         OPCODE_0110
     JMP         OPCODE_0111
     JMP         OPCODE_1000
     JMP         OPCODE_1001
     JMP         OPCODE_1010
     JMP         OPCODE_1011
     JMP         OPCODE_1100
     JMP         OPCODE_1101
     JMP         OPCODE_1110
     JMP         OPCODE_1111

OPCODE_0000

    JSR EA_ADDI
    
OPCODE_0001
    JSR EA_MOVEB
   
OPCODE_0010
    MOVE.L     #%001,D4
    MOVE.W     (A0),D5
    LSL.W      #7,D5 
    LSR.W      #7,D5 
    LSR.W      #6,D5
    
    CMP.W      D4,D5
    BEQ        EA_MOVEAL 
    BRA        EA_MOVEL    
    
OPCODE_0011
    MOVE.L     #%001,D4
    MOVE.W     (A0),D5
    LSL.W      #7,D5 
    LSR.W      #7,D5 
    LSR.W      #6,D5
    
    CMP.W      D4,D5
    BEQ        EA_MOVEAW 
    BRA        EA_MOVEW   

OPCODE_0100
    MOVE.W     (A0),D5
    
    MOVE.L     #%0100111001110001,D4 *machine code for NOP
    CMP.W      D4,D5
    BEQ        EA_NOP

    CLR.L      D4
    MOVE.L     #%01000010,D4 
    LSR.W      #8,D5
    CMP.W      D4,D5
    BEQ        EA_CLR
    
    CLR.L      D4
    CLR.L      D5
    MOVE.W     (A0),D5
    MOVE.L     #%0100111001110101,D4
    CMP.W      D4,D5
    BEQ        EA_RTS
    
    
    CLR.L      D4
    MOVE.L     #%0100111010,D4
    LSR        #6,D5
    CMP.W      D4,D5
    BEQ        EA_JSR
    
    CLR.L      D4
    CLR.L      D5
    MOVE.W     (A0),D5
    
    MOVE.L     #%111,D4
    LSL.W      #7,D5 
    LSR.W      #7,D5 
    LSR.W      #6,D5
    
    CMP.W      D4,D5
    BEQ        EA_LEA
    BRA        EA_MOVEM
    
    
    
 
OPCODE_0101
    JSR EA_ADDQ

OPCODE_0110
    MOVE.W     (A0),D5
    LSR.L      #7,D5
    
    MOVE.L     #%01100100,D4 *BCC
    CMP.W      D4,D5
    BEQ        EA_BCC
    
    CLR.L      D4
    MOVE.L     #%01101110,D4 *BGT
    CMP.W      D4,D5
    BEQ        EA_BGT
    
    BRA        EA_BLE
    
OPCODE_0111
    JSR EA_MOVEQ
OPCODE_1000
    MOVE.L     #%011,D4
    MOVE.W     (A0),D5
    LSL.W      #7,D5 
    LSR.W      #7,D5 
    LSR.W      #6,D5
    
    CMP.W      D4,D5
    BEQ        EA_DIVU 
    BRA        EA_OR   

OPCODE_1001
    JSR EA_SUB
OPCODE_1010

OPCODE_1011
    JSR EA_CMP
OPCODE_1100

OPCODE_1101


OPCODE_1110

OPCODE_1111

*Effective Addressing Section----------------------------------
EA_ADDI
      
EA_MOVEB
    
EA_MOVEL
    
EA_MOVEAL

EA_MOVEAW
   

EA_MOVEW

EA_ADDQ

EA_SUB

EA_CMP

EA_MOVEQ

EA_DIVU
    
EA_OR
    
    
EA_NOP
    *move.l (A0),D6
EA_CLR
    
    
EA_RTS
    *move.l (A0),D6
    
EA_JSR
    *move.l (A0),D6
    
EA_LEA
    move.l (A0),D6

EA_MOVEM

EA_BCC


EA_BGT

EA_BLE
   
*--------------------------------------------------------------



*_____________PRINTING_______________________
*THE IDEA HERE IS THAT I PRINT A BYTE FROM OP-CODES,PRINT 3 BYTES FROM
*EFFECTIVE ADDRESSING AND REPEAT TILL I'VE FINISHED
                MOVE.B              #0,D0
                MOVE.B              #0,D5
               *MOVE.L              COUNTER,D6
PRINTINGLOOP    CMP.L               D5,D6
                BEQ                 END
                TRAP                #15
                ADDA.L             #5,A1        *ADDS THE AMOUNT NEEDED TO MOVE TO NEXT OP-CODE
                MOVEA.L             A2,A3       *A2 HOLDS EA
                MOVEA.L             A1,A2       *A1 HOLDS OPCODE
                MOVEA.L             A3,A1       *MOVES EA INTO A1 TO PRINT
                TRAP                #15
                ADDA.L              #9,A1       *ADDS THE AMOUNT NEEDED TO MOVE TO NEXT EA

                MOVEA.L             A2,A3       *ROTATE MEMORY LOCATIONS BACK
                MOVEA.L             A1,A2
                MOVEA.L             A3,A1


                ADD.L               #1,D5
                JMP                 PRINTINGLOOP
                 
                 
               

*_____________Check for Address Input Errors___________
ERROR_CHECK      CMP.B    #$8,D1          *CHECK IF ADDRESS TOO LONG
                    BGT   FALSE
                 MOVE.B   #8,D5
                 CLR      D4
                 MOVE.L   A1,A2
ERROR_LOOP       CMP      D4,D5         *CHECK FOR VALID CHARACTERS IN INPUT
                 BEQ      ERR_FINISH
                 CMP.B    #$5A,(A1)
                    BGT   FALSE
                 CMP.B    #$30,(A1)+
                    BLT   FALSE
                 ADD.B    #1,D4
                 JMP      ERROR_LOOP
                 MOVE.L   #0,A2
                 MOVE.L   A2,A1 
ERR_FINISH       RTS



ASC_CONVERSION


*_________INVALID INPUT______________________
INVALID_START_INPUT    LEA      INVALID_INPUT_MES,A1
                       MOVE.B   #14,D0
                       TRAP     #15
                       CLR      D6
                       JMP      REDO
INVALID_END_INPUT      LEA      INVALID_INPUT_MES,A1
                       MOVE.B   #14,D0
                       TRAP     #15
                       CLR      D6
                       JMP      ENDING_INPUT
RESTART
                       LEA RESTART_MSG,A1 
                       MOVE.B   #14,D0
                       TRAP     #15
                       MOVEA.L   #$50,A1 *MOVES A1 SO MESSAGES DONT GET OVERWRITTEN
                       MOVE.B   #2,D0
                       TRAP     #15           
                       CMP.B    #$59,(A1)
                       BNE      END
                       JMP      REDO
FALSE
                       MOVE.B   #1,D6
                       RTS
                       
END                       
    SIMHALT             ; halt simulator

* Put variables and constants here
CR      EQU     $0D
LF      EQU     $0A
INTRO   DC.B    'They call us Lil Bits.',CR,LF
        DC.B    'You abouts to get',CR,LF
        DC.B    'disassmbled',CR,LF,0
RESTART_MSG DC.B    'INVALID PUT, WOULD YOU LIKE TO END THE PROGRAM OR TRY AGAIN? (ENTER Y TO RESTART)',0
START_ADDR  DC.B 'Enter Starting Address (Between $00004000 && $00FF0000):',0
END_ADDR  DC.B 'Enter Ending Address (Between $00004000 && $00FF0000):',0
INVALID_INPUT_MES    DC.B    'INVALID INPUT, TRY AGAIN',CR,LF,0
    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
