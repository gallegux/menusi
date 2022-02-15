# menusi-db   -   menusi database simple manager


## What is it?

It's a program to manage the menusi database files from Amstrad CPC, removing the needing to use the PC when you want to add or remove a few registers.
It's made up of MENUSIDB.BIN and MENUSIDB.BAS. The best place is together MENUSI.


## Options:


### 1-Load

Load a menusi database file.


### 2-Search

Search registers by its name. You have to enter the start of register (case sensitive). Then all registers starting with the asked pattern will be shown. If there are a lot of them it will be paused, and the you can press SPACE to continue or Q to stop the listing.


### 3-Insert

Insert a register in the database. You have to introduce the name of the register and the commans as you did in the CSV file. Examples:

```
Name? La Abadia del Crimen
Commands? dir;juegos;dir;abadia;dsk;abadia.dsk;cpm
```

```
Name? Batman 3D
Commands? dir;juegos;dir;batman3d;run;batman.bas
```

The register will be entered in alphabetical order.


### 4-Delete

Delete a register in the database. You must enter the exact name (case sensitive).


### 5-Save

Save the current database in a file. The name of the file will be asked to you.


### 6-List

List all the registers. If there are a lot of them it will be paused, and the you can press SPACE to continue or Q to stop the listing.


### 9-Exit

Exit from the program.
