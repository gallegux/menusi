# menusi
A menu launcher for UsifacII and M4.

## How to use

**Write a CSV file** following the format of menusi_data.csv file. The format is very simple:

- First field: name of program (it's recommended that it be no longer than 24 characters)
- Even fields: kind or order to reach the runnable program
  * DSK: to mount a disc image file (with USIFAC, like |MG) or to access to a disc image (M4)
  * DSK2: to mount a second disc image file (with USIFAC, like |MG2) *not implemented yet*
  * DSK3: to mount a third disc image file (with USIFAC, like |MG3) *not implemented yet*
  * DSK4: to mount a fourth disc image file (with USIFAC, like |MG4) *not implemented yet*
  * DIR: to access to a directory
  * RUN: to run a program
  * CPM: to run the CPM OS
  * SNAP: to open a SNAP file
  * USER: to access to the user of a disc
- Odd fields (except the first one): argument to the previous field.

Examples:

`La Abadia del Crimen;DIR;juegos;DIR;abadia;DSK;abadia;CPM`

I have that game in /juegos/abadia/abadia.dsk and I run it writing |CPM

`Batman;DIR;juegos;DIR;batman3d;RUN;batman.bas`

I have that game in /juegos/batman3d and I write RUN"BATMAN.BAS to run it.

Remember that you have yo write the extension in USIFACII.

Another way to maintain the CSV file is **using a ODS file** (I use LibreOffice Calc to do it).
If you use it, you will have to export to CSV using **;** (semicolon) as separator.

Anyway, you can watch the examples, **menusi_data.csv** and **menusi_data.ods**, that it has instructions inside.

When you have the CSV file you have to **generate the data file for USIFAC**. 
For that use **create_data_file.bat** with two arguments:
- the csv file
- data file for amstrad cpc (8+3 format)

Example:
`create_data_file.bat  my_amstrad_games.csv  MENUSI.DAT`

**Modify menusi.bas** writing in the first line the name of the file generated.
So, you can have several menus, for your programs, sports, arcades, cars, etc. using several .bas files and one binary program.

**Copy your data file** to your pendrive or SD card.
menusi.bas --> /menusi/menusi.bas
menusi.bin --> /menusi/menusi.bin
MENUSI.DAT --> /menusi/menusi.dat
m.bas --> /

So, when you enter to root of your USIFAC or M4, you just have write RUN"M.BAS


## Resume
You can watch all the process in **diagram.png**

## Problems?  Suggestions?
You can write to gallegux@hotmail.com

-------------------------------------------------------------------


# menusi
Un menú lanzador para UsifacII y M4.

## Cómo usarlo

**Escribe un archivo CSV** siguiendo el formato del archivo menusi_data.csv. El formato es muy simple:

- Primer campo: nombre del programa (se recomienda que no tenga más de 24 caracteres)
- Campos pares: tipo de orden para llegar al programa ejecutable
  * DSK: para montar un archivo de imagen de disco (con USIFAC, como |MG) o para acceder a una imagen de disco (M4)
  * DSK2: para montar un segundo archivo de imagen de disco (con USIFAC, como |MG2) *aún no implementado*
  * DSK3: para montar un tercer archivo de imagen de disco (con USIFAC, como |MG3) *todavía no implementado*
  * DSK4: para montar un cuarto archivo de imagen de disco (con USIFAC, como |MG4) *aún no implementado*
  * DIR: para acceder a un directorio
  * RUN: para ejecutar un programa
  * CPM: para ejecutar el sistema operativo CPM
  * SNAP: para abrir un archivo SNAP
  * USER: para acceder al usuario de un disco
- Campos impares (excepto el primero): argumento del campo anterior.

Ejemplos:

`La Abadia del Crimen;DIR;juegos;DIR;abadia;DSK;abadia;CPM`

Ese juego lo tengo en /juegos/abadia/abadia.dsk y lo ejecuto escribiendo |CPM

`Batman;DIR;juegos;DIR;batman3d;RUN;batman.bas`

Ese juego lo tengo en /juegos/batman3d y escribo RUN"BATMAN.BAS para ejecutarlo.

Recuerda que tienes que escribir la extensión en USIFACII.

Otra forma de mantener el archivo CSV es **usar un archivo ODS** (yo uso LibreOffice Calc para hacerlo).
Si lo usas, tendrás que exportar a CSV usando **;** (punto y coma) como separador.

De todos modos, puedes ver los ejemplos, **menusi_data.csv** y **menusi_data.ods**, que tiene instrucciones dentro.

Cuando tengas el archivo CSV, debes **generar el archivo de datos para USIFAC**.
Para eso usa **create_data_file.bat** con dos argumentos:
- el archivo csv
- archivo de datos para amstrad cpc (formato 8+3)

Ejemplo:
`create_data_file.bat my_amstrad_games.csv MENUSI.DAT`

**Modificar menusi.bas** escribiendo en la primera línea el nombre del archivo generado.
Así, puedes tener varios menús, para tus programas, juegos de deportes, juegos de arcade, coches, etc. usando varios archivos .bas y un único programa binario.

**Copia tu archivo de datos** al pendrive o tarjeta SD.
menusi.bas --> /menusi/menusi.bas
menusi.bin --> /menusi/menusi.bin
MENUSI.DAT --> /menusi/menusi.dat
m.bas --> /

Entonces, cuando entres a la raíz de su USIFAC o M4, solo debe escribir **RUN"M.BAS**


## Resumen
Puedes ver todo el proceso en **diagram.png**


## ¿Problemas? ¿Sugerencias?
Puedes escribir a gallegux@hotmail.com
