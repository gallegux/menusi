/*___________________________________________________________________________
|                                                                            |
|  MENUSI-DB                                                                 |
|  Editor for Menusi-menus under Amstrad CPC                                 |
|                                                                            |
|  Copyright (c) 2022 Gallegux (gallegux@gmail.com)                          |
|                                                                            |
|  This program is free software: you can redistribute it and/or modify      |
|  it under the terms of the GNU General Public License as published by      |
|  the Free Software Foundation, either version 3 of the License, or         |
|  any later version.                                                        |
|                                                                            |
|  This program is distributed in the hope that it will be useful, but       |
|  WITHOUT ANY WARRANTY; without even the implied warranty of                |
|  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the              |
|  GNU General Public License for more details.                              |
|                                                                            |
|  You should have received a copy of the GNU General Public License         |
|  along with this program; if not, see <http://www.gnu.org/licenses/>.      |
|                                                                            |
|  If you use this code, please attribute the original source by mentioning  |
|  the author and providing a link to the original repository.               |
|___________________________________________________________________________*/


write ".\..\dist\menusidb.bin"


;; registro
;; byte 1: numero de bytes hasta el registro siguiente *
;; byte 2: numero de bytes hasta el registro anterior en complemento a 1 *
;; * si es 0, es que no hay registro siguiente o anterior
;; nombre del registro
;; comando, byte < 15
;; argumento
;; ....
;; el registro termina en 0 (despues del argumento run) o 4 (cpm)

org #2000
;run #1800


macro SetResultado1
	ld a, 1
	ld (resultado), a
endm

macro SetResultado0
	xor a
	ld (resultado), a
endm



PrintChar equ &bb5a
DATOS equ #2500

tam_fichero dw 0
num_registros dw 0

nuevo_tam dw 0
;tam dw 16*3
cp_dst 
mv_src_ini dw 0
mv_dst_ini dw 0
mv_src_fin dw 0
mv_dst_fin dw 0
mv_cnt dw 0
aux_num_registros dw 0


;.registro:
;db 25,0,'Nunca jamas',1,'nuncaj.dsk',0

.registro:
	ds 125
.resultado
	db #ff

.registro_hl:	dw 0
.registro_de:	dw 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

func_contar:	jp contar
func_buscar:	jp buscar
func_insertar:	jp insertar
func_eliminar:	jp eliminar
func_listar:	jp listar_todos
func_cargar:	jp cargar
func_guardar:	jp guardar

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


init_variables:
	ld bc, 0
	ld (tam_fichero), bc
	ld (num_registros), bc
	ld (datos), bc
func_nada:    ;reutilizamos el ret
	ret
	


buscar_generico:
	ld bc, (num_registros)
	ld (aux_num_registros), bc

	ld de, registro
	ld hl, DATOS

_bus_cmp_registro
	ld iyl, -1 ; bytes iguales
	push hl
	push de
		inc hl
		inc de
_bus_cmp_byte
		inc hl
		inc de
		inc iyl

		call comparar_contenidos_hl_de ; <a
		cp 0
		jp z, _bus_iguales_del_to
		cp 1
		jp z, _buscar_registro_menor
		cp 2
		jp z, _buscar_registro_mayor
		cp 3
		jp z, _bus_cmp_byte
		
_buscar_registro_mayor ; registro hl es mayor
	pop de
	pop hl

	ld (registro_de), de
	ld (registro_hl), hl

	call #0000
	__funcion_registro_mayor equ $-2

	ld de, (registro_de)
	ld hl, (registro_hl)

	ld a, #00
	__salir_tras_registro_mayor equ $-1
	cp 1
	ret z

	jr _buscar_sig_registro

_bus_iguales_del_to
	pop de
	pop hl

	ld (registro_de), de
	ld (registro_hl), hl
		call #0000
		__funcion_iguales equ $-2
	ld de, (registro_de)
	ld hl, (registro_hl)

	ld a, #00
	__salir_tras_iguales equ $-1
	cp 1
	ret z
	jr _buscar_sig_registro

_buscar_registro_menor ; registro hl es menor
	pop de
	pop hl

	ld (registro_de), de
	ld (registro_hl), hl
		call #0000
		__funcion_registro_menor equ $-2
	ld de, (registro_de)
	ld hl, (registro_hl)

	ld a, #00
	__salir_tras_registro_menor equ $-1
	cp 1
	ret z
	jr _buscar_sig_registro

_buscar_sig_registro
	ld bc, (aux_num_registros)
	dec bc
	ld (aux_num_registros), bc

	call test_bc_igual_0
	ret z ; si z=1 salimos y hl apunta al ultimo registro

	;siguiente registro
	ld c, (hl) 
	ld b, 0
	add hl, bc
	jp _bus_cmp_registro



