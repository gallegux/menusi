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
