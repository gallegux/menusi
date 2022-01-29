# menusi
A launcher for UsifacII and M4, and other utilities

## How to use
Write a CSV file following the format of menusi_data.csv file.

Or fill the menusi_data.ods file following the format and instructions inside the file.
Execute create_data_file.bat (requires Java 11 at least) with two arguments:
- the csv file
- data file for amstrad cpc (name with 8 characters)

Example:
create_data_file my_amstrad_games.csv MYGAMES.DAT

Modify menusi.bas writing in the first line the name of the file generated.
So, you can have several menus, for your programs, sports, arcades, cars, etc. using several .bas files and one binary program.

Copy your data file to your pendrive or SD card. Copy menusi.bas and menusi.bin if you don't have them on the pendrive or SD.
In CPC execute run"menusi.bas"

You can put the files in a folder other than the root and modify the bas file to add the |CDR (in Usifac) command once the files have been loaded into memory.

## Problems?  Suggestions?
You can write to gallegux@hotmail.com

-------------------------------------------------------------------

# menusi

Lanzador para programas en UsifacII y en M4, y otras utilizades.

## Cómo usarlo

### Escribe un fichero CSV (texto plano) siguiendo el siguiente formato.

Primer campo: nombre del programa
Campos pares: tipo de orden para alcanzar el ejecutable
  DSK: para montar una imagen dsk
  DIR: para acceder a un directorio
  RUN: para ejecutar un programa
  CPM: para ejecutar el S.O. CPM (será necesario montar previamente un disco)
  SANP: para abrir un fichero SNAP
  USER: para acceder al usuario de un disco (será necesario montar previamente un disco)
Campos impares (excepto el primero): argumento para el campo par anterior

Ejemplo de fila:
  La Abadia del Crimen;DIR;juegos;DSK;abadia.dsk;CPM

### Usa una hoja de datos

Una forma más fácil de mantener esta pequeña base de datos es con ayuda del fichero menusi_data.ods (LibreOffice).
Para usarlo posteriormente hay que exportarlo usando ; como separador de campos y no incluyendo " en los campos.

### Genera el fichero para Amstrad

Ejecuta el fichero create_data_file.bat para generar el fichero de datos para Amstrad

La sintaxis es:  create_data_file  fichero.csv menusi.dat

### Copia los ficheros a la tarjeta SD o pendrive a usar con el Amstrad

Los ficheros que se necesitan en el Amstrad son MENUSI.BAS, MENUSI.BIN y MENUSI.DAT y ejecuta MENUSI.BAS

## Problemas? Sugerencias?

Escribe un correo a gallegux@hotmail.com
