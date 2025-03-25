@echo off
color 05
title Cleaner PT1 - Fortnite Ban Trace Cleaner
cls

:: Check if running as administrator
cd /d "%~dp0"
fsutil dirty query %systemdrive% >nul
if %errorlevel% NEQ 0 (
    echo Requesting Administrator access...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    timeout /t 2 >nul
    exit /b
)

:: Main Menu
:MAIN_MENU
cls
echo             ===========================================================
echo                           CLEANER PT1 - BAN TRACE CLEANER
echo             ===========================================================
echo.
echo             [1] Clear All Ban Traces
echo             [2] Exit
echo.
set /p choice=Enter your choice (1-2): 

if "%choice%"=="1" goto CLEAN_MODE
if "%choice%"=="2" exit
echo Invalid choice! Please try again.
timeout /t 2 >nul
goto MAIN_MENU

:CLEAN_MODE
cls
echo Running Ban Trace Cleaner... Please wait.

:: LOG OUT OF FORTNITE & EPIC GAMES BY CLEARING SESSION & CACHE FILES
if exist "%LocalAppData%\EpicGamesLauncher\Saved\webcache*" (
    rd /s /q "%LocalAppData%\EpicGamesLauncher\Saved\webcache*"
)

:: Clear cookies, login data, and sessions
if exist "%AppData%\EpicGamesLauncher\Saved\webcache\Cookies" (
    del /f /q "%AppData%\EpicGamesLauncher\Saved\webcache\Cookies"
)
if exist "%AppData%\EpicGamesLauncher\Saved\webcache\LoginData" (
    del /f /q "%AppData%\EpicGamesLauncher\Saved\webcache\LoginData"
)
if exist "%LocalAppData%\EpicGamesLauncher\Saved\Auth" (
    rd /s /q "%LocalAppData%\EpicGamesLauncher\Saved\Auth"
)

:: Remove session and login data (JSON and DB files)
if exist "%LocalAppData%\EpicGamesLauncher\Saved\*.json" (
    del /f /q "%LocalAppData%\EpicGamesLauncher\Saved\*.json"
)
if exist "%LocalAppData%\EpicGamesLauncher\Saved\*.db" (
    del /f /q "%LocalAppData%\EpicGamesLauncher\Saved\*.db"
)

:: KILL FORTNITE AND EPIC GAMES PROCESSES IF RUNNING
tasklist | find /i "EpicGamesLauncher.exe" >nul && taskkill /F /IM "EpicGamesLauncher.exe" /T >nul 2>&1
tasklist | find /i "FortniteClient-Win64-Shipping.exe" >nul && taskkill /F /IM "FortniteClient-Win64-Shipping.exe" /T >nul 2>&1
tasklist | find /i "FortniteLauncher.exe" >nul && taskkill /F /IM "FortniteLauncher.exe" /T >nul 2>&1

:: CLEAN FORTNITE GAME CACHE, LOGS & TEMP FILES
if exist "%LocalAppData%\FortniteGame\Saved\Logs" (
    rd /s /q "%LocalAppData%\FortniteGame\Saved\Logs"
)
if exist "%LocalAppData%\FortniteGame\Intermediate" (
    rd /s /q "%LocalAppData%\FortniteGame\Intermediate"
)
if exist "%Temp%\Fortnite*" (
    del /f /q "%Temp%\Fortnite*"
)

:: CLEAN EPIC GAMES LAUNCHER CACHE & LOGS
if exist "%ProgramData%\Epic" (
    rd /s /q "%ProgramData%\Epic"
)
if exist "%ProgramData%\Epic Games" (
    rd /s /q "%ProgramData%\Epic Games"
)
if exist "%Temp%\EpicGamesLauncher*" (
    del /f /q "%Temp%\EpicGamesLauncher*"
)

:: REMOVE FORTNITE & EPIC GAMES CRASH LOGS & DUMPS
if exist "%LocalAppData%\CrashDumps" (
    del /f /q "%LocalAppData%\CrashDumps\*"
)
if exist "%AppData%\EpicGamesLauncher\Saved\Logs" (
    del /f /q "%AppData%\EpicGamesLauncher\Saved\Logs\*"
)

:: CLEAN REGISTRY KEYS FOR FORTNITE AND EPIC GAMES
reg delete "HKEY_CURRENT_USER\Software\Epic Games\Fortnite" /f >nul 2>&1
reg delete "HKEY_CURRENT_USER\Software\Epic Games" /f >nul 2>&1

