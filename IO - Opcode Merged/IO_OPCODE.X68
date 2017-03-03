*-----------------------------------------------------------
* Title      : DISSEMBLER
* Written by : PETE
* Date       : TODAY
* Description: I/O
*-----------------------------------------------------------
addr1     EQU     $4000 
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
    JSR         PRINT_ADDRESS_HEX
    JSR         PRINT_SPACE
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
    LEA         ADDI_MSG,A1         
    MOVE.B      #14,D0
    TRAP        #15
    JSR EA_ADDI
    
OPCODE_0001
    LEA         MOVEB_MSG,A1         
    MOVE.B      #14,D0
    TRAP        #15
    JSR EA_MOVEB
   
OPCODE_0010
    MOVE.L      #%001,D4
    MOVE.W     (A0),D5
    LSL.W       #7,D5 
    LSR.W       #7,D5 
    LSR.W       #6,D5
    
    CMP.W       D4,D5
    BEQ         OPCODE_MOVEAL
    BRA         OPCODE_MOVEL


OPCODE_MOVEL
    LEA         MOVEL_MSG,A1         
    MOVE.B      #14,D0
    TRAP        #15
    BRA         EA_MOVEL 

OPCODE_MOVEAL
    LEA         MOVE_MSG,A1         
    MOVE.B      #14,D0
    TRAP        #15
    BRA         EA_MOVEAL 
        
    
OPCODE_0011
    MOVE.L     #%001,D4
    MOVE.W     (A0),D5
    LSL.W      #7,D5 
    LSR.W      #7,D5 
    LSR.W      #6,D5
    CMP.W      D4,D5
    BEQ        PRINT_MOVEAW
    BRA        PRINT_MOVE_WORD
    
PRINT_MOVE_WORD
    LEA         MOVEW_MSG,A1         
    MOVE.B      #14,D0
    TRAP        #15
    BRA         EA_MOVEW 

PRINT_MOVEAW
    LEA         MOVEAW_MSG,A1         
    MOVE.B      #14,D0
    TRAP        #15
    BRA         EA_MOVEAW  
    
CONT_0011    
    CMP.W       D4,D5
    BEQ         OPCODE_AW
    LEA         MOVE_MSG,A1         
    MOVE.B      #14,D0
    TRAP        #15
    BRA         EA_MOVEW
    
OPCODE_AW
    LEA         MOVEA_MSG,A1         
    MOVE.B      #14,D0
    TRAP        #15
    BRA         EA_MOVEAW 
     
OPCODE_MOVE
    LEA         MOVE_MSG,A1         
    MOVE.B      #14,D0
    TRAP        #15
    JMP         CONT_0011
  
OPCODE_0100
    MOVE.W     (A0),D5
    
    MOVE.L     #%0100111001110001,D4 *machine code for NOP
    CMP.W      D4,D5
    BEQ        OPCODE_NOP

    CLR.L      D4
    MOVE.L     #%01000010,D4 
    LSR.W      #8,D5
    CMP.W      D4,D5
    BEQ        OPCODE_CLR
    
    CLR.L      D4
    CLR.L      D5
    MOVE.W     (A0),D5
    MOVE.L     #%0100111001110101,D4
    CMP.W      D4,D5
    BEQ        OPCODE_RTS
    
    
    CLR.L      D4
    MOVE.L     #%0100111010,D4
    LSR        #6,D5
    CMP.W      D4,D5
    BEQ        OPCODE_JSR
    
    CLR.L      D4
    CLR.L      D5
    MOVE.W     (A0),D5
    
    MOVE.L     #%111,D4
    LSL.W      #7,D5 
    LSR.W      #7,D5 
    LSR.W      #6,D5
    
    CMP.W      D4,D5
    BEQ        OPCODE_LEA
    BRA        OPCODE_MOVEM
    
OPCODE_NOP
    LEA         NOP_MSG,A1         
    MOVE.B      #14,D0
    TRAP        #15
    BRA         EA_NOP 
    
OPCODE_CLR
    LEA         CLR_MSG,A1         
    MOVE.B      #14,D0
    TRAP        #15
    BRA         EA_CLR  

OPCODE_JSR
    LEA         JSR_MSG,A1         
    MOVE.B      #14,D0
    TRAP        #15
    BRA         EA_JSR  
    
OPCODE_RTS

    LEA         RTS_MSG,A1         
    MOVE.B      #14,D0
    TRAP        #15
    BRA       EA_RTS  

OPCODE_LEA
    LEA         LEA_MSG,A1         
    MOVE.B      #14,D0
    TRAP        #15
    BRA       EA_LEA  
    