comparar_contenidos_hl_de:
	ld a, (hl)
	cp 30
	jp p, _cc_hl_gt_30
		ld a, (de)
		cp 30
		jp p, _cc_menor
		jp _cc_iguales
_cc_hl_gt_30
	ld a, (de)
	cp 30
	jp m, _cc_mayor

	cp (hl) ; (hl) =? (de)
	jp z, _cc_seguir

	jp p, _cc_menor
	jp _cc_mayor
_cc_iguales
	ld a, 0
	ret
_cc_menor
	ld a, 1
	ret
_cc_mayor
	ld a, 2
	ret
_cc_seguir
	ld a, 3
	ret
	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;

buscar:
	ld bc, _salir_busqueda
	ld (__salir_pagina), bc

	ld iyh, 0
	ld bc, print_registros_busquedas_paginados
	ld (__funcion_registro_menor), bc
	ld (__funcion_registro_mayor), bc
	ld (__funcion_iguales), bc

	xor a
	ld (__salir_tras_registro_mayor), a
	ld (__salir_tras_iguales), a
	ld (__salir_tras_registro_menor), a

	call buscar_generico
	RET



print_registros_busquedas_paginados:
	ld a, iyl
	cp 0
	ret z

	call PrintRegistroCompleto
	call pausa_pagina
	ret	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; el registro termina en 0 o 4
PrintRegistroCompleto:
	inc hl
_prc_loop
	inc hl ;              hl -> primer caracter
	ld a, (hl)
	cp 0
	jr z, _prc_fin
	cp 15
	jp c, _prc_print_comando
		;caracter normal
		call PrintChar ;b no se altera
		jr _prc_loop
_prc_print_comando
	push hl
		call print_comando
	pop hl
	ld a, (hl)
	cp 4
	jr nz, _prc_loop
_prc_fin
	call PrintRet
	ret


;; in: a - comando
;; mod: hl
print_comando:
macro Comparar valor
	cp {valor}
	jr z, _pc_{valor}
endm

macro Etiquetas valor
_pc_{valor}
	ld hl, cmd_{valor}
	jr _pr_print
endm
	; generar condiciones y saltos
	Comparar 1
	Comparar 2
	Comparar 3
	Comparar 4
	Comparar 5
	Comparar 6
	Comparar 7
	Comparar 8
	Comparar 9
	Comparar 10

	Etiquetas 1
	Etiquetas 2
	Etiquetas 3
	Etiquetas 4
	Etiquetas 5
	Etiquetas 6
	Etiquetas 7
	Etiquetas 8
	Etiquetas 9
	Etiquetas 10

_pr_print
	call PrintString
	ret


.cmd_1: db ';dsk;',0
.cmd_2: db ';dir;',0
.cmd_3: db ';run;',0
.cmd_4: db ';cpm',0
.cmd_5: db ';snap;',0
.cmd_6: db ';user;',0
.cmd_7: db ';dsk2;',0
.cmd_8: db ';dsk3;',0
.cmd_9: db ';dsk4;',0
.cmd_10: db ';menu;',0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

insertar:
	SetResultado0

	ld bc, (num_registros)
	call test_bc_igual_0
	jr nz, insertar_caso_generico
	; sigue en insertar_al_principio


;; in
;; hl - byte 0 con el tam del registro
insertar_al_principio:
	ld de, datos
	ld hl, registro
	ld c, (hl)
	ld b, 0            ; bc=tam
	ld (hl), a         ; a=0
	ld (tam_fichero), bc ; actualizar tam fichero
	ldir

	ld bc, 1
	ld (num_registros), bc

	SetResultado1
	RET


insertar_caso_generico:
	ld bc, insertar_insertar
	ld (__funcion_registro_mayor), bc
	
	ld bc, func_nada
	ld (__funcion_registro_menor), bc
	
	xor a
	ld (__salir_tras_registro_menor), a

	ld a, 1
	ld (__salir_tras_registro_mayor), a

	call buscar_generico

	ld a, (resultado)
	cp 1
	ret z ; ret si resultado=1
	call insertar_al_final

	RET
	


