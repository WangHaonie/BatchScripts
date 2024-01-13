@echo off
powershell -ExecutionPolicy Bypass -File VideoDurationCalc.ps1 %*
pause
exit /b