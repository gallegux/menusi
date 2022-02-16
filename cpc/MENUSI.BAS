1 dataFile$ = "menu1.dat"
2 card% = 0 : '0=UsifacII 1=M4
7 '
8 ' MENUSI (c) Gallegux 2022
9 '
10 himemant=HIMEM
20 MEMORY &1800-1
30 LOAD"menusi.bin",&1800
50 MODE 2
51 dataFile$=dataFile$+CHR$(0)
52 CALL &1800,@dataFile$
55 MEMORY himemant
60 GOSUB 1100
65 CLS
70 IF PEEK(&1846)=0 THEN END
80 dir=PEEK(&1847)+256*PEEK(&1848)
90 ret$=CHR$(13)+CHR$(10)
100 d%=PEEK(dir) : dir=dir+1
110 IF d%=4 THEN PRINT ret$;"CPM" : |CPM
115 GOSUB 1000
125 IF d%=1 AND card%=0 THEN PRINT ret$;"DSK ";arg$ : |MG,@arg$ : |FDC
130 IF d%=1 AND card%=1 THEN PRINT ret$;"DSK ";arg$ : |CD,@arg$
135 IF d%=2 THEN PRINT ret$;"CD ";arg$ : |CD,@arg$
140 IF d%=3 THEN PRINT ret$;"RUN ";arg$ : RUN arg$
145 IF d%=5 THEN PRINT ret$;"SNAP ";arg$ : |SNA,@arg$
150 IF d%=6 THEN ret$;"USER ";arg$ : |USER,VAL(arg$)
155 IF d%=7 AND card%=0 THEN PRINT ret$;"DSK2 ";arg$ : |MG2,@arg$
160 IF d%=8 AND card%=0 THEN PRINT ret$;"DSK3 ";arg$ : |MG3,@arg$
165 IF d%=9 AND card%=0 THEN PRINT ret$;"DSK4 ";arg$ : |MG4,@arg$
190 IF d%>31 THEN PRINT"No run":END
200 GOTO 100
999 END
1000 'get the argument'
1005 arg$=""
1010 c%=PEEK(dir)
1020 IF c%>31 THEN arg$=arg$+CHR$(c%) : dir=dir+1 : GOTO 1010
1030 RETURN
1100 'go to root'
1110 IF card%=0 THEN |CD
1120 IF card%=1 THEN aux$="..":|CD,@aux$
1130 RETURN