insertar_insertar:
	; lo apuntado aqui por hl tiene que moverse
	; a la derecha (de) bytes
	ld (cp_dst), hl ; mv_src_ini

	ld a, (de)
	ld c, a
	ld b, 0 ; bc,a=tam registro

	push hl
		ld hl, (tam_fichero)
		add hl, bc
		ld (nuevo_tam), hl
	pop hl

	add hl, bc ; ahora hl apunta a la direccion destino para ldir
	ld (mv_dst_ini), hl 

	;cantidad de bytes para mover = datos+tam-mv_src
	ld bc, (mv_src_ini)
	call ca2_bc
	ld hl, datos
	add hl, bc
	ld bc, (tam_fichero)
	add hl, bc ; hl=cantidad bytes a mover
	ld (mv_cnt), hl

	;calculamos los finales para lddr
	ld bc, (mv_cnt)

	ld hl, (mv_src_ini)
	add hl, bc
	ld (mv_src_fin), hl

	ld hl, (mv_dst_ini)
	add hl, bc
	ld (mv_dst_fin), hl

	;mover
	ld de, (mv_dst_fin)
	ld hl, (mv_src_fin)
	ld bc, (mv_cnt)
	inc bc
	lddr

	;copiar registro
	ld hl, registro
	ld c,(hl) ; el primer registro
	ld b,0
	ld de, (cp_dst)
	ldir ; copiar registro al hueco

	;actualizar referencias anterior registro
	ld hl, (mv_src_ini)
	ld de, (mv_dst_ini)

	inc de
	inc hl
	ld a, (de)
	ld (hl), a
	dec hl

	ld a,(hl)
	neg
	ld (de), a

	;; actualizar tamanio fichero
	ld bc, (nuevo_tam)
	ld (tam_fichero), bc

	; act num_registros
	ld bc, (num_registros)
	inc bc
	ld (num_registros), bc

	SetResultado1
	RET



;; in: hl - ultimo registro
insertar_al_final:
	push hl
		;longitud ultimo registro+1
		call get_longitud_registro ; <b
	pop hl

	push hl
	push bc ; b=longitud ultimo registro
		ld hl, datos
		ld bc, (tam_fichero)
		add hl, bc 
		ex de, hl ; de=pos.nuevo registro hl 

		push de ; nuevo ultimo registro
			ld hl, registro
			ld c, (hl)
			ld b, 0
			ldir 
		pop de
	pop bc
	pop hl
	;sig reg del ahora penultimo registro
	ld (hl), b

	;byte siguiente registro
	xor a
	ld (de), a
	;byte registro anterior
	inc de
	ld a, b
	neg
	ld (de), a
	
	; act num_registros
	ld bc, (num_registros)
	inc bc
	ld (num_registros), bc

	; act tam_fichero
	ld a, (registro)
	ld c, a
	ld hl, (tam_fichero)
	add hl, bc
	ld (tam_fichero), hl

	SetResultado1
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

eliminar:
	SetResultado0
	ld bc, eliminar_eliminar
	ld (__funcion_iguales), bc

	ld bc, func_nada
	ld (__funcion_registro_menor), bc
	ld (__funcion_registro_mayor), bc

	xor a
	ld (__salir_tras_registro_menor), a
	inc a ; A=1
	ld (__salir_tras_registro_mayor), a
	ld (__salir_tras_iguales), a

	call buscar_generico
	RET



eliminar_eliminar:
	; hl = registro a eliminar = dir_registro = mv_dst_ini
	; bytes a mover = DATOS+nuevo_tam-dir_registro
	; se mueven con LDIR
	; hl = dir_registro + tam_registro
	; de = dir_registro

	;inicio destino
	ld (mv_dst_ini), hl

	ld a, (hl)
	ld (offset_registro_anterior), a

	ld c, a
	ld b, 0 ;bc=cantidad de bytes a eliminar

	;inicio origen
	add hl, bc
	ld (mv_src_ini), hl

	; calcular el nuevo tamanio
	ld hl, (tam_fichero)
	add hl, bc ;bc=cantidad de bytes a eliminar
	ld (nuevo_tam), hl

	;bytes a mover = DATOS+nuevo_tam-dir_registro
	ld bc, (nuevo_tam)
	ld hl, DATOS
	add hl, bc
	ld bc, (mv_dst_ini)
	call ca2_bc
	add hl, bc ; hl=bytes a mover

	ld b,h
	ld c,l ;bc=bytes a mover
	ld hl, (mv_src_ini)
	ld de, (mv_dst_ini)
	ldir

	; modificar el enlace al registro anterior
	ld hl, mv_dst_ini
	inc hl
	ld a, (offset_registro_anterior)
	ld (hl), a

	;actualizar tamanio fichero
	ld bc, (nuevo_tam)
	ld (tam_fichero), bc

	ld bc, (num_registros)
	dec bc
	ld (num_registros), bc

	SetResultado1
	RET
		
.offset_registro_anterior: db 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


cargar:
	SetResultado0

	ld hl, registro
	call get_longitud_cadena ; <b

	ld hl, registro
	ld de, datos
	call #bc77;abrir fichero
	; si todo va bien C=1 Z=0
	ret nc
	ret z
	
	ld hl, datos
	call #bc83 ;leer datos
	; si todo va bien C=1 Z=0
	ret nc
	ret z

	call #bc7a ;cerrar fichero

	call contar

	SetResultado1

	ret
	