OPCODE_MOVEM

    LEA         MOVEM_MSG,A1         
    MOVE.B      #14,D0
    TRAP        #15
    BRA       EA_MOVEM      
 
OPCODE_0101
    LEA         ADDQ_MSG,A1         
    MOVE.B      #14,D0
    TRAP        #15
    JSR EA_ADDQ

OPCODE_0110
    MOVE.W     (A0),D5
    LSR.L      #7,D5
    
    MOVE.L     #%01100100,D4 *BCC
    CMP.W      D4,D5
    BEQ        OPCODE_BCC
    
    CLR.L      D4
    MOVE.L     #%01101110,D4 *BGT
    CMP.W      D4,D5
    BEQ        OPCODE_BGT
    BRA        OPCODE_BLT
    
OPCODE_BCC
    LEA         BCC_MSG,A1         
    MOVE.B      #14,D0
    TRAP        #15
    JSR EA_BCC
    
OPCODE_BGT
    LEA         BGT_MSG,A1         
    MOVE.B      #14,D0
    TRAP        #15
    JSR EA_BGT
    
OPCODE_BLT
    LEA         BLE_MSG,A1         
    MOVE.B      #14,D0
    TRAP        #15
    JSR EA_BLT
    
OPCODE_0111
    LEA         MOVEQ_MSG,A1         
    MOVE.B      #14,D0
    TRAP        #15
    JSR EA_MOVEQ
OPCODE_1000
    MOVE.L     #%011,D4
    MOVE.W     (A0),D5
    LSL.W      #7,D5 
    LSR.W      #7,D5 
    LSR.W      #6,D5
    
    CMP.W      D4,D5
    BEQ        OPCODE_DIVU 
    BRA        OPCODE_OR

OPCODE_OR
    LEA         OR_MSG,A1         
    MOVE.B      #14,D0
    TRAP        #15
    BRA       EA_OR

OPCODE_DIVU
    LEA         DIVU_MSG,A1         
    MOVE.B      #14,D0
    TRAP        #15
    BRA       EA_DIVU

OPCODE_1001

    MOVEA.L #$00000000,A1       
    CLR.L   D0
    
    LEA         SUB_MSG,A1         
    MOVE.B      #14,D0
    TRAP        #15
    JMP EA_SUB
OPCODE_1010

OPCODE_1011
    LEA         CMP_MSG,A1         
    MOVE.B      #14,D0
    TRAP        #15
    JSR EA_CMP
OPCODE_1100

OPCODE_1101

OPCODE_1110

OPCODE_1111



*Effective Addressing Section----------------------------------
*--------------------------------------------------------------
*--------------------------------------------------------------
EA_ADDI
    CLR.L     D4
    CLR.L     D5
    *MOVE.W   (A0)+,D4
    MOVE.L    #$00000600,D4
    MOVE.W   D4,D5
    LSL.W    #8,D5
    LSR.W    #8,D5
    LSR.W    #6,D5
    BRA COMPARE
EA_MOVEB
    CLR.L     D4
    CLR.L     D5
    MOVE.W   (A0),D4
    MOVE.W   D4,D5 *Save
    
    JSR      BITS_2_THROUGH_0 * SAVE THE REGISTER FIRST
    MOVE.W   D4,D3            * NEEDS TO GO IN D3 FOR REGISTER JUMP TABLE
    
    MOVE.W   D5,D4            * RESET TO ORIGANIAL OPCODE
    JSR      BITS_5_THROUGH_3 * GET BITS 5-3 FOR EA MODE
    JSR      MODE_JMP_TABLE   * JUMP TO MODE TABLE



    *JSR      REGISTER_JMP_TABLE
       
    JSR      PRINT_COMMA                           *print comma
                                  
    MOVE.W   D5,D4              * RESET TO ORIGANIAL OPCODE  
    JSR      BITS_11_THROUGH_9  * SAVE THE REGISTER FIRST
    MOVE.W   D4,D3              * NEEDS TO GO IN D3 FOR REGISTER JUMP TABLE 
    
    
    MOVE.W   D5,D4              * RESET TO ORIGANIAL OPCODE
         
    JSR      BITS_8_THROUGH_6
    JSR      MODE_JMP_TABLE     * JUMP TO MODE TABLE

    BRA COMPARE
