;;____________________________________________________________________________
;;                                                                            ;
;;  MENUSI                                                                    ;
;;  Fast menu for launch games or programs in Amstrad CPC with support to     ;
;;  M4 and USIFAC/ULIFAC boards                                               ;
;;                                                                            ;
;;  Copyright (c) 2022 Gallegux (gallegux@gmail.com)                          ;
;;                                                                            ;
;;  This program is free software: you can redistribute it and/or modify      ;
;;  it under the terms of the GNU General Public License as published by      ;
;;  the Free Software Foundation, either version 3 of the License, or         ;
;;  any later version.                                                        ;
;;                                                                            ;
;;  This program is distributed in the hope that it will be useful, but       ;
;;  WITHOUT ANY WARRANTY; without even the implied warranty of                ;
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the              ;
;;  GNU General Public License for more details.                              ;
;;                                                                            ;
;;  You should have received a copy of the GNU General Public License         ;
;;  along with this program; if not, see <http://www.gnu.org/licenses/>.      ;
;;                                                                            ;
;;  If you use this code, please attribute the original source by mentioning  ;
;;  the author and providing a link to the original repository.               ;
;;____________________________________________________________________________;


write  ".\..\dist\menusi.bin"


PRINT_CHR      equ #bb5a
LOCATE         equ #bb75
CAMBIAR_TINTAS equ #bb9c
TEST_TECLA     equ #bb1e
RESET_TECLADO  equ &bb03
READ_CHAR      equ &bb09

ANCHO_CURSOR   equ 26
COLUMNA_1      equ 1
COLUMNA_2      equ 27
COLUMNA_3      equ 52
ENLACE_NULO    equ 0

REGISTROS_COLUMNA equ 23
REGISTROS_PAGINA  equ REGISTROS_COLUMNA*3

TAM_ELEMENTO_PILA  equ 13
MAX_ELEMENTOS_PILA equ 5

macro TestTecla codigo, funcion
	ld a, codigo
	call TEST_TECLA
	call nz, funcion
endm


org #1800

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


call preparar
call cargar_menu_y_mostrar

bucle:
	TestTecla 8, izquierda
	TestTecla 0, arriba
	TestTecla 2, abajo
	TestTecla 1, derecha
	TestTecla 18, ejecutar ;;return
	TestTecla 66, salir ;;esc
	TestTecla 79, atras ;;del
jr bucle


;; VARIABLES
.registro_pagina:	dw 0 ; el primer registro de la pagina
.cursor_pagina:		db 0
.pagina:		db 0
.registro_actual:	dw 0

.resultado:		db 0
.ordenes:		dw 0

.elementos_pila		db 0
.puntero_pila		dw 0 ; apunta al elemento que se visualiza
.pila_ficheros		ds TAM_ELEMENTO_PILA*MAX_ELEMENTOS_PILA




init_variables:
	ld bc, DATOS
	ld (registro_pagina), bc
	ld (registro_actual), bc

	xor a ; A=0
	ld (cursor_pagina), a
	ld (pagina), a
	ld (resultado), a

	ret



izquierda:
	ld a, (cursor_pagina)
	cp REGISTROS_COLUMNA
	jr nc, _izquierda_misma_pagina
_izquierda_pagina_anterior
	;pagina anterior?
	ld a, (pagina)
	cp 0
	ret z
	;;;;;;;;;;;;;;;;;;;;;;;;;;pagina anterior
	;calc registro_pagina
	ld b, REGISTROS_PAGINA
	ld hl, (registro_pagina)
	call retroceder
	ld (registro_pagina), hl
	;calc registro_actual
	ld b, REGISTROS_COLUMNA
	ld hl, (registro_actual)
	call retroceder ; <c=registros retrocedidos
	ld (registro_actual), hl
	;calc cursor_pagina
	ld b, REGISTROS_PAGINA - REGISTROS_COLUMNA
	ld a, (cursor_pagina)
	add a, b ;C=REGISTROS_COLUMNA
	ld (cursor_pagina), a
	;calc pagina
	ld hl, pagina
	dec (hl)

	jp cambiar_pagina

_izquierda_misma_pagina
	call flip_programa
	;calc registro_actual
	ld b, REGISTROS_COLUMNA
	ld hl, (registro_actual)
	call retroceder
	ld (registro_actual), hl
	;calc cursor_pagina
	ld a, (cursor_pagina)
	sub c ; C=REGISTROS_COLUMNA 
	ld (cursor_pagina), a

	jp destacar_programa_salir
	


derecha:
	ld a, (cursor_pagina)
	cp REGISTROS_COLUMNA*2
	jr c, _derecha_misma_pagina
