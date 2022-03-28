10 'help'
20 MODE 1 : INK 0,1 : INK 1,25 : INK 2,23 : INK 3,18 : vi$=CHR$(24)
30 PEN 3
40 LOCATE 33,1 : IF PEEK(6)=128 THEN PRINT " CPC 464" ELSE PRINT "CPC 6128"
50 IF INP(&FBD8)=255 THEN card%=1 ELSE card%=0 : '0=UsifacII 1=M4
60 LOCATE 33,2 : IF card%=0 THEN PRINT "UsifacII" ELSE PRINT "      M4"
70 LOCATE 1,1: PEN 3: PRINT vi$;"                    "
80 PRINT " MENUSI 0.4b - Help "
90 PRINT "                    ";vi$
100 PRINT:PRINT
110 PEN 1: PRINT "Cursor keys"
120 PEN 2: PRINT "  Move the selector"
130 PRINT
140 PEN 1: PRINT "ENTER"
150 PEN 2: PRINT "  Launch the selected program"
160 PRINT "  OR show the selected menu"
170 PRINT
180 PEN 1: PRINT "DEL"
190 PEN 2: PRINT "  Go back to previous menu"
200 PRINT
210 PEN 1: PRINT "ESC"
220 PEN 2: PRINT "  Exit"
230 PRINT:PRINT:PRINT
240 PEN 3: PRINT "Press any key to continue"
250 WHILE INKEY$="":WEND
260 RUN"menusi.bas"
