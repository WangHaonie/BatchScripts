@echo off

if "%1" == "" (
    goto :usage
)

if "%2" == "" (
    goto :usage
)

for %%a in (*.%1) do (
    ffmpeg -i "%%a" -c:v copy -c:a copy "%%~na.%2"
)

goto :eof

:usage
echo.
echo fm v1.0.1 by WangHaonie
echo CWD: %cd%\
echo.
echo Usage: fm ^<input_format^> ^<output_format^>
exit /b