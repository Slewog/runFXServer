@echo OFF

rem Set the path with the Hard Drive and the Name.
SET directory=c:\FXServer

rem Path to the server.
SET executable=%directory%\server

rem Path to the server data.
SET data=%directory%\server-data

rem Path to the resources.
SET resource=%data%\resources\

rem Path to the config server file.
SET config=%data%\server.cfg

rem Path to the server cache file.
SET cache=%data%\cache

rem Path to the new backup directory and get the date and hour of the boot.
SET backup=%directory%\backup\%DATE:~0,2%-%DATE:~3,2%-%DATE:~6,10%_%TIME:~0,2%H%TIME:~3,2%M%TIME:~6,2%\

echo Suppression des caches serveur en cours...
@echo OFF
RMDIR /s /q "%cache%\files"
echo -
echo Suppression des caches serveur finies !
echo -
echo ----------------------------------
echo -
goto :main

:main
SET choose_backup=
SET /p choose_backup=Want you make a backup of your server data? [Y/N]:
IF NOT '%choose_backup%'=='' SET choose_backup=%choose_backup:~0,1%
IF '%choose_backup%'=='Y' GOTO :backup
IF '%choose_backup%'=='y' GOTO :backup
IF '%choose_backup%'=='N' GOTO :boot
IF '%choose_backup%'=='n' GOTO :boot
echo Your input is not valid, please answer with Y or N
goto :main

:backup
echo -
echo Back-up du serveur en cours...
@echo OFF
mkdir %backup%
XCOPY "%resource%" "%backup%" /e /i
echo -
echo Back-up du serveur en finie !
echo ----------------------------------
echo -
goto :boot

:boot
SET choose_boot = 
SET /p choose_boot=Want you launch your server with FXServer.exe? [Y/N]:
IF NOT '%choose_boot%'=='' SET choose_boot=%choose_boot:~0,1%
IF '%choose_boot%'=='Y' GOTO :fxserver
IF '%choose_boot%'=='y' GOTO :fxserver
IF '%choose_boot%'=='N' GOTO :cmd
IF '%choose_boot%'=='n' GOTO :cmd
echo Your input is not valid, please answer with Y or N
goto :boot

:fxserver
cd %data%
start %executable%\FXServer.exe
wmic Path win32_process Where "Caption Like 'cmd%.exe'" Call Terminate

:cmd
CLS
cd %data%
cmd /k %executable%\run.cmd +exec %config%