EA_MOVEL
    CLR.L     D4
    CLR.L     D5
    MOVE.W   (A0),D4
    MOVE.W   D4,D5 *Save
    
    JSR      BITS_2_THROUGH_0 * SAVE THE REGISTER FIRST
    MOVE.W   D4,D3            * NEEDS TO GO IN D3 FOR REGISTER JUMP TABLE
    
    MOVE.W   #2,D2
    MOVE.W   D5,D4            * RESET TO ORIGANIAL OPCODE
    JSR      BITS_5_THROUGH_3 * GET BITS 5-3 FOR EA MODE
    JSR      MODE_JMP_TABLE   * JUMP TO MODE TABLE



    *JSR      REGISTER_JMP_TABLE
       
    JSR      PRINT_COMMA                           *print comma
                                  
    MOVE.W   D5,D4              * RESET TO ORIGANIAL OPCODE  
    JSR      BITS_11_THROUGH_9  * SAVE THE REGISTER FIRST
    MOVE.W   D4,D3              * NEEDS TO GO IN D3 FOR REGISTER JUMP TABLE 
    
    
    MOVE.W   D5,D4              * RESET TO ORIGANIAL OPCODE
         
    JSR      BITS_8_THROUGH_6
    JSR      MODE_JMP_TABLE     * JUMP TO MODE TABLE

    BRA COMPARE

EA_MOVEW
    CLR.L     D4
    CLR.L     D5
    MOVE.W   (A0),D4
    MOVE.W   D4,D5 *Save
    
    JSR      BITS_2_THROUGH_0 * SAVE THE REGISTER FIRST
    MOVE.W   D4,D3            * NEEDS TO GO IN D3 FOR REGISTER JUMP TABLE
    
    MOVE.W   #3,D2
    
    MOVE.W   D5,D4            * RESET TO ORIGANIAL OPCODE
    JSR      BITS_5_THROUGH_3 * GET BITS 5-3 FOR EA MODE
    JSR      MODE_JMP_TABLE   * JUMP TO MODE TABLE



    *JSR      REGISTER_JMP_TABLE
       
    JSR      PRINT_COMMA                           *print comma
                                  
    MOVE.W   D5,D4              * RESET TO ORIGANIAL OPCODE  
    JSR      BITS_11_THROUGH_9  * SAVE THE REGISTER FIRST
    MOVE.W   D4,D3              * NEEDS TO GO IN D3 FOR REGISTER JUMP TABLE 
    
    
    MOVE.W   D5,D4              * RESET TO ORIGANIAL OPCODE
         
    JSR      BITS_8_THROUGH_6
    JSR      MODE_JMP_TABLE     * JUMP TO MODE TABLE

    BRA COMPARE
    
EA_MOVEAL
    CLR.L     D4
    CLR.L     D5
    MOVE.W   (A0),D4
    MOVE.W   D4,D5 *Save
    
    JSR      BITS_2_THROUGH_0 * SAVE THE REGISTER FIRST
    MOVE.W   D4,D3            * NEEDS TO GO IN D3 FOR REGISTER JUMP TABLE
    
    MOVE.W   #2,D2
    MOVE.W   D5,D4            * RESET TO ORIGANIAL OPCODE
    JSR      BITS_5_THROUGH_3 * GET BITS 5-3 FOR EA MODE
    JSR      MODE_JMP_TABLE   * JUMP TO MODE TABLE



    *JSR      REGISTER_JMP_TABLE
       
    JSR      PRINT_COMMA                           *print comma
                                  
    MOVE.W   D5,D4              * RESET TO ORIGANIAL OPCODE  
    JSR      BITS_11_THROUGH_9  * SAVE THE REGISTER FIRST
    MOVE.W   D4,D3              * NEEDS TO GO IN D3 FOR REGISTER JUMP TABLE 
    
    
    MOVE.W   D5,D4              * RESET TO ORIGANIAL OPCODE
         
    JSR      BITS_8_THROUGH_6
    JSR      MODE_JMP_TABLE     * JUMP TO MODE TABLE

    BRA COMPARE
EA_MOVEAW
    CLR.L     D4
    CLR.L     D5
    MOVE.W   (A0),D4
    MOVE.W   D4,D5 *Save
    
    JSR      BITS_2_THROUGH_0 * SAVE THE REGISTER FIRST
    MOVE.W   D4,D3            * NEEDS TO GO IN D3 FOR REGISTER JUMP TABLE
    
    MOVE.W   #3,D2
    
    MOVE.W   D5,D4            * RESET TO ORIGANIAL OPCODE
    JSR      BITS_5_THROUGH_3 * GET BITS 5-3 FOR EA MODE
    JSR      MODE_JMP_TABLE   * JUMP TO MODE TABLE



    *JSR      REGISTER_JMP_TABLE
       
    JSR      PRINT_COMMA                           *print comma
                                  
    MOVE.W   D5,D4              * RESET TO ORIGANIAL OPCODE  
    JSR      BITS_11_THROUGH_9  * SAVE THE REGISTER FIRST
    MOVE.W   D4,D3              * NEEDS TO GO IN D3 FOR REGISTER JUMP TABLE 
    
    
    MOVE.W   D5,D4              * RESET TO ORIGANIAL OPCODE
         
    JSR      BITS_8_THROUGH_6
    JSR      MODE_JMP_TABLE     * JUMP TO MODE TABLE

    BRA COMPARE   
