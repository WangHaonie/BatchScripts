@echo off
echo ManualCheckWinUpdate v1.0 by WangHaonie
echo GitHub: https://github.com/WangHaonie/BatchScripts/tree/main/ManualCheckWinUpdate
echo 该工具可以实现手动检查更新的功能

start ms-settings:windowsupdate
usoclient startinteractivescan
echo.
echo 运行成功
exit /b