_derecha_siguiente_pagina
	;;;; siguiente pagina?
	ld hl, (registro_pagina)
	ld b, REGISTROS_PAGINA
	call avanzar
	ld a, REGISTROS_PAGINA
	cp c
	ret nz
	;;;;;;;;;;;;;;;;;;;; siguiente pagina
	; calc registro_pagina
	ld (registro_pagina), hl
	; calc registro_actual
	ld b, REGISTROS_COLUMNA
	ld hl, (registro_actual)
	call avanzar
	ld (registro_actual), hl

	; calc cursor_pagina
	ld a, (cursor_pagina)
	add a, c
	sub REGISTROS_PAGINA
	ld (cursor_pagina), a

	; calc pagina
	ld hl, pagina
	inc (hl)

	jp cambiar_pagina

_derecha_misma_pagina
	ld hl, (registro_actual)
	ld a, (hl)
	cp ENLACE_NULO
	ret z

	ld a, (cursor_pagina)
	call flip_programa

	;calc registro_actual
	ld b, REGISTROS_COLUMNA
	ld hl, (registro_actual)
	call avanzar
	ld (registro_actual), hl

	;calc cursor_pagina
	ld a, (cursor_pagina)
	add a, c
	ld (cursor_pagina), a

	jp destacar_programa_salir



arriba:
	ld a, (cursor_pagina)
	cp 0
	jr z, _arriba_subir_pagina
_arriba_misma_pagina
	call flip_programa

	;calc registro_actual
	call get_registro_anterior ;<hl
	ld (registro_actual), hl

	;calc cursor_pagina
	ld hl, cursor_pagina
	dec (hl)
	ld a, (hl)

	jp destacar_programa_salir

_arriba_subir_pagina
	ld hl, (registro_actual)
	inc hl
	ld a, (hl) ; primer registro?
	cp ENLACE_NULO
	ret z 

	;calc registro_pagina
	ld b, REGISTROS_PAGINA
	ld hl, (registro_pagina)
	call retroceder
	ld (registro_pagina), hl
	;calc registro_actual
	call get_registro_anterior
	ld (registro_actual), hl
	;calc cursor_pagina
	ld a, REGISTROS_PAGINA-1
	ld (cursor_pagina), a
	;calc pagina
	ld hl, pagina
	dec (hl)

	jp cambiar_pagina
	ret



abajo:
	ld hl, (registro_actual)
	ld a, (hl) 
	cp ENLACE_NULO ; es el ultimo registro?
	ret z

	ld a, (cursor_pagina)
	cp REGISTROS_PAGINA-1
	jr z, _abajo_siguiente_pagina
_abajo_misma_pagina
	call flip_programa

	;calc registro_actual
	call get_registro_siguiente
	ld (registro_actual), hl

	;calc cursor_pagina
	ld hl, cursor_pagina
	inc (hl)
	ld a, (hl)
	
	jp destacar_programa_salir

_abajo_siguiente_pagina
	; calc registro_actual
	call get_registro_siguiente
	ld (registro_actual), hl
	ld (registro_pagina), hl
	;calc pagina
	ld hl, pagina
	inc (hl)
	;calc cursor_pagina
	xor a
	ld (cursor_pagina), a

	;jp cambiar_pagina


cambiar_pagina:
	call quitar_contenido
	call imprimir_pagina
	ld a, (cursor_pagina)
destacar_programa_salir:
	call flip_programa
	call delay
	ret


delay:
	ld b, 30
_d_loop
	halt
	djnz _d_loop
	call RESET_TECLADO
	ret
;  call READ_CHAR
;  jr nc, delay
;  ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; in
;; hl - fichero
cargar_menu_y_mostrar:
	;obtenemos el fichero apuntaro por la pila
	ld hl, puntero_pila
	ld a, (hl)
	inc hl
	ld h, (hl)
	ld l, a ; hl apunta a un elemento de la pila

	call get_data_file
	call init_variables
	call quitar_contenido
	call imprimir_pagina

	xor a
	call flip_programa
	ret



atras:
	call check_pop_file
	ret z

	call pop_file
	call cargar_menu_y_mostrar

	ret



ejecutar:
	ld hl, (registro_actual)
	; saltar los dos primeros bytes
	inc hl
	inc hl
	;
	ld a, (hl)
	cp '>'
	jr nz, _e_run

_cargar_fichero	;; otro menu
	call check_push_file
	ret z

	call consumir_string
	push hl
		call push_file
	pop hl
	call cargar_menu_y_mostrar
	call delay
	ret

_e_run
	; ponemos un 1
	ld a, 1
	ld (resultado), a
	call consumir_string
_e_copiar
	dec hl
	ld (ordenes), hl
	;salir

salir:
	inc sp
	inc sp
	call RESET_TECLADO
	ret


;; in
;; hl
consumir_string:
	ld a, 30 
