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
echo SimpleVideoConverter v1.0.1 by WangHaonie
echo GitHub: https://github.com/WangHaonie/BatchScripts/tree/main/SimpleVideoConverter
echo 该工具可以快捷的转换当前目录下的视频格式
echo.
echo 当前工作文件夹: %cd%\
echo.
echo 用法: fm ^<原始格式^> ^<目标格式^>
exit /b