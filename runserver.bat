@echo OFF

rem Get the date and the hour of the boot.
SET day=%DATE:~0,2%-%DATE:~3,2%-%DATE:~6,10%
SET hour=%TIME:~0,2%H%TIME:~3,2%M%TIME:~6,2%

rem Server name.
SET name=e:\FXServer
rem Path to the server executable.
SET executable=%name%\server\run.cmd
rem Path to the server data.
SET data=%name%\server-data


rem Path to the resources.
SET resource=%data%\resources\[ SCRIPTS ]
rem Path to the config server file.
SET config=%data%\server.cfg
rem Path to the server cache file.
SET cache=%data%\cache
rem Path to the new backup directory.
SET backup=%name%\backup\%day%_%hour%\

echo Suppression des caches serveur en cours...
@echo OFF
RMDIR /s /q "%cache%\files"
echo Suppression des caches finies !
echo -
echo ----------------------------------
echo -
goto :main

:main
SET choose_back_up=
SET /p choose_back_up=Want you make a backup of your server data? [Y/N]:
IF NOT '%choose_back_up%'=='' SET choose_back_up=%choose_back_up:~0,1%
IF '%choose_back_up%'=='Y' GOTO :backup
IF '%choose_back_up%'=='y' GOTO :backup
IF '%choose_back_up%'=='N' GOTO :boot
IF '%choose_back_up%'=='n' GOTO :boot
echo Your input is not valid, please answer with Y or N
goto :main

:backup
echo -
echo Back-up du serveur en cours...
@echo OFF
mkdir %backup%
rem XCOPY %resource% %backup% /m /e /y
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
cd %executable%
start FXServer.exe
wmic Path win32_process Where "Caption Like 'cmd%.exe'" Call Terminate

:cmd
cd %data%
cmd /k %executable% +exec %config%