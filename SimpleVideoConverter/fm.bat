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
echo �ù��߿��Կ�ݵ�ת����ǰĿ¼�µ���Ƶ��ʽ
echo.
echo ��ǰ�����ļ���: %cd%\
echo.
echo �÷�: fm ^<ԭʼ��ʽ^> ^<Ŀ���ʽ^>
exit /b