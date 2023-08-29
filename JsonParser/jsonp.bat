@echo off
powershell -ExecutionPolicy Bypass -File jsonParser.ps1 %*
pause
exit /b