EA_ADDQ
    lsl.w   0
    BRA COMPARE

*****************************************
* EA SUBROUTINE FOR                 DIVU
*****************************************     
EA_DIVU
    CLR.L  D5
    MOVE.W (A0),D5
    JMP    OP_MODE_ea_Dn


*****************************************
* EA SUBROUTINE FOR                  SUB
*****************************************    
EA_SUB
        CLR.L  D5
        MOVE.W (A0),D5
        JSR    CHECK_SIZE       * CHECKS THE SIZE AND PRINTS
        JSR    PRINT_SPACE 
        BTST   #8,D5            * GET THE OPMODE
        BNE    OP_MODE_Dn_ea
        JMP    OP_MODE_ea_Dn
      
EA_CMP
    CLR.L  D5
    MOVE.W (A0),D5
    JSR    CHECK_SIZE       * CHECKS THE SIZE AND PRINTS
    JSR    PRINT_SPACE 
    JMP    OP_MODE_ea_Dn
EA_MOVEQ
    lsl.w   0
    BRA COMPARE

EA_OR
    lsl.w   0
    BRA COMPARE
EA_NOP
    lsl.w   0
    BRA COMPARE
EA_CLR
    lsl.w   0
    BRA COMPARE
EA_RTS
   LEA         JSR_MSG,A1         
   MOVE.B      #14,D0
   TRAP        #15
   BRA         EA_JSR  
   BRA  OPCODE_JSR
 
EA_JSR
    * PRINT EA
    CLR.L         D4
    CLR.L         D5

    MOVE.W      (A0),D5
    
    MOVE.W      D5,D4                *get the size first and store in D3 for reg. jmp table
    JSR         BITS_2_THROUGH_0
    MOVE.W      D4,D3
    
    MOVE.W      D5,D4
    JSR         BITS_2_THROUGH_0
    MOVE.W      D4,D2
    
    MOVE.W  D5,D4                   *get the mode and store in D4 for mode jump table
    JSR     BITS_5_THROUGH_3
    JSR     MODE_JMP_TABLE          * Jumps to mode jmp table
    BRA COMPARE
    
EA_LEA
    * PRINT EA
    CLR.L         D4
    CLR.L         D5

    MOVE.W      (A0),D5
    
    MOVE.W      D5,D4                *get the size first and store in D3 for reg. jmp table
    JSR         BITS_2_THROUGH_0
    MOVE.W      D4,D3
    
    MOVE.W      D5,D4
    JSR         BITS_2_THROUGH_0
    MOVE.W      D4,D2
    
    MOVE.W  D5,D4                   *get the mode and store in D4 for mode jump table
    JSR     BITS_5_THROUGH_3
    JSR     MODE_JMP_TABLE          * Jumps to mode jmp table
    
    JSR     PRINT_COMMA
    
    JSR     PRINT_A
    
    MOVE.W   D5,D4              * RESET TO ORIGANIAL OPCODE  
    JSR      BITS_11_THROUGH_9  * SAVE THE REGISTER FIRST
    MOVE.W   D4,D3              * NEEDS TO GO IN D3 FOR REGISTER JUMP TABLE 
    JSR      REGISTER_JMP_TABLE 
    BRA COMPARE
    
EA_MOVEM
    lsl.w   0
    BRA COMPARE
EA_BCC
    lsl.w   0
    BRA COMPARE
EA_BGT
    lsl.w   0
    *logic move isolate the bits 
    *ISOLATE REGISTER BITS AS WELL

    BRA COMPARE
EA_BLT
    lsl.w   0
    BRA COMPARE


    
************************************
* LOGIC FOR THE <ea>,<ea> OPMODE
************************************  

OP_MODE_ea_ea
    
    
    
    
************************************
* LOGIC FOR THE <ea>,<Dn> OPMODE
************************************  

