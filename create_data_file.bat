@echo off

rem %1 CSV file
rem %2 DAT file for Amstrad CPC

rem java csv2dat menusi_data.csv temp_file
rem java AddAmsdosHeader menusi.dat temp_file

java csv2dat %1 temp_file
java AddAmsdosHeader %2 temp_file

del temp_file
