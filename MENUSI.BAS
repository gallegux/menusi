1 ficheroDatos$ = "menusi.dat"
2 tarjeta% = 0 : '0=UsifacII 1=M4
3 '
4 ' MENUSI (c) Gallegux 2022
5 '
10 himemant=HIMEM
20 MEMORY &2000-1
30 LOAD"menusi.bin",&2000
40 LOAD ficheroDatos$,&2400
45 MODE 2
50 CALL &2000
60 'salida: &200D
70 res%=PEEK(&200D)
80 IF res%=0 THEN MODE 1 : MEMORY himemant : END
84 PRINT res%
85 MEMORY himemant
86 MODE 1
90 dir=&200E
91 ret$=CHR$(13)+CHR$(10)
100 d%=PEEK(dir) : dir=dir+1
110 IF d%=4 THEN PRINT ret$;"CPM" : |CPM
115 GOSUB 1000 : 'obtener el argumento
120 IF d%=2 THEN PRINT ret$;"CD ";arg$ : |CD,arg$
130 IF d%=3 THEN PRINT ret$;"RUN ";arg$ : RUN arg$
140 IF d%=1 AND tarjeta%=0 THEN PRINT ret$;"DSK ";arg$ : |MG,arg$ : |FDC
145 IF d%=1 AND tarjeta%=1 THEN PRINT ret$;"DSK ";arg$ : |CD,arg$
150 GOTO 100
999 END
1000 arg$=""
1010 c%=PEEK(dir)
1020 IF c%>31 THEN arg$=arg$+CHR$(c%) : dir=dir+1 : GOTO 1010
1030 RETURN
