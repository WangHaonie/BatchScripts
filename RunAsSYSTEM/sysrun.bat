@echo off
rem RunAsSYSTEM v1.0 by WangHaonie
cd /d %~dp0
set "PsExec=.\PsExec.exe"
if "%~1"=="" (
    echo �������нű�ʱ�ṩ������
    echo �÷�: %~nx0 ^<����^>
    exit /b
)

if not exist "%PsExec%" (
    echo �������ر�Ҫ�����PsExec.exe�����Ժ�...
    powershell -ExecutionPolicy Bypass -Command "Invoke-WebRequest -UseBasicParsing -Uri 'https://live.sysinternals.com/PsExec.exe' -OutFile '%PsExec%'" || (
        echo PsExec.exe ����ʧ�ܣ���ȷ����ǰ��������ͨ�������ֶ����� https://live.sysinternals.com/PsExec.exe ����ǰ�ű������ļ���
        pause >nul
    )
    echo ���سɹ����ѱ����� %PsExec%
)

if exist "%PsExec%" (
    echo ��ִ�����%*
    start /min "" "%PsExec%" -accepteula -nobanner -i -d -s cmd.exe /c %*
    exit /b
) else (
    echo �޷��ҵ� PsExec.exe
)