*-----------------------------------------------------------
* Title      :  Addressing
* Written by :  John Fitzgerald
* Date       :  2-5-17
* Description:  Decode EA from Opcode and prepare operands 
*               for display.

*Effective Addressing Modes:
*
*Data Register Direct                               (MOVE.W #$1234, D0)
*Address Register Direct                            (MOVEA.W $ABCD, A0)
*Address Register Indirect                          (MOVE.W (A0), D0)
*Immediate Data                                     (MOVE.W #$1234, $8000)
*Address Register Indirect with Post incrementing   (MOVE.W (A0)+, D0)
*Address Register Indirect with Pre decrementing    (MOVE.W -(A0), D0)
*Absolute Long Address                              (MOVE.W $1234.W, $8000.L)
*Absolute Word Address                              (MOVE.W $1234.W, $8000.W)

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

    MOVE.W #$1234, $1234.W
    MOVE.W $1234.W, $8000.L

    MOVEA.W $ABCD, A1

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
