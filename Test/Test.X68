*-----------------------------------------------------------
 -* Title      :  Test
 -* Written by :  John Fitzgerald, Shayan Raouf, Peter Van
 -* Date       :  2-5-17
 -* Description:  Test data to be loaded into memory
 +* Title      :
 +* Written by :
 +* Date       :
 +* Description:
  *-----------------------------------------------------------
 +    ORG    $1000
 +START:                  ; first instruction of program
  
 -*-----------------------------------------------------------
 -* Beginning of EQUates section, just like #define in C.
 -*-----------------------------------------------------------
 +* Put program code here
  
 +    ORG    $7000
  
  
 -*-----------------------------------------------------------
 -* Beginning of code segment.
 -*-----------------------------------------------------------
 -    ORG    $8000
 +********************************************************
 +* LEGAL LEA Tests                                      *     
 +*******************************************************
 +    LEA     (A1),A0         (An),An
 +    LEA     WVAR,A1        (xxx).W,An
 +    LEA     LVAR,A2        (xxx).L,An
 +    LEA     $1,A4
 +    LEA     $123456,A7
 +*******************************************************
 +* LEGAL JSR Tests                                      *     
 +*******************************************************
 +    JSR     JUMP1
 +    JSR     JUMP2
 +    JSR     (A1)        (An)
 +    JSR     WVAR       (xxx).W
 +    JSR     LVAR       (xxx).L   
 +*******************************************************
 +* LEGAL RTS Tests                                     *     
 +*******************************************************
 +JUMP1    *For JSR & RTS test
 +        MOVE.B  D1, D1
 +        RTS
 +JUMP2   RTS *For JSR & RTS test
 +*******************************************************
 +* LEGAL CLR Tests                                      *     
 +*******************************************************
 +    CLR       D0    
 +    CLR       (A2)        (An)
 +    CLR       (A3)+       (An)+
 +    CLR.B     (A7)+       (An)+
 +    CLR.W     D5
 +    CLR.L     -(A4)       -(An)
 +    CLR       WVAR       (xxx).W
 +    CLR       LVAR       (xxx).L
 +    CLR       $1
 +    CLR.B     D3
 +    CLR.B     (A2)
 +    CLR.W     $23
 +    CLR.L     D3  
 +    CLR.L     (A5)+
 +    CLR.L     $1235
 +*******************************************************
 +* LEGAL MOVEQ Tests                                   *     
 +*******************************************************
 +    MOVEQ       #$23,D6
 +    MOVEQ       #$12,D1
 +    MOVEQ       #$23,D3
 +    MOVEQ       #$12,D4
      
 -* Put program code here
 -START
 +*******************************************************
 +* LEGAL MOVEA Tests                                   *     
 +*******************************************************
 +    MOVEA.W       D2,A6
 +    MOVEA.W       A2,A1
 +    MOVEA.W       (A2),A3
 +    MOVEA.W       (A2)+,A4
 +    MOVEA.W       -(A3),A4  
 +    MOVEA.W       -(A3),A4
 +    MOVEA.W       #2345,A6
 +    MOVEA.W       $00002345,A6 
 +    MOVEA.L      $00002345,A6 
 +    MOVEA.L      $00008345,A6 
 +    MOVEA.L      $FFFF8345,A6 
 +*******************************************************
 +* LEGAL CMP Tests                                      *     
 +*******************************************************
 +    CMP.B       D1,D0       Dn,Dn
 +    CMP.W       A2,D1       An,Dn
 +    CMP.L       (A3),D2     (An),Dn
 +    CMP.B       (A4)+,D3    (An)+,Dn
 +    CMP.W       -(A5),D4    -(An),Dn
 +    CMP.L       WVAR,D5    (xxx).W,Dn
 +    CMP.B       LVAR,D6    (xxx).L,Dn
 +    CMP.L       #VBIN1,D7   #<data>,Dn
 +
 +    CMPA.W      D0,A0       Dn,An
 +    CMPA.L      A0,A1       An,An
 +    CMPA.W      (A1),A2     (An),An
 +    CMPA.L      (A2)+,A3    (An)+,An
 +    CMPA.W      -(A3),A4    -(An),An
 +    CMPA.L      WVAR,A5    (xxx).W,An
 +    CMPA.W      LVAR,A6    (xxx).L,An
 +    CMPA.L      #1234,A7    #<data>,An
 +
 +********************************************************
 +* LEGAL CMP/CMPA and Bcc Tests                         *     
 +********************************************************
 +    CMP.B       D1,D0       Dn,Dn
 +    BGT         B1a
 +B1a    
 +    CMP.W       A2,D1       An,Dn
 +    BLE         B2a
 +B2a
 +    CMP.L       (A3),D2     (An),Dn
 +    BVS         B3
 +B3
 +    CMP.B       (A4)+,D3    (An)+,Dn
 +    BGT         B4
 +B4
 +    CMP.W       -(A5),D4    -(An),Dn
 +    BGT         B5
 +B5
 +    CMP.L       WVAR,D5    (xxx).W,Dn
 +    CMP.B       LVAR,D6    (xxx).L,Dn
 +    CMP.L       #VBIN1,D7   #<data>,Dn
 +
 +    CMPA.W      D0,A0       Dn,An
 +    CMPA.L      A0,A1       An,An
 +    BGT         Ba1
 +Ba1
 +    CMPA.W      (A1),A2     (An),An
 +    BLE         Ba2
 +Ba2
 +    CMPA.L      (A2)+,A3    (An)+,An
 +    BGT         Ba3
 +Ba3
 +    CMPA.W      -(A3),A4    -(An),An
 +    BVS         Ba4
 +Ba4
 +    CMPA.L      WVAR,A5    (xxx).W,An
 +    CMPA.W      LVAR,A6    (xxx).L,An
 +    CMPA.L      #1234,A7    #<data>,An
 +*
 +********************************************************
 +* LEGAL LSL Tests                                      *     
 +********************************************************
 +    LSL.B       D0,D1       Dx,Dy
 +    LSL.W       D2,D2       
 +    LSL.L       #4,D2       #<data>,Dy
 +    LSL.W       (A2)        (An)
 +    LSL.W       (A3)+       (An)+
 +    LSL.W       -(A4)       -(An)
 +    LSL.W       WVAR       (xxx).W
 +    LSL.W       LVAR       (xxx).L
 +
 +********************************************************
 +* LEGAL ROL Tests                                      *     
 +********************************************************
 +    ROL.B       D0,D1       Dx,Dy
 +    ROL.W       D2,D2       
 +    ROL.L       #4,D2       #<data>,Dy
 +    ROL.W       (A2)        (An)
 +    ROL.W       (A3)+       (An)+
 +    ROL.W       -(A4)       -(An)
 +    ROL.W       WVAR       (xxx).W
 +    ROL.W       LVAR       (xxx).L
 +
 +********************************************************
 +* LEGAL ROR Tests                                      *     
 +********************************************************
 +    ROR.B       D0,D1       Dx,Dy
 +    ROR.W       D2,D2       
 +    ROR.L       #4,D2       #<data>,Dy
 +    ROR.W       (A2)        (An)
 +    ROR.W       (A3)+       (An)+
 +    ROR.W       -(A4)       -(An)
 +    ROR.W       WVAR       (xxx).W
 +    ROR.W       LVAR       (xxx).L
 +
 +********************************************************
 +* LEGAL ASR Tests                                      *     
 +********************************************************
 +    ASR.B       D0,D1       Dx,Dy
 +    ASR.W       D2,D2       
 +    ASR.L       #4,D2       #<data>,Dy
 +    ASR.W       (A2)        (An)
 +    ASR.W       (A3)+       (An)+
 +    ASR.W       -(A4)       -(An)
 +    ASR.W       WVAR       (xxx).W
 +    ASR.W       LVAR       (xxx).L
 +
 +********************************************************
 +* LEGAL SUB Tests                                      *     
 +********************************************************
 +    SUB.B       D0,D1       Dn,Dn
 +    SUB.W       D2,D3 
 +    SUB.L       A1,D0       An,Dn
 +    SUB.W       A4,D3
 +    SUB.B       (A3),D3     (An),Dn
 +    SUB.L       (A2),D0
 +    SUB.B       (A0)+,D1    (An)+,Dn
 +    SUB.W       (A3)+,D2
 +    SUB.L       -(A1),D2    -(An),Dn
 +    SUB.B       -(A2),D1    
 +    SUB.W       WVAR,D0    (xxx).W,Dn
 +    SUB.L       VBIN1,D2    (xxx).L,Dn
 +    SUB.W       $1,D5
 +    SUB.L       $54FFF,D7
 +    SUB.W       D0,A1       Dn,An
 +    SUB.L       D3,A4
 +    SUB.B       D3,(A3)     Dn,(An)
 +    SUB.W       D0,(A2)
 +    SUB.L       D1,(A0)+    Dn,(An)+
 +    SUB.B       D2,(A3)+
 +    SUB.W       D2,-(A1)     Dn,-(An)
 +    SUB.L       D1,-(A2)
 +    SUB.B       D0,WVAR    Dn,(xxx).W
 +    SUB.W       D2,VBIN1    Dn,(xxx).L
 +    SUB.L       D3,LVAR    Dn,(xxx).L
 +*******************************************************
 +* LEGAL DIVU Tests                                     *     
 +*******************************************************
 +    DIVU.W      D1,D2           Dn,Dn
 +    DIVU.W      (A1),D2         (An),Dn
 +    DIVU.W      (A2)+,D3        (An)+,Dn
 +    DIVU.W      -(A3),D4        -(An),Dn
 +    DIVU.W      WVAR,D5        (xxx).W,Dn
 +    DIVU.W      LVAR,D6        (xxx).L,Dn
 +    DIVU.W      #$FF00,D7       #<data>,Dn
 +*******************************************************
 +* LEGAL MULS Tests                                     *     
 +*******************************************************
 +    MULS.W      D0,D1           Dn,Dn
 +    MULS      (A0),D1         (An),Dn
 +    MULS.W      (A2)+,D2        (An)+,Dn
 +    MULS.W      -(A3),D3        -(An),Dn
 +    MULS.W      WVAR,D4        (xxx).W,Dn
 +    MULS.W      LVAR,D5        (xxx).L,Dn
 +    MULS.W      #$234,D6       #<data>,Dn
 +    MULS      D0,D7
 +********************************************************
 +* LEGAL Move Tests                                     *     
 +********************************************************
 +    MOVE.L $1234,$5678
 +    MOVE.W $1234,$12345678
 +    MOVE.W $12345678, $246810
 +    MOVE.W #$123,D6
 +    MOVE.L #$2468135,$54789
 +    MOVE.L #$1234,D3
 +    MOVE.L  D1,D2
 +    MOVE.W  A4, (A5)
 +    MOVE.L  (A5)+,-(A5)
 +    MOVE.B  BVAR, D0           <ea>,Dn
 +    MOVE.W  WVAR, D1
 +    MOVE.L  #LVAR, D2
 +    MOVE.B  BVAR, (A0)         <ea>,(An)
 +    MOVE.W  WVAR, (A1)
 +    MOVE.L  #LVAR, (A2)
 +    MOVE.B  #BVAR, (A3)+       <ea>,(An)+
 +    MOVE.W  WVAR, (A4)+
 +    MOVE.L  LVAR, (A5)+
 +    MOVE.B  BVAR, -(A0)        <ea>,-(An)
 +    MOVE.W  WVAR, -(A2)
 +    MOVE.L  #LVAR, -(A4)
 +    MOVE.B  BVAR, WVAR        <ea>,(xxx).W
 +    MOVE.W  WVAR, LVAR        <ea>,(xxx).L
 +    MOVE.L  ZVAR, $00F00200    <ea>,#<data>
 +*******************************************************
 +* LEGAL ADD Tests                                      *     
 +*******************************************************
 +    ADD.W       LVAR,D1    (xxx).L,Dn
 +    ADD.B       WVAR,D0    (xxx).W,Dn
 +    ADD.B       D0,D1       Dn,Dn
 +    ADD.W       D1,D2
 +    ADD.L       D2,D3
 +    ADD.W       A1,D1       An,Dn
 +    ADD.L       A2,D2
 +    ADD.L       A3,D5
 +    ADD.B       (A0),D2     (An),Dn
 +    ADD.W       (A1),D3
 +    ADD.L       (A2),D4
 +    ADD.B       (A3)+,D0    (An)+,Dn
 +    ADD.W       (A4)+,D1
 +    ADD.L       (A5)+,D2
 +    ADD.B       -(A0),D3    -(An),Dn
 +    ADD.W       -(A1),D4    
 +    ADD.L       -(A2),D5
 +********************************************************
 +* LEGAL ADDA Tests                                      *     
 +********************************************************
 +    ADDA.W       D0,A0           Dn,An
 +    ADDA.L       D1,A1   
 +    ADDA.L       A2,A3           An,An
 +    ADDA.W       A3,A4
 +    ADDA.W       (A0),A0         (An),An
 +    ADDA.L       (A2),A2
 +    ADDA.L       (A1)+,A1        (An)+,An
 +    ADDA.W       (A2)+,A2
 +    ADDA.W       -(A3),A2        -(An),An
 +    ADDA.L       -(A2),A3
 +    ADDA.L       WVAR,A0        (xxx).W,An
 +    ADDA.W       WVAR,A2    
 +    ADDA.W       LVAR,A3        (xxx).L,An
 +    ADDA.L       LVAR,A4  
 +    ADDA.W       #$23,A7
 +    ADDA.L       #LVAR,A1
 +    ADDA.L       #VBIN1,A5       #<data>,An
 +*******************************************************
 +* LEGAL ADDQ Tests                                   *     
 +*******************************************************
 +    ADDQ      #3,D7
 +    ADDQ      #3,A4
 +    ADDQ      #3,(A4)
 +    ADDQ      #3,(A3)+
 +    ADDQ      #3,-(A3)
 +    ADDQ      #3,$0001
 +    ADDQ      #3,$FFFF
 +    ADDQ      #3,$FFFF8432
 +    
 +*******************************************************
 +* LEGAL OR Tests                                   *     
 +*******************************************************
 +    OR          D3,D4
 +    OR          (A3),D4
 +    OR          (A3)+,D4
 +    OR          -(A3),D4
 +    OR          $8000,D4
 +    OR          $1111,D4
 +    OR          #1123,D4
 +    
 +    OR          D4,D3
 +    OR          D4,(A3)
 +    OR          D4,(A3)+
 +    OR          D4,-(A3)
 +    OR          D4,$8000
 +    OR          D4,$1111
 +*******************************************************
 +* LEGAL LSL Tests                                   *     
 +*******************************************************
 +    LSL.B       D1,D2
 +    LSL.B       #2,D3          
 +    LSL.W       (A3)
 +    LSL.W       (A3)+   
 +    LSL.W       -(A3)
 +    *LSL.L       $3000,D4
 +    *LSL.L       $8000,D4
 +*******************************************************
 +* LEGAL LSR Tests                                   *     
 +*******************************************************
 +    LSR.B       D1,D2
 +    LSR.B       #2,D3          
 +    LSR.W       (A3)
 +    LSR.W       (A3)+  
 +    LSR.W       -(A3)
 +    *LSR.L       $3000,D4
 +    *LSR.L       $8000,D4
 +*******************************************************
 +* LEGAL ASR Tests                                   *     
 +*******************************************************
 +    ASR.B       D1,D2
 +    ASR.B       #2,D3          
 +    ASR.W       (A3)
 +    ASR.W       (A3)+  
 +    ASR.W       -(A3)
 +*******************************************************
 +* LEGAL ASL Tests                                   *     
 +*******************************************************
 +    ASL.B       D1,D2
 +    ASL.B       #2,D3          
 +    ASL.W       (A3)
 +    ASL.W       (A3)+   
 +    ASL.W       -(A3)
 +*******************************************************
 +* LEGAL ADDI Tests                                    *
 +*******************************************************
 +    ADDI.B      #BVAR,D0       #<data>,Dn
 +    ADDI.W      #10,D1
 +    ADDI.L      #LVAR,(A1)     #<data>,An
 +    ADDI.B      #$12,(A3)
 +    ADDI.W      #WVAR,(A2)+    #<data>,(An)+
 +    ADDI.L      #VBIN1,(A4)+
 +    ADDI.B      #$FF, -(A0)     #<data>,-(An)
 +    ADDI.W      #$1222,-(A5)
 +    ADDI.L      #WVAR,WVAR    #<data>,(xxx).W
 +    ADDI.B      #$11, LVAR     #<data>,(xxx).L
 +    ADDI.L      #$12345,D7     #<data>,Dn
 +
 +
 +*******************************************************
 +* LEGAL MOVEQ Tests                                   *     
 +*******************************************************
 +    MOVEQ       #$23,D6
 +    MOVEQ       #$12,D1
 +    MOVEQ       #$23,D3
 +    MOVEQ       #$12,D4
 +
 +********************************************************
 +** LEGAL MOVEM Tests                                    *
 +********************************************************
 +    MOVEM.W     D1-D3/A0, (A0)      <list>,(An)
 +    MOVEM.L     D1-D3/A1, (A6)      <list>,(An)
 +    MOVEM.W     D4/A4-A7,BVAR
 +    MOVEM.W     D4/A7-A4,BVAR
 +    MOVEM.L     D3-D7/A6, (A4)
 +    MOVEM.L      D0/A0, $12345
 +    MOVEM.W      D7/A7, $12345
 +    MOVEM.W     D1/A0-A1, BVAR     <list>,(xxx).W
 +    MOVEM.L     D0-D4/A0-A4,(A1)  <list>,-(An)
 +    MOVEM.W     A0/D7, (A7)
 +    MOVEM.L     D2-D4/A4, LVAR     <list>,(xxx).L
 +    MOVEM.W     D0-D7/A0-A7, LVAR
 +    MOVEM.W     (A1),D1-D3/A1       (An),<list>
 +    MOVEM.W     BVAR, D1/A0-A1     (xxx).W,<list>
 +    MOVEM.L     (A2)+, D0-D4/A0-A4  (An)+,<list>
 +    MOVEM.L     (A5)+, D2-D4/A4     (xxx).L,<list>
 +    MOVEM.W     LVAR, D0/A0     (xxx).L,<list>
 +    MOVEM.W     BVAR, D0/A0-A7     (xxx).L,<list>
 +    MOVEM.L     WVAR, D0-D7/A0     (xxx).L,<list>
 +     MOVEM.L     D0-D7/A0,-(A3)
 +     MOVEM.W     D1-D4/A6-A7,-(A4)
 +
 +*******************************************************
 +*BAD Instructions
 +*******************************************************
 +   MOVE.B  BVAR, -(SP)        <ea>, -(SP)
 +   MOVE.W  (BVAR,A1),(A2)     (d16,An),<ea>
 +   MOVE.W  (WVAR,PC),-(A1)    (d16,PC),<ea>
 +   MOVE.L  (SP)+, D3           (SP)+, <ea>
 +
 +    MOVEQ   #1234, D0
 +
 +    ADD.B       (BVAR,A1),D0   (d16,An),Dn
 +    ADD.W       (WVAR,PC),D1   (d16,PC),Dn
 +    ADD.L       D3,(BVAR,A1)   Dn,(d16,An)
 +    ADDA.W       (BVAR,A2),A1   (d16,An),An
 +    ADDA.L       (WVAR,PC),A3   (d16,PC),An
 +    ADDA.L       (BVAR,A3),A3   (d16,An),An
 +
 +    SUB.B       (BVAR,A2),D0   (d16,An),Dn
 +    SUB.W       (WVAR,PC),D1   (d16,PC),Dn
 +    SUB.L       D1, (BVAR,A1)  Dn,(d16,An)
  
 +    SUBA.W      ($F0F,A1),A4   (d16,An),An
 +    SUBA.L      ($1111,PC),A2  (d16,PC),An
 +
 +    MULS.W      ($32,A2),D0     (d16,An),Dn
 +    MULS.W      ($1000,PC),D1   (d16,PC),Dn
 +
 +    AND.B       ($12,A2),D2     (d16,An),Dn
 +    AND.W       ($1121,PC),D3   (d16,PC),Dn
 +    AND.L       D4, ($112,A4)   Dn,(d16,An)
 +
 +    DIVS.W      ($401,A3),D1     (d16,An),Dn
 +    DIVS.W      ($2211,PC),D2    (d16,PC),Dn
 +
 +    EOR.W       D2,($101,A4)    Dn,(d16,An)
 +
 +    EORI.W      #10, ($11,A2)   #<data>,(d16,An)
 +
 +    ADDI.W      #10, ($11,A2)   #<data>,(d16,An)
 +
 +    CMPI.W      #10, ($11,A2)   #<data>,(d16,An)
 +
 +    ANDI.W      #10, ($11,A2)   #<data>,(d16,An)
 +
 +    ASR.W       ($22,A4)    (d16,An)
 +    ASL.W       WVAR       ASR
 +
 +    LSL.W       ($22,A4)    (d16,An)
 +    LSR.W       WVAR       LSL
 +
 +    ROL.W       ($22,A4)    (d16,An)
 +
 +    ROR.W       ($22,A4)    (d16,An)
 +
 +    LEA     ($10,A1),A1     (d16,An),An
 +    LEA     ($999,PC),A2    (d16,PC),An
 +
 +    JSR     ($19,A2)    (d16,An)
 +    JSR     ($100,PC)   (d16,PC)
 +
 +    NOP         NOP
 +
 +    CLR     ($100,PC)   (d16,PC)
 +    CLR.W   #$FF00
 +    
 +    SUBQ.W      #8,(BVAR,A2)   #<data>,(d16,An)
 +
 +    CMP.B       ($FF,A0),D0     (d16,An),Dn
 +    CMP.W       ($CC1,PC),D2    (d16,PC),Dn
 +
 +    CMPA.W      ($33,A1),A0     (d16,An),An
 +    CMPA.L      ($11,PC),A2     (d16,PC),An
      SIMHALT             ; halt simulator
  
  * Put variables and constants here
 -
 +BVAR    EQU $BA
 +WVAR    EQU $1234
 +LVAR    EQU $FFAA1234
 +DVAR    EQU $12
 +ZVAR    EQU $00000000
 +VBIN1   EQU $FCFCFCFC
      END    START        ; last line of source
  
  
 -
 -*~Font name~Courier New~
 -*~Font size~10~
 -*~Tab type~1~
 -*~Tab size~4~