guardar:
	SetResultado0

	ld hl, registro
	call get_longitud_cadena

	ld hl, registro
	call #bc8c

	;si todo va bien C=1
	ret nc

	call contar
	ld d, ixh
	ld e, ixl ; de=numero de bytes bytes
	ld hl, datos
	ld a, 2 ; tipo binario
	ld bc, datos
	call #bc98 ; escribir fichero completo
	;  si todo va bien C=1 Z=0
	ret nc
	ret z

	;cerrar fichero
	call #bc8f
	;  si todo va bien C=1 Z=0
	ret nc
	ret z

	SetResultado1
	ret
	


listar_todos:
	ld bc, (num_registros)
	call test_bc_igual_0
	ret z

	ld bc, _salir_listado
	ld (__salir_pagina), bc
	ld iyh, 0 ; contador lineas
	ld hl, datos
_lt_loop
	push hl
		call PrintRegistroCompleto
	pop hl

	ld a, (hl)
	cp 0
	ret z ; se ha alcanzado el final

	ld b, 0
	ld c, a
	add hl, bc

	call pausa_pagina
	jr _lt_loop



;; iyl = contador lineas
pausa_pagina:
	inc iyh
	ld a, iyh
	cp 25
	ret nz
	ld iyh, 0
_pp_loop
	CALL &BB18 ;pausa para pulsacion tecla
	cp ' '
	ret z
	cp 'q'
	jr z, _pp_salir
	cp 'Q'
	jr z, _pp_salir
	jr _pp_loop
_pp_salir
	call #bb03 ; reinicializa buffers de teclado
	jp #0000
	__salir_pagina equ $-2
_salir_busqueda
	pop bc
_salir_listado
	pop bc
	pop bc
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; debe haber al menos un registro
;; out
;; de - num registros
;; ix - bytes
contar: ;;_registros:
	ld hl, datos
	ld b,0
	ld de, 0 ; contador de registros
	ld ix, 0 ; contador de bytes
_contar_loop
	inc de
	ld a, (hl)
	ld c, a
	add ix, bc ; incrementamos bytes
	cp 0
	jr z, _contar_salir
	add hl, bc
	jr _contar_loop
_contar_salir
	inc hl ; offset reg ant
	inc hl ; primera letra
	inc ix
	inc ix
	call contar_tamanio_ultimo_registro
	ld (num_registros), de
	ld b, ixh
	ld c, ixl
	ld (tam_fichero), bc
	RET



contar_tamanio_ultimo_registro:
	ld a, (hl)
	inc hl
	inc ix
	cp 0
	jr nz, contar_tamanio_ultimo_registro
	ret



;mostrar:
;	ld ix, datos
;_m_loop
;	xor a
;	cp (ix+0)
;	ret z
;
;	push ix
;	pop hl
;	inc hl
;	inc hl
;	call PrintString
;	
;	ld a, 13
;	call PrintChar
;	ld a, 10
;	call PrintChar
;
;	ld c, (ix+0)
;	ld b, 0
;	add ix, bc
;	jr _m_loop
	


;; obtiene la longitud de una cadena que acaba en 0
;; in
;; hl - cadena
get_longitud_cadena:
	ld b, 0 ; contador
	xor a
_glc_loop
	cp (hl)
	ret z
	inc hl
	inc b
	jr _glc_loop



;; el registro termina en 0 o 4
;; in
;; hl - registro
;; out
;; b - tamanio del registro
get_longitud_registro:
	inc hl
	inc hl ; ignoramos los dos primeros bytes
	ld b, 3
_glr_loop
	ld a, (hl)
	cp 0
	ret z
	cp 4
	ret z
	inc hl
	inc b
	jr _glr_loop



PrintString:
	ld a,(hl)
	cp 30
	ret c
	inc hl
	call PrintChar
	jr PrintString



PrintRet:
	ld a, 13
	call PrintChar
	ld a, 10
	call PrintChar
	ret



;PrintNombreRegistro:
;	push hl
;		inc hl
;		inc hl
;		call PrintString
;		call PrintRet
;	pop hl
;	ret



test_bc_igual_0:
	xor a
	cp c
	ret nz
	cp b
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;ld_hl_ix
;	ld a, ixh
;	ld h, a
;	ld a, ixl
;	ld l, a
;ret


macro neg_r16 r1, r2
ca2_{r1}{r2}:
	ld a, r1
	cpl
	ld r1, a

	ld a, r2
	cpl
	ld r2, a

	inc {r1}{r2}

	ret
endm

;;;; crear macros de complemento a 2 de registros dobles

;neg_r16 h, l
;neg_r16 d, e
neg_r16 b, c

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