_cs_loop
	cpi ; compara A con (hl) e incrementa hl
	jp m, _cs_loop ; si a<(hl)
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


imprimir_pagina:
	di
	;; call reset_locate
	ld a, -1
	ld (num_locate), a
	;; 
	ld hl, (registro_pagina)
	ld iyl, #ff ; contador registros
_ip_loop
	inc iyl
	ld a, iyl
	cp REGISTROS_PAGINA
	jr z, _impr_pagina_salir

	push hl ; registro
		inc hl
		inc hl
		ex de, hl ; de=cadena

		;next locate
		ld a, (num_locate) ;[2]
		inc a ;[1]
		ld (num_locate), a ;[2]

		ld hl, locates_registros ;[3]
		ld l, a ;[1] entre 0 y 68
		sla l ; [2] max.valor=136
	;locate_registro
		ld a, (hl) ;[2]
		inc l ;[1]
		ld h, (hl) ; [2]
		ld l, a ; [1]
	;
		call print_string ;; >hl:dir.mem de:cadena
	pop hl ; registro

	ld b,0
	; 0=enlace nulo
	; d lo utilizamos en la comparacion y en la suma
	ld a, (hl)
	cp b ; enlace nulo?
	jr z, _impr_pagina_salir
	;b=0
	ld c, a   ; bc=a
	add hl, bc
	jp _ip_loop
_impr_pagina_salir
	ei
	ret
	

num_locate db 0



;; in
;; a - num registro
;; out
;; hl - dir.mem
;; mod: a
locate_registro:
	ld hl, locates_registros
	sla a
	ld l, a ; apunta al segundo byte

	ld a, (hl)
	inc l
	ld h, (hl)
	ld l, a
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



flip_programa:
;; in
;; a - num registro
invertir_registro:
	call locate_registro
	dec l
	ld de, #800-ANCHO_CURSOR
	ld c, 8
_ir_loop1
	ld b, ANCHO_CURSOR
_ir_loop2
	ld a, (hl)
	cpl
	ld (hl), a
	inc hl
	djnz _ir_loop2
	add hl, de
	dec c
	jp nz, _ir_loop1
	ret




;; hl - dir.destino
;; de - cadena
print_string:
	ld bc, #800
_ps_loop
	ld a, (de)
	cp 30 ;;
	ret c ;; salir si el caracter no es imprimible

	push de ; cadena
		ld d, 0
		ld e, a

		sla e
		rl d
		sla e
		rl d
		sla e
		rl d
		; de = desplazamiento

		push hl
			ld hl, caracteres_rom-256
			add hl, de ; hl=caracter
			ex de, hl ; de=caracter
		pop hl

		push hl
			repeat 7 ;5 bytes x 7 = 35 bytes
				ld a, (de)
				ld (hl), a
				inc de
				add hl, bc
			rend

			ld a, (de)
			ld (hl), a
		pop hl
	pop de

	inc hl
	inc de
	jp _ps_loop



;; invierte una linea de caracteres
;; in
;; hl - direccion
;; b - num caracteres
invertir:
	ld e, b
	ld c, 8
_il1	
	ld b, e
	push hl
_il2
		ld a, (hl)
		cpl
		ld (hl), a
		inc hl
		djnz _il2
	pop hl
	push bc
		ld bc, #800
		add hl, bc
	pop bc
_il3
	dec c
	jp nz, _il1
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; in hl
;; out hl
get_registro_siguiente:
	ld hl, (registro_actual)
	ld d, 0
	ld e, (hl)
	add hl, de
	ret


;; in hl
;; out hl
get_registro_anterior:
	ld hl, (registro_actual)
	inc hl
	ld d, #ff
	ld e, (hl)
	dec hl
	add hl, de
	ret


;; in
;; b - num registros
;; hl - registro
;; out
;; hl - registro
;; c - registros retrocedidos
retroceder:
	ld d, #ff ; byteH del numero que se restara
	ld c, -1
	ld a, ENLACE_NULO
	inc b
	inc hl ; avanzamos una posicion y hl apunta al reg.ant.
_r_loop
	inc c
	ld e, (hl)
	cp e
	jp z, _r_salir
	dec b
	jp z, _r_salir
		add hl, de
		jp _r_loop
_r_salir
	dec hl
	ret


;; in
;; b - num registros
;; hl - registro
;; out
;; hl - registro
;; c - registros avanzados
avanzar:
	ld d, 0
	ld c, -1
	ld a, ENLACE_NULO
	inc b
_a_loop
	inc c
	ld e, (hl)
	cp e
	ret z
	dec b
	ret z
		add hl, de
		jp _a_loop


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; quita el contenido de la pantalla
;; toca la pila
quitar_contenido:
	di
	ld (pila), sp
	ld de, 0
	ld hl, 23*80 + #c000+#50+#50

	ld c, 8
