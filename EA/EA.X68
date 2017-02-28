*-----------------------------------------------------------
* Title      :  EA
* Written by :  John Fitzgerald
* Date       :  2-24-17
* Description:  Decode EA from Opcode and prepare operands 
*               for display.

*Effective Addressing Modes:

*Data Register Direct                               (MOVE.W #$1234, D0)
    * MODE: 000  Xn: reg
*Address Register Direct                            (MOVEA.W $ABCD, A0)
    * MODE: 001  Xn: reg
*Address Register Indirect                          (MOVE.W (A0), D0)
    * MODE: 010  Xn: reg
*Immediate Data                                     (MOVE.W #$1234, $8000)
    * MODE: 111  Xn: 100
*Address Register Indirect with Post incrementing   (MOVE.W (A1)+, D0)
    * MODE: 011  Xn: reg
*Address Register Indirect with Pre decrementing    (MOVE.W -(A0), D0)
    * MODE: 100  Xn: reg
*Absolute Long Address                              (MOVE.W $1234.W, $8000.L)
    * MODE: 111  Xn: 001
*Absolute Word (Short) Address                      (MOVE.W $1234.W, $8000.W)
    * MODE: 111  Xn: 000
    
*Instructions:
*
*NOP
*MOVE
*MOVEA
*MOVEQ
*MOVEM
*ADD
*ADDA
*ADDI
*ADDQ
*SUB
*MULS
*DIVU
*LEA
*CLR
*AND
*OR
*LSL
*LSR
*ASR
*ASL
*ROL
*ROR
*CMP
*Bcc (BCC, BGT, BLE)
*JSR
*RTS
*-----------------------------------------------------------

*-----------------------------------------------------------
* Beginning of EQUates section, just like #define in C.
*-----------------------------------------------------------
COUNTER_PRINT     DS.L    1
COUNTER_EA        DS.B    1

*-----------------------------------------------------------
* Beginning of code segment.
*-----------------------------------------------------------
    ORG    $1000
    
* Put program code here
START

*    MOVE.W #$1234, $1234.W
*    MOVE.W $1234.W, $8000.L
*
*    MOVEA.W $ABCD, A1

*-----------------------------------------------------------
* Start EA
*-----------------------------------------------------------
FIRST_EA
        MOVE.B  #',',   (A1)+           ; move , character to A1
SECOND_EA
        MOVE.W  #00,    (A1)+           ; #00 indicates end of buffer
        ADD.L   #1,     COUNTER_PRINT   ; increment counter by one

*-----------------------------------------------------------
* Mode Table
*-----------------------------------------------------------
EA_MODE_TABLE
        JMP     EA_MODE_DRD        ; Data Register Direct
        JMP     EA_MODE_ARD        ; Address Register Direct
        JMP     EA_MODE_ARI        ; Address Register Indirect
        JMP     EA_MODE_ARIPI      ; Address Register Indirect with Post Incrementing
        JMP     EA_MODE_ARIPD      ; Address Register Indirect with Pre Decrementing
        JMP     EA_MODE_ID_AA      ; Absolute Long/Word Address and Immediate Data

*-----------------------------------------------------------
* Mode: 000     DN         
* [Xn: reg]   
* Data Register Direct
*-----------------------------------------------------------
EA_MODE_DRD
        MOVE.B  #'D', (A1)+       ; move D character to A1
        ** TODO: Shift bits from A0 and store in D2
        LEA     EA_REG_TABLE, A3
        MULU    #6, D2
        JMP     0(A3, D2)
        RTS
        
*-----------------------------------------------------------
* Mode: 001     AN         
* [Xn: reg]   
* Address Register Direct
*-----------------------------------------------------------
EA_MODE_ARD
        MOVE.B  #'A', (A1)+    ; move A character to
        ** TODO: Shift bits from A0 and store in D2
        LEA     EA_REG_TABLE, A3
        MULU    #6, D2
        JMP     0(A3, D2)
        RTS
        
*-----------------------------------------------------------
* Mode: 010     (AN)        
* [Xn: reg]   
* Address Register Indirect
*-----------------------------------------------------------
EA_MODE_ARI
        MOVE.B #'(', (A1)+     ; move ( character to A1
        MOVE.B #'A', (A1)+     ; move A character to A1
        ** TODO: Shift bits from A0 and store in D2
        LEA     EA_REG_TABLE, A3
        MULU    #6, D2
        JMP     0(A3, D2)
        MOVE.B #')', (A1)+     ; move ) character to A1
        RTS
        
*-----------------------------------------------------------
* Mode: 011     (AN)+       
* [Xn: reg]   
* Address Register Indirect with Post Incrementing
*-----------------------------------------------------------
EA_MODE_ARIPI
        MOVE.B #'(', (A1)+     ; move ( character to A1
        MOVE.B #'A', (A1)+     ; move A character to A1
        ** TODO: Shift bits from A0 and store in D2
        LEA     EA_REG_TABLE, A3
        MULU    #6, D2
        JMP     0(A3, D2)
        MOVE.B #')', (A1)+     ; move ) character to A1
        MOVE.B #'+', (A1)+     ; move + character to A1
        RTS
        
*-----------------------------------------------------------
* Mode: 100     -(AN)       
* [Xn: reg]   
* Address Register Indirect with Pre Decrementing
*-----------------------------------------------------------
EA_MODE_ARIPD
        MOVE.B #'-', (A1)+     ; move - character to A1
        MOVE.B #'(', (A1)+     ; move ( character to A1
        MOVE.B #'A', (A1)+     ; move A character to A1
        ** TODO: Shift bits from A0 and store in D2
        LEA     EA_REG_TABLE, A3
        MULU    #6, D2
        JMP     0(A3, D2)
        MOVE.B #')', (A1)+     ; move ) character to A1
        RTS
        
*-----------------------------------------------------------
* Mode: 111     (xxx).L; (xxx).W; #<data> 
* [Xn: 001; Xn: 000; Xn: 100]   
* Absolute Long/Word Address and Immediate Data
*-----------------------------------------------------------
EA_MODE_ID_AA
        ** TODO: Shift bits from A0 and store in D2
        LEA     EA_REG_TABLE, A3
        MULU    #6, D2
        JMP     0(A3, D2)
        **set Register through separate table: EA_REG_TABLE_ID_AA
        RTS

*-----------------------------------------------------------
* Register Table for: 
* numbers 0-7
*-----------------------------------------------------------
EA_REG_TABLE
        JMP     EA_REG_ZERO
        JMP     EA_REG_ONE
        JMP     EA_REG_TWO
        JMP     EA_REG_THREE
        JMP     EA_REG_FOUR
        JMP     EA_REG_FIVE
        JMP     EA_REG_SIX
        JMP     EA_REG_SEVEN

*-----------------------------------------------------------
* Register Table for: 
* Absolute Long/Word Address and Immediate Data
*-----------------------------------------------------------
EA_REG_TABLE_ID_AA
        JMP     EA_REG_ABS_LONG
        JMP     EA_REG_ABS_WORD
        JMP     EA_REG_IMM_DATA
        ** TODO - include invalid options

*-----------------------------------------------------------
* Register Zero  [000]
*-----------------------------------------------------------       
EA_REG_ZERO
        MOVE.B #'0', (A1)+     ; move 0 character to A1
        RTS
    
*-----------------------------------------------------------
* Register One   [001]
*-----------------------------------------------------------       
EA_REG_ONE
        MOVE.B #'1', (A1)+     ; move 1 character to A1
        RTS
    
*-----------------------------------------------------------
* Register Two   [010]
*-----------------------------------------------------------       
EA_REG_TWO
        MOVE.B #'2', (A1)+     ; move 2 character to A1
        RTS
    
*-----------------------------------------------------------
* Register Three [011]
*-----------------------------------------------------------       
EA_REG_THREE
        MOVE.B #'3', (A1)+     ; move 3 character to A1
        RTS
    
*-----------------------------------------------------------
* Register Four  [100]
*-----------------------------------------------------------       
EA_REG_FOUR
        MOVE.B #'4', (A1)+     ; move 4 character to A1
        RTS
    
*-----------------------------------------------------------
* Register Five  [101]
*-----------------------------------------------------------       
EA_REG_FIVE
        MOVE.B #'5', (A1)+     ; move 5 character to A1
        RTS
    
*-----------------------------------------------------------
* Register Six   [110]
*-----------------------------------------------------------       
EA_REG_SIX
        MOVE.B #'6', (A1)+     ; move 6 character to A1
        RTS
    
*-----------------------------------------------------------
* Register Seven [111]
*-----------------------------------------------------------       
EA_REG_SEVEN
        MOVE.B #'7', (A1)+     ; move 7 character to A1
        RTS

*-----------------------------------------------------------
* Long      [001]
*-----------------------------------------------------------  
EA_REG_ABS_LONG
        MOVE.B #'$', (A1)+     ; move $ character to A1
        ** TODO - finish branch options
        RTS

*-----------------------------------------------------------
* Word      [000]
*----------------------------------------------------------- 
EA_REG_ABS_WORD
        MOVE.B #'$', (A1)+     ; move $ character to A1
        ** TODO - finish branch options
        RTS
        
*-----------------------------------------------------------
* Immediate [100]
*----------------------------------------------------------- 
EA_REG_IMM_DATA
        MOVE.B #'#', (A1)+     ; move # character to A1
        MOVE.B #'$', (A1)+     ; move $ character to A1       
        ** TODO - finish branch options
        RTS

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