OP_MODE_ea_Dn
    * PRINT EA
    CLR.L   D4
    MOVE.W  D5,D4                *get the size first and store in D3 for reg. jmp table
    JSR     BITS_2_THROUGH_0
    MOVE.W  D4,D3
    
    MOVE.W      D5,D4
    JSR         BITS_2_THROUGH_0
    MOVE.W      D4,D2
    
    MOVE.W  D5,D4                *get the mode and store in D4 for mode jump table
    JSR     BITS_5_THROUGH_3
    JSR     MODE_JMP_TABLE       * Jumps to mode jmp table
    
    JSR     PRINT_COMMA
*     MOVE.W  D5,D4
*     JSR     BITS_2_THROUGH_0
*    JSR     REGISTER_JMP_TABLE 
    
    * PRINT DN
    JSR     PRINT_D    
    CLR.L   D4
    MOVE.W  D5,D4
    JSR     BITS_11_THROUGH_9
    MOVE.W  D4,D3
    JSR     REGISTER_JMP_TABLE 
    
    BRA     COMPARE 
    
************************************
* LOGIC FOR THE <Dn>,<ea> OPMODE
************************************    
OP_MODE_Dn_ea
    * PRINT DN
    JSR     PRINT_D
    CLR.L   D4
    MOVE.W  D5,D4
    JSR     BITS_11_THROUGH_9
    MOVE.W  D4,D3
    JSR     REGISTER_JMP_TABLE
 
    JSR     PRINT_COMMA
     * PRINT EA
     
    MOVE.W  D5,D4                   * get the size first for register jump table, store in register D3
    JSR     BITS_2_THROUGH_0
    MOVE.W  D4,D3
    CLR.L   D4
    
    MOVE.W      D5,D4
    JSR         BITS_2_THROUGH_0
    MOVE.W      D4,D2
    
    MOVE.W  D5,D4                   * get the mode type and store in D4
    JSR     BITS_5_THROUGH_3


    JSR     MODE_JMP_TABLE * Jumps to mode jmp table
    
    BRA     COMPARE


************************************
* PRINTS THE ADDRESS IN HEX
************************************ 
PRINT_ADDRESS_HEX
    MOVE.L      D7,D1
    MOVE.B      #15,D0
    MOVE.B      #16,D2
    TRAP        #15
    CLR.L       D1
    CLR.L       D0
    CLR.L       D2
    RTS 
    
************************************
* ISOLATES BITS 5-3 
************************************    
BITS_5_THROUGH_3
        LSL.W   #5,D4
        LSL.W   #5,D4
        

        LSR.W   #6,D4
        LSR.W   #7,D4
        RTS

************************************
* ISOLATES BITS 11-9
************************************  
BITS_11_THROUGH_9
        LSL.W   #4,D4
        LSR.W   #6,D4
        LSR.W   #7,D4
        RTS

************************************
* ISOLATES BITS 2-0
************************************          
BITS_2_THROUGH_0
        LSL.W   #6,D4
        LSL.W   #7,D4
 
        LSR.W   #6,D4
        LSR.W   #7,D4
        RTS

************************************
* ISOLATES BITS 8-6
************************************          
BITS_8_THROUGH_6
        LSL.W   #7,D4
 
        LSR.W   #6,D4
        LSR.W   #7,D4
        RTS
              

************************************
* Checks the 7th bit to see the size  
************************************
CHECK_SIZE
    BTST    #7,D5
    BNE     IS_LONG
    JSR     IS_BYTE_WORD
    RTS     

************************************
* PRINTS L AND RTS BACK 
************************************    
IS_LONG
   CLR.L    D1
   CLR.L    D0
   MOVE.W   #2,D2
   MOVE.B   #'L',D1
   MOVE.B   #6,D0
   TRAP     #15
   RTS

************************************
* PRINTS B AND RTS BACK 
************************************  
IS_BYTE_WORD
        BTST    #6,D5
        BNE     IS_WORD
        JMP     IS_BYTE
CONT    RTS     
        
   

******************************************
* PRINTS W AND JUMPS BACK TO IS_BYTE_WORD
****************************************** 
IS_WORD
   CLR.L    D1
   CLR.L    D0
   MOVE.W   #3,D2
   MOVE.B   #'W',D1
   MOVE.B   #6,D0
   TRAP     #15
   JMP      CONT


*****************************************
* PRINTS W AND JUMPS BACK TO IS_BYTE_WORD
***************************************** 
IS_BYTE
   CLR.L    D1
   CLR.L    D0
   MOVE.B   #'B',D1
   MOVE.B   #6,D0
   TRAP     #15
   JMP      CONT


