@echo off
rem RunAsSYSTEM v1.0 by WangHaonie
cd /d %~dp0
set "PsExec=.\PsExec.exe"
if "%~1"=="" (
    echo 请在运行脚本时提供参数。
    echo 用法: %~nx0 ^<命令^>
    exit /b
)

if not exist "%PsExec%" (
    echo 正在下载必要组件：PsExec.exe，请稍候...
    powershell -ExecutionPolicy Bypass -Command "Invoke-WebRequest -UseBasicParsing -Uri 'https://live.sysinternals.com/PsExec.exe' -OutFile '%PsExec%'" || (
        echo PsExec.exe 下载失败，请确保当前网络连接通畅或者手动下载 https://live.sysinternals.com/PsExec.exe 到当前脚本所在文件夹
        pause >nul
    )
    echo 下载成功，已保存至 %PsExec%
)

if exist "%PsExec%" (
    echo 已执行命令：%*
    start /min "" "%PsExec%" -accepteula -nobanner -i -d -s cmd.exe /c %*
    exit /b
) else (
    echo 无法找到 PsExec.exe
)