_cs_loop0
	ld sp, hl
	ld b, 115 ; 40 words
_cs_loop2
	push de : push de
	push de : push de
	push de : push de
	push de : push de
	djnz _cs_loop2

	ld de, #800
	add hl, de
	ld de, 0

	dec c
	jp nz, _cs_loop0
	
	ld sp, (pila)
	ei
	ret
	
pila: dw 0



;; out
;; z - z=0 se puede hacer push, z=1 tope de la pila
check_push_file:
	ld a, (elementos_pila)
	cp MAX_ELEMENTOS_PILA
	ret




;in
;hl - nombre fichero
push_file:
	ld a, (elementos_pila)
	inc a
	ld (elementos_pila), a

	ld de, (puntero_pila)
	ex de, hl
		ld bc, TAM_ELEMENTO_PILA
		add hl, bc
	ex de, hl
	ld (puntero_pila), de

	ldir
	ret



;; z - z=0 se puede hacer push, z=1 tope de la pila
check_pop_file:
	ld a, (elementos_pila)
	cp 1
	ret
	


;; out
;; hl - nombre del fichero
pop_file:
	ld a, (elementos_pila)
	dec a
	ld (elementos_pila), a

	ld de, (puntero_pila)
	ex de, hl
		ld bc, -TAM_ELEMENTO_PILA
		add hl, bc
	ex de, hl
	ld (puntero_pila), de

	ret


;; in 
;; hl - nombre del fichero
get_data_file:
	push hl
		call get_string_length ; <e
	pop hl

	call #bc77 ; abrir fichero

	ld hl, DATOS
	call #bc83 ; leer fichero completo
	call #bc7a ; cerrar fichero

	RET


;; in hl
;; out b
get_string_length:
	ld a, 30
	ld b, 0
_gsl_loop
	cp (hl) ;2
	ret nc ;2
	inc b ;1
	inc hl ;2
	jp _gsl_loop ;3




;; in
;; de
;; mod: de
print_string_fw:
	ld c, 30
	ld a, (de)
	cp c;10
	ret c
	call PRINT_CHR
	inc de
	jp print_string_fw


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DB "  Ya al final de mi vida de pecador, mientras espero el momento de perderme...  " 

align 256
locates_registros: ; 69*2 bytes
dw #C0A1, #C0F1, #C141, #C191, #C1E1, #C231, #C281, #C2D1, #C321, #C371
dw #C3C1, #C411, #C461, #C4B1, #C501, #C551, #C5A1, #C5F1, #C641, #C691
dw #C6E1, #C731, #C781
dw #C0BB, #C10B, #C15B, #C1AB, #C1FB, #C24B, #C29B, #C2EB, #C33B, #C38B
dw #C3DB, #C42B, #C47B, #C4CB, #C51B, #C56B, #C5BB, #C60B, #C65B, #C6AB
dw #C6FB, #C74B, #C79B
dw #C0D5, #C125, #C175, #C1C5, #C215, #C265, #C2B5, #C305, #C355, #C3A5
dw #C3F5, #C445, #C495, #C4E5, #C535, #C585, #C5D5, #C625, #C675, #C6C5
dw #C715, #C765, #C7B5

caracteres_rom: ; del caracter 32 al 127, 8 bytes por caracter
incbin "caracteres_rom.bin"



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
align 16
;; lo que hay a continuacion se sobreescribe por los datos
.DATOS:


.cabecera:
	db 'MENUSI v2.0',0
.copyright
	db 164,' Gallegux 2022',0
;.copyright:
;db 151,183,240,145,253,145,244,147,230,158,190,140,188,142,188,0



print_creditos:
	ld hl, #0201
	call LOCATE
	ld de, cabecera
	call print_string_fw

	ld hl, #4101
	call LOCATE
	ld de, copyright
	call print_string_fw

	ld hl, #c000
	ld b, 80
	call invertir

	ret


get_fichero_parametro:
	;de apunta a la variable
	inc de
	ld h, d
	ld l, e ; hl<-de
	ld a, (hl)
	inc hl
	ld h, (hl)
	ld l, a ;hl<-(hl)
	ret



preparar:
	;; check numero de parametros
	;; A contiene el numero de parametros
	cp 1
	ret nz

	ld (registro_actual), de ;uso temporal

	call print_creditos

	xor a
	ld (elementos_pila), a
	ld bc, pila_ficheros-TAM_ELEMENTO_PILA
	ld (puntero_pila), bc

	ld de, (registro_actual)
	call get_fichero_parametro
	call push_file

	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
db 0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
let tam=$
let size=tam-#1800
print "SIZE: &size"