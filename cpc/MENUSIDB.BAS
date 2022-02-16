10 ma=HIMEM
15 MEMORY &1800-1
25 adrArg=&1812 : adrRes=&188F
30 LOAD"menusidb.bin",&1800
35 CALL &18A9
45 MODE 2
50 PRINT "MENUSI-DB v0.1 - (c) Gallegux 2022"
100 PRINT STRING$(80,"-");"Options:   1-Load   2-Search   3-Insert   4-Delete   5-Save   6-List   9-Exit"
150 INPUT opc%
170 ON opc% GOSUB 1000,2000,3000,4000,5000,6000, 9050,9050, 7000
300 GOTO 100
999 END
1000 'load
1010 INPUT "File"; arg$
1020 GOSUB 9000
1030 CALL &18A3
1040 IF 0=PEEK(adrRes) THEN PRINT "File not loaded": RETURN
1045 GOSUB 8300
1050 PRINT "File loaded,";regs;"registers,";tam;"bytes"
1060 RETURN
2000 'search
2010 INPUT "Name"; arg$
2030 arg$="  "+arg$+CHR$(0)
2040 GOSUB 9000
2050 CALL &1897
2090 RETURN
3000 'insert
3010 INPUT "Name"; arg$
3020 INPUT "Commands"; cc$
3024 PRINT "Insert: {";arg$;";";cc$;"}"
3025 GOSUB 8000
3030 arg$=CHR$(LEN(arg$)+LEN(cc$)+2)+CHR$(0)+arg$+cc$
3035 IF LEN(arg$)>125 THEN PRINT "Name and commands string too long":RETURN
3050 GOSUB 9000
3060 CALL &189A
3070 IF 0=PEEK(adrRes) THEN PRINT "Register not inserted" ELSE PRINT "Register inserted"
3100 RETURN
4000 'delete
4010 INPUT "Exact name"; arg$
4025 arg$="  "+arg$+CHR$(0)
4030 GOSUB 9000
4040 CALL &189D
4050 IF 0=PEEK(adrRes) THEN PRINT "Register not deleted" ELSE PRINT "Register deleted"
4100 RETURN
5000 'save
5010 INPUT "File"; arg$
5030 GOSUB 9000
5040 CALL &18A6
5050 IF 0=PEEK(adrRes) THEN PRINT "File not saved": RETURN
5060 GOSUB 8300
5070 PRINT "File saved,";regs;"registers,";tam;"bytes"
5100 RETURN
6000 'list all
6020 CALL &18A0
6030 IF 0=PEEK(adrRes) THEN PRINT "Error"
6040 RETURN
7000 'end
7010 MEMORY ma
7020 END
8000 '
8010 cc$=";"+UPPER$(cc$)+";"
8020 pat$=";DSK;" : valPat$=CHR$(1) : GOSUB 8200
8030 pat$=";DIR;" : valPat$=CHR$(2) : GOSUB 8200
8040 pat$=";RUN;" : valPat$=CHR$(3) : GOSUB 8200
8050 pat$=";CPM;" : valPat$=CHR$(4) : GOSUB 8200
8060 pat$=";SNAP;" : valPat$=CHR$(5) : GOSUB 8200
8070 pat$=";USER;" : valPat$=CHR$(6) : GOSUB 8200
8080 pat$=";DSK2;" : valPat$=CHR$(7) : GOSUB 8200
8090 pat$=";DSK3;" : valPat$=CHR$(8) : GOSUB 8200
8100 pat$=";DSK4;" : valPat$=CHR$(9) : GOSUB 8200
8110 pat$=";MENU;" : valPat$=CHR$(10) : GOSUB 8200
8140 IF LEFT$(cc$,1)=";"  THEN cc$=RIGHT$(cc$,LEN(cc$)-1)
8145 IF RIGHT$(cc$,1)=";" THEN cc$=LEFT$(cc$,LEN(cc$)-1)
8150 IF RIGHT$(cc$,1)<>CHR$(4) THEN cc$=cc$+CHR$(0)
8160 RETURN
8200 r%=1
8210 WHILE r%<>0
8220   r%=INSTR(cc$, pat$)
8230   IF r%>0 THEN cc$=LEFT$(cc$, r%-1) + valPat$ + RIGHT$(cc$, LEN(cc$)-(r%-1)-LEN(pat$))
8240 WEND
8250 RETURN
8300 'update regs and size
8310 tam=PEEK(&1800)+256*PEEK(&1801) : regs=PEEK(&1802)+256*PEEK(&1803)
8330 RETURN
9000 'set param
9005 dir=adrArg
9006 arg$=arg$+CHR$(0)
9010 FOR n%=1 TO LEN(arg$)
9020   POKE dir, ASC(MID$(arg$,n%,1))
9030   dir=dir+1
9040 NEXT
9050 RETURN