*****************************************
* SIMPLY PRINTS A LINE
***************************************** 
PRINT_NEW_LINE
   LEA      BLANK,A1 
   CLR.L    D1
   CLR.L    D0
   MOVE.B   #13,D0
   TRAP     #15 
   RTS       
 

*****************************************
*INITIALIZES JMP TABLE FOR MODE
*****************************************
MODE_JMP_TABLE 
    LEA M_JMP_TABLE,A2
    MULU #$6,D4
    JSR 0(A2,D4)
    RTS
M_JMP_TABLE 
    JMP     MODE_000
    JMP     MODE_001
    JMP     MODE_010
    JMP     MODE_011
    JMP     MODE_100
    JMP     MODE_101
    JMP     MODE_110
    JMP     MODE_111
    


MODE_000
    JSR         PRINT_D
    JSR         REGISTER_JMP_TABLE 
    RTS
MODE_001
    JSR         PRINT_A
    JSR         REGISTER_JMP_TABLE
    RTS
MODE_010
    JSR         PRINT_OPEN_PARAN
    JSR         PRINT_A
    JSR         REGISTER_JMP_TABLE
    JSR         PRINT_CLOSE_PARAN
    RTS
    
MODE_011
    JSR         PRINT_OPEN_PARAN
    JSR         PRINT_A
    JSR         REGISTER_JMP_TABLE
    JSR         PRINT_CLOSE_PARAN
    JSR         PRINT_PLUS
    RTS
MODE_100
    JSR         PRINT_MINUS
    JSR         PRINT_OPEN_PARAN
    JSR         PRINT_A
    JSR         REGISTER_JMP_TABLE
    JSR         PRINT_CLOSE_PARAN

    RTS
MODE_101
    JSR     PRINT_A
    RTS
MODE_110
    JSR     PRINT_A
    RTS

MODE_111
                
                CMP.W       #%0000000000000100,D3   * LITERAL ADDRESSING
                BEQ         MODE_LITERAL_DATA

                CMP.W       #%0000000000000001,D3   * LONG ADDRESSING
                BEQ         MODE_LONG_DATA
                
                CMP.W       #%0000000000000000,D3   * WORD ADDRESSING
                BEQ         MODE_WORD_DATA
                
MODE_111_CONT   RTS


MODE_LONG_DATA
                JSR         PRINT_$
                ADD.L       #2,D7
                MOVEA.L     D7,A1
                MOVE.L      (A1),D1
                MOVE.B      #15,D0
                MOVE.B      #16,D2
                TRAP        #15
                ADD.L       #2,D7
                JMP         MODE_111_CONT

MODE_LITERAL_DATA
                JSR         PRINT_HASH_TAG
                CMP         #2,D2
                BEQ         MODE_LONG_DATA 
                BRA         MODE_WORD_DATA
                

MODE_WORD_DATA
                JSR         PRINT_$
                ADD.L       #2,D7
                MOVEA.W     D7,A1
                MOVE.W      (A1),D1
                MOVE.B      #15,D0
                MOVE.B      #16,D2
                TRAP        #15
                JMP         MODE_111_CONT                
*****************************************
*INITIALIZES JMP TABLE FOR MODE
*****************************************
REGISTER_JMP_TABLE 
    LEA REG_JMP_TABLE,A2
    MULU #$6,D3
    JSR 0(A2,D3)
    RTS
REG_JMP_TABLE 
    JMP     REG_000
    JMP     REG_001
    JMP     REG_010
    JMP     REG_011
    JMP     REG_100
    JMP     REG_101
    JMP     REG_110
    JMP     REG_111
    

**************************
* PRINT 0
**************************
REG_000
   CLR.L    D1
   CLR.L    D0
   MOVE.B   #'0',D1
   MOVE.B   #6,D0
   TRAP     #15
   RTS
**************************
* PRINT 1
**************************    
REG_001
   CLR.L    D1
   CLR.L    D0
   MOVE.B   #'1',D1
   MOVE.B   #6,D0
   TRAP     #15
   RTS
**************************
* PRINT 2
**************************   
REG_010
   CLR.L    D1
   CLR.L    D0
   MOVE.B   #'2',D1
   MOVE.B   #6,D0
   TRAP     #15
   RTS
**************************
* PRINT 3
**************************
REG_011
   CLR.L    D1
   CLR.L    D0
   MOVE.B   #'3',D1
   MOVE.B   #6,D0
   TRAP     #15
   RTS
**************************
* PRINT 4
**************************   
REG_100
   CLR.L    D1
   CLR.L    D0
   MOVE.B   #'4',D1
   MOVE.B   #6,D0
   TRAP     #15
   RTS
