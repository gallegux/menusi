1 dataFile$ = "menusi.dat"
2 card% = 0 : '0=UsifacII 1=M4
3 'moveToRoot% = 1 : '0 or 1, move to root once files are loaded (40 and 50)
7 '
8 ' MENUSI (c) Gallegux 2022
9 '
10 himemant=HIMEM
20 dirProg=&1800 : dirData=&1AF0 : MEMORY dirProg-1
30 LOAD"menusi.bin",dirProg
40 LOAD dataFile$,dirData
44 |CDR
50 MODE 2 : CALL dirProg
55 MEMORY himemant
70 IF PEEK(&1844)=0 THEN CLS : END
74 CLS
75 dir=PEEK(&1845)+256*PEEK(&1846)
91 ret$=CHR$(13)+CHR$(10)
100 d%=PEEK(dir) : dir=dir+1
110 IF d%=4 THEN PRINT ret$;"CPM" : |CPM
115 GOSUB 1000 : 'get the argument
120 IF d%=2 THEN PRINT ret$;"CD ";arg$ : |CD,arg$
130 IF d%=3 THEN PRINT ret$;"RUN ";arg$ : RUN arg$
135 IF d%=5 THEN PRINT ret$;"SNAP ";arg$ : |SNA,arg$
140 IF d%=1 AND card%=0 THEN PRINT ret$;"DSK ";arg$ : |MG,arg$ : |FDC
145 IF d%=1 AND card%=1 THEN PRINT ret$;"DSK ";arg$ : |CD,arg$
147 IF d%=6 THEN ret$;"USER ";arg$ : |USER,VAL(arg$)
200 GOTO 100
999 END
1000 arg$=""
1010 c%=PEEK(dir)
1020 IF c%>31 THEN arg$=arg$+CHR$(c%) : dir=dir+1 : GOTO 1010
1030 RETURN
