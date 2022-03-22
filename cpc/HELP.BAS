10 'help'
20 MODE 1 : INK 1,25 : INK 2,23 : INK 3,18 : vi$=CHR$(24)
30 PEN 3: PRINT vi$;"                    "
40 PRINT " MENUSI 0.4b - Help "
50 PRINT "                    ";vi$
60 PRINT:PRINT
70 PEN 1: PRINT "Cursor keys"
80 PEN 2: PRINT "  Move the selector"
90 PRINT
100 PEN 1: PRINT "ENTER"
110 PEN 2: PRINT "  Launch the selected program"
120 PRINT "  OR show the selected menu"
130 PRINT
140 PEN 1: PRINT "DEL"
150 PEN 2: PRINT "  Go back to previous menu"
160 PRINT
170 PEN 1: PRINT "ESC"
180 PEN 2: PRINT "  Exit"
190 PRINT:PRINT:PRINT
200 PEN 3: PRINT "Press any key to continue"
210 WHILE INKEY$="":WEND
220 RUN"menusi.bas"
