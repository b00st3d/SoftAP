@echo off
title SoftAP
CLS 
:checkPrivileges 
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges ) 

:getPrivileges 
if '%1'=='ELEV' (shift & goto gotPrivileges)  
ECHO. 
ECHO +=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=+
ECHO + This script requires admin rights in order to create access points.       +
ECHO +=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=+

setlocal DisableDelayedExpansion
set "batchPath=%~0"
setlocal EnableDelayedExpansion
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs" 
ECHO UAC.ShellExecute "!batchPath!", "ELEV", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs" 
"%temp%\OEgetPrivileges.vbs" 
exit /B 

:gotPrivileges 
::::::::::::::::::::::::::::
:run
::::::::::::::::::::::::::::
setlocal & pushd .
:start
cls
echo +=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=+
call :animate
echo +                                 +
call :animate
echo + 1.) Create a new AP             +
call :animate
echo +                                 +
call :animate
echo + 2.) Stop an existing AP         +
call :animate
echo +                                 +
call :animate
echo + 3.) Show current AP Stats       +
call :animate
echo +=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=+
call :animate
echo + 4.) HELP                        +
call :animate
echo +                                 +
call :animate
echo + 5.) EXIT                        +
call :animate
echo +                                 +
call :animate
echo +=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=+
call :animate
choice /c 12345c /N /M "Please make a selection: 
if %errorlevel% == 1 ( goto ap )
if %errorlevel% == 2 ( goto stopAP )
if %errorlevel% == 3 ( goto show )
if %errorlevel% == 4 ( goto help )
if %errorlevel% == 5 ( exit )
if %errorlevel% == 6 ( start & goto start )




:ap

REM Clearing any previous hostednetwork that is still on the machine
echo preparing hosted network...
netsh wlan stop hostednetwork >nul
timeout 1 >nul
netsh wlan set hostednetwork mode=disallow >nul
timeout 1 >nul

cls
echo +=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=+
call :animate
echo +SSID:                                            
call :animate
echo +=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=+
call :animate
set /p ssid=Please enter an SSID:
cls 
echo +=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=+
call :animate
echo +SSID: %ssid%                                     
call :animate
echo +=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=+
call :animate
set /p key=Please enter a network key: 
cls
echo +=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=+
call :animate
echo +SSID: %ssid%                                     
call :animate
echo +                                                 
call :animate
echo +Creating your new Access point.  Please wait.    
call :animate
echo +=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=+

netsh wlan set hostednetwork ssid=%ssid% key=%key% keyUsage=persistent mode=allow
timeout 1 >nul
netsh wlan start hostednetwork
timeout 2 >nul
goto start

:stopAP
cls
echo +=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=+
call :animate
echo + Stopping your Accesspoint                       
call :animate
echo +=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=+
REM Clearing any previous hostednetwork that is still on the machine
netsh wlan stop hostednetwork >nul
netsh wlan set hostednetwork mode=disallow >nul
taskkill /im mshta.exe
goto start

:show
setlocal enabledelayedexpansion
cls 
netsh wlan show hostednetwork 

echo.
echo.
echo press any letter or number to return to main menu.

choice /c abcdefghijklmnopqrstuvwxyz0123456789€ /t 5 /d € >nul
if "!errorlevel!" == "37" (
goto show
) else (
endlocal
goto start
)
endlocal
goto start

:animate

ping localhost -n 1 > nul
goto :EOF

:help
cls
echo +=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=+
call :animate                                                                 
echo + After creating your access point it may be                                +
call :animate                                                                  
echo + neccessary to make some changes to the virtual                            +
call :animate                                                                   
echo + WiFi Miniport Adapter that was created.                                   +
call :animate                                                                   
echo +                                                                           +
call :animate                                                                   
echo + To do this, after the the ap has been created,                            +
call :animate                                                                    
echo + open your adapter settings.  Find your connection to the internet.        +
call :animate                                
echo +                                                                           +
call :animate
echo + 1.) Right click select properties.                                        +
call :animate
echo + 2.) Click the 'Sharing' tab.                                              +
call :animate
echo + 3.) Check Allow other network users to connect through this...            +
call :animate
echo + 4.) Select your new connection (It should show your SSID in it)           +
call :animate
echo + 5.) Click ok                                                              +
call :animate
echo +                                                                           +
call :animate
echo + When finished, press any key to continue                                  +
call :animate
echo +=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=+
pause >nul
cls
goto start