:: REMOVE EASYANTICHEAT FILES AND LOGS
if exist "%ProgramFiles(x86)%\EasyAntiCheat" (
    rd /s /q "%ProgramFiles(x86)%\EasyAntiCheat"
)
if exist "%ProgramFiles(x86)%\Common Files\EasyAntiCheat" (
    rd /s /q "%ProgramFiles(x86)%\Common Files\EasyAntiCheat"
)

:: REMOVE BATTLEYE FILES AND LOGS
if exist "%ProgramFiles(x86)%\Common Files\BattlEye" (
    rd /s /q "%ProgramFiles(x86)%\Common Files\BattlEye"
)
if exist "%LocalAppData%\BattlEye" (
    rd /s /q "%LocalAppData%\BattlEye"
)

:: REMOVE EASYANTICHEAT AND BATTLEYE REGISTRY ENTRIES
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\EasyAntiCheat" /f >nul 2>&1
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\BattlEye Innovations" /f >nul 2>&1

:: REMOVE FORTNITE PREFETCH AND RECENT FILES
if exist "%SystemRoot%\Prefetch\FORTNITE*" (
    rd /s /q "%SystemRoot%\Prefetch\FORTNITE*"
)
if exist "%AppData%\Microsoft\Windows\Recent\FORTNITE*.lnk" (
    del /f /q "%AppData%\Microsoft\Windows\Recent\FORTNITE*.lnk"
)

:: CLEAN WINDOWS SHADER CACHE (FORTNITE MAY USE SHADERS)
if exist "%LocalAppData%\Microsoft\DirectX Shader Cache" (
    rd /s /q "%LocalAppData%\Microsoft\DirectX Shader Cache"
)

:: REMOVE NVIDIA AND AMD SHADER CACHE (DOES NOT AFFECT GRAPHICS)
if exist "%LocalAppData%\NVIDIA\DXCache\*" (
    del /f /q "%LocalAppData%\NVIDIA\DXCache\*"
)
if exist "%LocalAppData%\AMD\DxCache\*" (
    del /f /q "%LocalAppData%\AMD\DxCache\*"
)

:: CLEAR WMI LOGS TO REMOVE SYSTEM EVENT TRACES
if exist "%SystemRoot%\System32\LogFiles\WMI\*" (
    del /f /q "%SystemRoot%\System32\LogFiles\WMI\*"
)

:: DISABLE XBOX LIVE SERVICES (IF LINKED TO GAME LOGGING)
sc stop "XblAuthManager" >nul 2>&1
sc config "XblAuthManager" start= disabled >nul 2>&1
sc stop "XblGameSave" >nul 2>&1
sc config "XblGameSave" start= disabled >nul 2>&1

:: CLEAR SYSTEM EVENT LOGS FOR FORTNITE/EPIC GAMES
wevtutil cl Application >nul 2>&1
wevtutil cl Security >nul 2>&1
wevtutil cl System >nul 2>&1

:: CLEAR WINDOWS ERROR REPORTING LOGS FOR FORTNITE-RELATED CRASHES
if exist "%LocalAppData%\Microsoft\Windows\WER\ReportQueue" (
    rd /s /q "%LocalAppData%\Microsoft\Windows\WER\ReportQueue"
)
if exist "%LocalAppData%\Microsoft\Windows\WER\ReportArchive" (
    rd /s /q "%LocalAppData%\Microsoft\Windows\WER\ReportArchive"
)

:: CLEAN EVENT VIEWER LOGS
wevtutil cl Microsoft-Windows-Diagnostics-Performance/Operational >nul 2>&1

:: DISABLE EASYANTICHEAT AND BATTLEYE SERVICES
sc query EasyAntiCheatSvc | find "RUNNING" >nul && sc stop EasyAntiCheatSvc >nul 2>&1
sc config EasyAntiCheatSvc start= disabled >nul 2>&1
sc query BEService | find "RUNNING" >nul && sc stop BEService >nul 2>&1
sc config BEService start= disabled >nul 2>&1

:: END OF CLEANUP - DISPLAYING CREDITS
cls
echo ===========================================================
echo                 BAN TRACE CLEANING COMPLETE!
echo ===========================================================
echo.
echo               Credits to Middle Man
echo.             
echo             Please Vouch in server EVIL AIM
echo ===========================================================
pause
exit
