@echo off

rem %1 CSV file
rem %2 DAT file for Amstrad CPC

if "%1"=="" goto help
if "%2"=="" goto help

rem echo %1
rem echo %2

java csv2dat %1 temp_file
java AddAmsdosHeader %2 temp_file
del temp_file
goto fin

:help

echo Arguments: csv_file dat_file
echo    csv_file - the csv file with programs and orders
echo    dat_file - the data file for amstrad cpc (8+3)

:fin
