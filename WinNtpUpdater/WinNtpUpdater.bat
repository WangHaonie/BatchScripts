@echo off
echo WinNtpUpdater v1.0 by WangHaonie
echo GitHub: https://github.com/WangHaonie/BatchScripts/tree/main/WinNtpUpdater
echo 该工具可以解决 Windows 系统时间无法同步或不会同步的情况
echo.
pause
cls
echo 正在设置新的 NTP 服务器：ntp1.aliyun.com
w32tm /config /manualpeerlist:ntp1.aliyun.com /syncfromflags:manual /reliable:YES /update
echo.
echo 正在重新启动 Windows Time 服务
net stop w32time
net start w32time
echo.
echo 正在设置 Windows Time 服务为 自动
sc config w32time start= auto
echo.
echo 正在尝试同步时间
w32tm /resync
echo 当前时间：%DATE%%TIME%
echo.
echo 脚本执行完毕，若你看到了错误，请右键次脚本选择以管理员身份运行
pause >nul