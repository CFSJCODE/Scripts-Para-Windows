@echo off
setlocal
set "MAIN_SCRIPT="
for %%F in ("%~dp0scripts\00-menu-principal\*.bat") do set "MAIN_SCRIPT=%%~fF"
if not defined MAIN_SCRIPT (
    echo Script principal nao encontrado.
    exit /b 1
)
call "%MAIN_SCRIPT%"
exit /b %errorlevel%
