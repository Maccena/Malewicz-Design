@echo off
REM Runs install.ps1 without requiring a change to the PowerShell ExecutionPolicy.
REM Arguments ending in a backslash get a "." appended, otherwise the \" fuses arguments.
setlocal DisableDelayedExpansion
set "HERE=%~dp0"
set "ARGS="
:loop
if "%~1"=="" if [%1]==[] goto run
set "A=%~1"
if not defined A goto empty
if "%A:~-1%"=="\" set "A=%A%."
set ARGS=%ARGS% "%A%"
goto next
:empty
set ARGS=%ARGS% ""
:next
shift
goto loop
:run
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -File "%HERE%install.ps1" %ARGS%
exit /b %ERRORLEVEL%
