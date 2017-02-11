*-----------------------------------------------------------
* Title      :  Addressing
* Written by :  John Fitzgerald
* Date       :  2-10-17
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
*Address Register Indirect with Post incrementing   (MOVE.W (A0)+, D0)
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
** TODO - determine registers to use (for data and tables)
**Clear data register(s) previously used
**FIRST EA
        *MOVE.B  #',', ()+     ; move , character to
**SECOND EA

*-----------------------------------------------------------
* Mode Table
*-----------------------------------------------------------
MODE_TABLE
        JMP     MODE_DRD
        JMP     MODE_ARD     
        JMP     MODE_ARI
        JMP     MODE_ARIPI     
        JMP     MODE_ARIPD
        JMP     MODE_ID_AA 

*-----------------------------------------------------------
* Mode: 000     DN         
* [Xn: reg]   
* Data Register Direct
*-----------------------------------------------------------
MODE_DRD
        *MOVE.B  #'D',        ; move D character to
        ** TODO
        **determine Register
        **set Register
        *RTS
        
*-----------------------------------------------------------
* Mode: 001     AN         
* [Xn: reg]   
* Address Register Direct
*-----------------------------------------------------------
MODE_ARD
        *MOVE.B  #'A', ()+    ; move A character to
        ** TODO
        **determine Register
        **set Register
        *RTS
        
*-----------------------------------------------------------
* Mode: 010     (AN)        
* [Xn: reg]   
* Address Register Indirect
*-----------------------------------------------------------
MODE_ARI
        *MOVE.B #'(', ()+     ; move ( character to 
        *MOVE.B #'A', ()+     ; move A character to
        ** TODO 
        **determine Register
        **set Register
        *MOVE.B #')', ()+     ; move ) character to
        *RTS
        
*-----------------------------------------------------------
* Mode: 011     (AN)+       
* [Xn: reg]   
* Address Register Indirect with Post incrementing
*-----------------------------------------------------------
MODE_ARIPI
        *MOVE.B #'(', ()+     ; move ( character to 
        *MOVE.B #'A', ()+     ; move A character to
        ** TODO 
        **determine Register
        **set Register
        *MOVE.B #')', ()+     ; move ) character to
        *MOVE.B #'+', ()+     ; move + character to
        *RTS
        
*-----------------------------------------------------------
* Mode: 100     -(AN)       
* [Xn: reg]   
* Address Register Indirect with Pre decrementing
*-----------------------------------------------------------
MODE_ARIPD
        *MOVE.B #'-', ()+     ; move - character to 
        *MOVE.B #'(', ()+     ; move ( character to
        *MOVE.B #'A', ()+     ; move A character to
        ** TODO         
        **determine Register
        **set Register
        *MOVE.B #')', ()+     ; move ) character to
        *RTS
        
*-----------------------------------------------------------
* Mode: 111     (xxx).L; (xxx).W; #<data> 
* [Xn: 001; Xn: 000; Xn: 100]   
* Absolute Long/Word Address and Immediate Data
*-----------------------------------------------------------
MODE_ID_AA
        ** TODO 
        **determine Register
        **set Register through separate table: REG_TABLE_ID_AA
        *RTS

*-----------------------------------------------------------
* Register Table for: 
* numbers 0-7
*-----------------------------------------------------------
REG_TABLE
        JMP     REG_ZERO
        JMP     REG_ONE
        JMP     REG_TWO
        JMP     REG_THREE
        JMP     REG_FOUR
        JMP     REG_FIVE
        JMP     REG_SIX
        JMP     REG_SEVEN

*-----------------------------------------------------------
* Register Table for: 
* Absolute Long/Word Address and Immediate Data
*-----------------------------------------------------------
REG_TABLE_ID_AA
        JMP     REG_ABS_LONG
        JMP     REG_ABS_WORD
        JMP     REG_IMM_DATA
        ** TODO - include invalid options

*-----------------------------------------------------------
* Register Zero  [000]
*-----------------------------------------------------------       
REG_ZERO
        ** TODO 
        *MOVE.B #'0', ()+     ; move 0 character to 
        *RTS
    
*-----------------------------------------------------------
* Register One   [001]
*-----------------------------------------------------------       
REG_ONE
        ** TODO 
        *MOVE.B #'1', ()+     ; move 1 character to 
        *RTS
    
*-----------------------------------------------------------
* Register Two   [010]
*-----------------------------------------------------------       
REG_TWO
        ** TODO 
        *MOVE.B #'2', ()+     ; move 2 character to 
        *RTS
    
*-----------------------------------------------------------
* Register Three [011]
*-----------------------------------------------------------       
REG_THREE
        ** TODO 
        *MOVE.B #'3', ()+     ; move 3 character to 
        *RTS
    
*-----------------------------------------------------------
* Register Four  [100]
*-----------------------------------------------------------       
REG_FOUR
        ** TODO 
        *MOVE.B #'4', ()+     ; move 4 character to 
        *RTS
    
*-----------------------------------------------------------
* Register Five  [101]
*-----------------------------------------------------------       
REG_FIVE
        ** TODO 
        *MOVE.B #'5', ()+     ; move 5 character to 
        *RTS
    
*-----------------------------------------------------------
* Register Six   [110]
*-----------------------------------------------------------       
REG_SIX
        ** TODO 
        *MOVE.B #'6', ()+     ; move 6 character to 
        *RTS
    
*-----------------------------------------------------------
* Register Seven [111]
*-----------------------------------------------------------       
REG_SEVEN
        ** TODO 
        *MOVE.B #'7', ()+     ; move 7 character to 
        *RTS

*-----------------------------------------------------------
* Long      [001]
*-----------------------------------------------------------  
REG_ABS_LONG
        *MOVE.B #'$', ()+     ; move $ character to
        ** TODO - finish branch options
        *RTS

*-----------------------------------------------------------
* Word      [000]
*----------------------------------------------------------- 
REG_ABS_WORD
        *MOVE.B #'$', ()+     ; move $ character to
        ** TODO - finish branch options
        *RTS
        
*-----------------------------------------------------------
* Immediate [100]
*----------------------------------------------------------- 
REG_IMM_DATA
        *MOVE.B #'#', ()+     ; move # character to
        *MOVE.B #'$', ()+     ; move $ character to        
        ** TODO - finish branch options
        *RTS

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