**************************
* PRINT 5
**************************   
REG_101
   CLR.L    D1
   CLR.L    D0
   MOVE.B   #'5',D1
   MOVE.B   #6,D0
   TRAP     #15
   RTS
**************************
* PRINT 6
**************************
REG_110
   CLR.L    D1
   CLR.L    D0
   MOVE.B   #'6',D1
   MOVE.B   #6,D0
   TRAP     #15
   RTS
**************************
* PRINT 7
**************************
REG_111
   CLR.L    D1
   CLR.L    D0
   MOVE.B   #'7',D1
   MOVE.B   #6,D0
   TRAP     #15
   RTS


**************************
* long
**************************
REG_LONG
   CLR.L    D1
   CLR.L    D0
   *MOVEA.L  
   MOVE.B   #'7',D1
   MOVE.B   #6,D0
   TRAP     #15
   RTS



**************************
* PRINT 7
**************************
REG_WORD
   CLR.L    D1
   CLR.L    D0
   MOVE.B   #'7',D1
   MOVE.B   #6,D0
   TRAP     #15
   RTS



**************************
* PRINT 7
**************************
REG_LITERAL
   CLR.L    D1
   CLR.L    D0
   MOVE.B   #'7',D1
   MOVE.B   #6,D0
   TRAP     #15
   RTS



*****************************************
* no suprises here, just prints a #
*****************************************   
PRINT_HASH_TAG
   CLR.L    D1
   CLR.L    D0
   MOVE.B   #'#',D1
   MOVE.B   #6,D0
   TRAP     #15
   RTS


*****************************************
* no suprises here, just prints a $
*****************************************   
PRINT_$
   CLR.L    D1
   CLR.L    D0
   MOVE.B   #'$',D1
   MOVE.B   #6,D0
   TRAP     #15
   RTS

*****************************************
* no suprises here, just prints a B
*****************************************   
PRINT_B
   CLR.L    D1
   CLR.L    D0
   MOVE.B   #'B',D1
   MOVE.B   #6,D0
   TRAP     #15
   RTS


*****************************************
* no suprises here, just prints a L
*****************************************   
PRINT_L
   CLR.L    D1
   CLR.L    D0
   MOVE.B   #'L',D1
   MOVE.B   #6,D0
   TRAP     #15
   RTS

*****************************************
* no suprises here, just prints a W
*****************************************   
PRINT_W
   CLR.L    D1
   CLR.L    D0
   MOVE.B   #'W',D1
   MOVE.B   #6,D0
   TRAP     #15
   RTS


*****************************************
* no suprises here, just prints a D
*****************************************   
PRINT_D
   CLR.L    D1
   CLR.L    D0
   MOVE.B   #'D',D1
   MOVE.B   #6,D0
   TRAP     #15
   RTS

*****************************************
* like the label says, it prints A 
*****************************************    
PRINT_A
   CLR.L    D1
   CLR.L    D0
   MOVE.B   #'A',D1
   MOVE.B   #6,D0
   TRAP     #15
   RTS   
   
*****************************************
* prints an open paranthese 
***************************************** 
PRINT_OPEN_PARAN
   CLR.L    D1
   CLR.L    D0
   MOVE.B   #'(',D1
   MOVE.B   #6,D0
   TRAP     #15
   RTS


*****************************************
* prints a close paranthese 
***************************************** 
PRINT_CLOSE_PARAN
   CLR.L    D1
   CLR.L    D0
   MOVE.B   #')',D1
   MOVE.B   #6,D0
   TRAP     #15
   RTS   
         

*****************************************
* prints a PLUS
***************************************** 
PRINT_PLUS
   CLR.L    D1
   CLR.L    D0
   MOVE.B   #'+',D1
   MOVE.B   #6,D0
   TRAP     #15
   RTS   

*****************************************
* prints a MINUS
***************************************** 
PRINT_MINUS
   CLR.L    D1
   CLR.L    D0
   MOVE.B   #'-',D1
   MOVE.B   #6,D0
   TRAP     #15
   RTS 

*****************************************
* prints a DOT
***************************************** 
PRINT_DOT
   CLR.L    D1
   CLR.L    D0
   MOVE.B   #'.',D1
   MOVE.B   #6,D0
   TRAP     #15
   RTS


*****************************************
* prints a SPACE
***************************************** 
PRINT_SPACE
   CLR.L    D1
   CLR.L    D0
   MOVE.B   #' ',D1
   MOVE.B   #6,D0
   TRAP     #15
   RTS 

