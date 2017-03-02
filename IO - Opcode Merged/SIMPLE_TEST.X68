*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

   ORG    $7000
   
   
********************************************************
* LEGAL SUB Tests                                      *     
********************************************************
    SUB.B       D0,WVAR    Dn,(xxx).W
    SUB.W       WVAR,D0    (xxx).W,Dn
    SUB.B       D0,D1       Dn,Dn
    SUB.W       D2,D3 
    SUB.L       A1,D0       An,Dn
    SUB.W       A4,D3
    SUB.B       (A3),D3     (An),Dn
    SUB.L       (A2),D0
    SUB.B       (A0)+,D1    (An)+,Dn
    SUB.W       (A3)+,D2
    SUB.L       -(A1),D2    -(An),Dn
    SUB.B       -(A2),D1    
    SUB.W       WVAR,D0    (xxx).W,Dn
    SUB.L       VBIN1,D2    (xxx).L,Dn
    SUB.W       $8000,D5
    SUB.L       $54FFF,D7
    SUB.W       D0,A1       Dn,An
    SUB.L       D3,A4
    SUB.B       D3,(A3)     Dn,(An)
    SUB.W       D0,(A2)
    SUB.L       D1,(A0)+    Dn,(An)+
    SUB.B       D2,(A3)+
    SUB.W       D2,-(A1)     Dn,-(An)
    SUB.L       D1,-(A2)
    SUB.B       D0,WVAR    Dn,(xxx).W
    SUB.W       D2,VBIN1    Dn,(xxx).L
    SUB.L       D3,LVAR    Dn,(xxx).L
    
*******************************************************
* LEGAL ADDI Tests                                    *
*******************************************************
*    ADDI.B      #BVAR,D0       #<data>,Dn
*    ADDI.W      #10,D1
*    ADDI.L      #LVAR,(A1)     #<data>,An
*    ADDI.B      #$12,(A3)
*    ADDI.W      #WVAR,(A2)+    #<data>,(An)+
*    ADDI.L      #VBIN1,(A4)+
*    ADDI.B      #$FF, -(A0)     #<data>,-(An)
*    ADDI.W      #$1222,-(A5)
*    ADDI.L      #WVAR,WVAR    #<data>,(xxx).W
*    ADDI.B      #$11, LVAR     #<data>,(xxx).L
*    ADDI.L      #$12345,D7     #<data>,Dn
*    
    
*******************************************************
* LEGAL MOVEA Tests                                   *     
*******************************************************
*    MOVEA.W       D2,A6
*    MOVEA.W       A2,A1
*    MOVEA.W       (A2),A3
*    MOVEA.W       (A2)+,A4
*    MOVEA.W       -(A3),A4  
*    MOVEA.W       -(A3),A4
*    MOVEA.W       #2345,A6
*    MOVEA.W       $00002345,A6 
*    MOVEA.L      $00002345,A6 
*    MOVEA.L      $00008345,A6 
*    MOVEA.L      $FFFF8345,A6 

* Put program code here

    SIMHALT             ; halt simulator

* Put variables and constants here

* Put variables and constants here
BVAR    EQU $BA
WVAR    EQU $1234
LVAR    EQU $FFAA1234
DVAR    EQU $12
ZVAR    EQU $00000000
VBIN1   EQU $FCFCFCFC

    END    START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
