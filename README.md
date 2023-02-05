# MMM (Menusi Menu Maker)

- PC application to create the menus instead editing a text file.
- The new CPC files are stored in a pendrive or SD card with the the PC application.
- Some bugs correted in CPC files.
- Help included.
- Download MMM_v2b.jar (compiled with Java14)

---------------------------------------------

# menusi
A menu launcher for UsifacII and M4.

## How to use

**Write a CSV file** following the format of menusi_data.csv file. The format is very simple:

- First field: name of program or menu (it's recommended that it be no longer than 24 characters). If the the name is a menu it must start with **>** (greather than character).
- Even fields: kind or order to reach the runnable program
  * DSK: to mount a disc image file (with USIFAC, like |MG) or to access to a disc image (M4)
  * DSK2: to mount a second disc image file (with USIFAC, like |MG2)
  * DSK3: to mount a third disc image file (with USIFAC, like |MG3)
  * DSK4: to mount a fourth disc image file (with USIFAC, like |MG4)
  * DIR: to access to a directory
  * RUN: to run a program
  * CPM: to run the CPM OS
  * SNAP: to open a SNAP file
  * USER: to access to the user of a disc
  * MENU: to show other menu content (defined in other file)
- Odd fields (except the first one): argument to the previous field, except for CPM.

##### Note:
If you need mount several disk with USIFAC, mount the first one last end because after doing |MG it does |FDC

Examples:

`La Abadia del Crimen;DIR;juegos;DIR;abadia;DSK;abadia;CPM`  I have that game in /juegos/abadia/abadia.dsk and I run it writing |CPM

`Batman;DIR;juegos;DIR;batman3d;RUN;batman.bas`  I have that game in /juegos/batman3d and I write RUN"BATMAN.BAS to run it.

`Out Run;DIR;juegos;DIR;outrun;DSK2;outrun2.dsk;DSK;outrun1.dsk;RUN;outrun.bas`  I put outrun1.dsk after outrun2.dsk.

`> My favourites games;MENU;favgames.dat`  A link to other menu defined in other file.

Remember that you have to write the extension in USIFACII (not neccesary with 6a version firmware).

Another way to maintain the CSV file is **using a ODS file** (I use LibreOffice Calc to do it).
If you use it, you will have to export to CSV using **;** (semicolon) as separator.

Anyway, you can watch the examples, **menusi_data.csv** and **menusi_data.ods**, that it has instructions inside.

When you have the CSV file you have to **generate the data file for USIFAC**. 
For that use **create_data_file.bat** with two arguments:
- the CSV file
- data file for Amstrad cpc (8+3 format)

Example:
`create_data_file.bat  my_amstrad_games.csv  MENUSI.DAT`

##### Important:
- The maximum file size is 35.325 bytes. If you use a greater file the system won't work correctly.
- The lines in the CSV file must be well. The last word must be **cpm** or the name of the program after **run**. A line ended with `dir` or `run` (for example) will do the program crashes.

**Modify menusi.bas** writing in the first line the name of the file generated.
So, you can have several menus, for your programs, sports, arcades, cars, etc. using several .bas files and one binary program.

**Copy your data file** to your pendrive or SD card.
menusi.bas --> /menusi/menusi.bas
menusi.bin --> /menusi/menusi.bin
MENUSI.DAT --> /menusi/menusi.dat
m.bas --> /

So, when you enter to root of your USIFAC or M4, you just have write RUN"M.BAS

### Resume
You can watch all the process in **diagram.png**

## Running the program on CPC
Place on **/** and write `run"m.bas` or `run"mh.bas`. The keys that you can use are:
- Cursor keys: move the cursor that selects a program
- Enter: execute the selectec program
- Del: go back to previous menu (if it exists)
- Esc: exit

`run"mh.bas` first shows the help and then the menu.

## Problems?  Suggestions?
You can write to gallegux@hotmail.com

-------------------------------------------------------------------


# menusi
Un menú lanzador para UsifacII y M4.

## Cómo usarlo

**Escribe un archivo CSV** siguiendo el formato del archivo menusi_data.csv. El formato es muy simple:

- Primer campo: nombre del programa o submenú (se recomienda que no tenga más de 24 caracteres). Si es un menú debe empezar con **>** (carácter mayor que).
- Campos pares: tipo de orden para llegar al programa ejecutable
  * DSK: para montar un archivo de imagen de disco (con USIFAC, como |MG) o para acceder a una imagen de disco (M4)
  * DSK2: para montar un segundo archivo de imagen de disco (con USIFAC, como |MG2)
  * DSK3: para montar un tercer archivo de imagen de disco (con USIFAC, como |MG3)
  * DSK4: para montar un cuarto archivo de imagen de disco (con USIFAC, como |MG4)
  * DIR: para acceder a un directorio
  * RUN: para ejecutar un programa
  * CPM: para ejecutar el sistema operativo CPM
  * SNAP: para abrir un archivo SNAP
  * USER: para acceder al usuario de un disco
  * MENU: para mostrar el contenido de otro menú (definido en otro fichero)
- Campos impares (excepto el primero): argumento del campo anterior, excepto para CPM.

Ejemplos:

`La Abadia del Crimen;DIR;juegos;DIR;abadia;DSK;abadia;CPM`  Ese juego lo tengo en /juegos/abadia/abadia.dsk y lo ejecuto escribiendo |CPM

`Batman;DIR;juegos;DIR;batman3d;RUN;batman.bas`  Ese juego lo tengo en /juegos/batman3d y escribo RUN"BATMAN.BAS para ejecutarlo.

`Out Run;DIR;juegos;DIR;outrun;DSK2;outrun2.dsk;DSK;outrun1.dsk;RUN;outrun.bas`  Pongo `DSK;outrun1.dsk` después de `DSK2;outrun2.dsk`

`> Mis juegos;MENU;favgames.dat`  Un enlace a otro menú definido en otro fichero.

Recuerda que tienes que escribir la extensión en USIFACII (no es necesario con la versión 6a del firmware).

Otra forma de mantener el archivo CSV es **usar un archivo ODS** (yo uso LibreOffice Calc para hacerlo).
Si lo usas, tendrás que exportar a CSV usando **;** (punto y coma) como separador.

De todos modos, puedes ver los ejemplos, **menusi_data.csv** y **menusi_data.ods**, que tiene instrucciones dentro.

Cuando tengas el archivo CSV, debes **generar el archivo de datos para USIFAC**.
Para eso usa **create_data_file.bat** con dos argumentos:
- el archivo csv
- archivo de datos para amstrad cpc (formato 8+3)

Ejemplo:
`create_data_file.bat my_amstrad_games.csv MENUSI.DAT`

##### Importante:
- El tamaño máximo del fichero es 35.325 bytes. Si usas uno más grande el sistema no funcionará correctamente.
- Las líneas en el fichero CSV debes estar bien formadas. Las última palabra debe se **cpm** o el nombre del probrama después de **run**. Una línea acabada en `dir` o `run` (por ejemplo) hará que el programa no funcione, e incluso cuelgue el ordenador.

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

## Ejecutar el programa en el CPC
Sitúate en **/** y escribe `run"m.bas` o `run"mh.bas`. Las teclas que puedes usar son:
- Teclas del cursor: mover el cursor que selecciona un programa
- Enter: ejecutar el programa seleccionado
- Del: volver al menú anterior (si es que lo hay)
- Esc: salir

`run"mh.bas` primero muestra la ayuda y luego el menú.

## ¿Problemas? ¿Sugerencias?
Puedes escribir a gallegux@hotmail.com