*****************************************
* prints a COMMA
***************************************** 
PRINT_COMMA
   CLR.L    D1
   CLR.L    D0
   MOVE.B   #',',D1
   MOVE.B   #6,D0
   TRAP     #15
   RTS                
       
*****************************************
* condition to branch to opcode
* prints a line, increments by
***************************************** 
COMPARE
    JSR     PRINT_NEW_LINE
    ADD.L   #2,D7
    CMP     D6,D7
    BLT     OpCodeInterpreter
    
    BRA     END


   




    

*_____________PRINTING_______________________
*THE IDEA HERE IS THAT I PRINT A BYTE FROM OP-CODES,PRINT 3 BYTES FROM
*EFFECTIVE ADDRESSING AND REPEAT TILL I'VE FINISHED
*                MOVEA.L         #$00FFE000,A4
*                MOVE.L          #0,D5
*                MOVE.L          D0,D6   *HOLDS THE NUMBER OF INSTRUCTIONS, TO INDICATE HOW MANY TIMES TO PRINT
*                CLR.L           D0
*                MOVE.L          #3,D0
*PRINTINGLOOP    CMP.L           D5,D6   *IF NOTHING VALID HAS BEEN READ IN, THAT COUNTER SHOULD BE 0
*                BEQ             END
*                
*                
*           
*                MOVEA.L         A4,A1
*                MOVE.B          #14,D0          *PRINTS THE TRANSLATED OP-CODE
*                TRAP            #15
*                *LEAVING SPACE TO PRINT TRANSLATED EA
*
*                               
*                
*INCREMENT       CMP.B           #$00,(A4)         *MOVES A4 ADDRESS TO THE NEXT TRANSLATED OP-CODE
*                BEQ             END_INSTRUCTION   *BY MOVING A4'S ADDRESS UP BYTE BY BYTE TILL AFTER 00, THE BREAK POINT
*                CMP.B           #$FF,(A4)
*                BEQ             END_INSTRUCTION
*                ADDA.L          #1,A4           
*                JMP             INCREMENT
*                
*END_INSTRUCTION   
*                ADDA.L          #1,A4         
*                ADD.L           #$1,D5
*                JMP             PRINTINGLOOP       
                
                
                
                
                 
                 
               

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
    lsl.w   0 
    lsl.w   0                      
    SIMHALT             ; halt simulator

* Put variables and constants here
CR      EQU     $0D
LF      EQU     $0A

NEW_LINE DC.B   '_',CR,LF

INTRO   DC.B    'They call us Lil Bits.',CR,LF
        DC.B    'You abouts to get',CR,LF
        DC.B    'disassmbled',CR,LF,0
        
SUB_MSG         DC.B    'SUB.',0
ADD_MSG         DC.B    'ADD.',0
ADDI_MSG        DC.B    'ADDI.',0
ADDQ_MSG        DC.B    'ADDQ.',0
DIVU_MSG        DC.B    'DIVU.W ',0

MOVEB_MSG       DC.B    'MOVE.B ',0
MOVEL_MSG       DC.B    'MOVE.L ',0
MOVEW_MSG       DC.B    'MOVE.W ',0

MOVE_MSG        DC.B    'MOVE.',0
MOVEA_MSG       DC.B    'MOVEA ',0
MOVEAW_MSG      DC.B    'MOVEA.W ',0
MOVEM_MSG       DC.B    'MOVEM ',0
MOVEQ_MSG       DC.B    'MOVEQ ',0

NOP_MSG         DC.B    'NOP ',0
CLR_MSG         DC.B    'CLR ',0
OR_MSG          DC.B    'OR ',0
CMP_MSG         DC.B    'CMP.',0

BCC_MSG         DC.B    'BCC',0
BGT_MSG         DC.B    'BGT',0
BLE_MSG         DC.B    'BLE',0

JSR_MSG         DC.B    'JSR ',0
RTS_MSG         DC.B    'RTS ',0
LEA_MSG         DC.B    'LEA ',0

FROM_MSG        DC.B    'FROM ',0

BLANK DC.B    '',0

RESTART_MSG DC.B    'INVALID PUT, WOULD YOU LIKE TO END THE PROGRAM OR TRY AGAIN? (ENTER Y TO RESTART)',0
START_ADDR  DC.B 'Enter Starting Address (Between $00004000 && $00FF0000):',0
END_ADDR  DC.B 'Enter Ending Address (Between $00004000 && $00FF0000):',0
INVALID_INPUT_MES    DC.B    'INVALID INPUT, TRY AGAIN',CR,LF,0
    END    START        ; last line of source






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
