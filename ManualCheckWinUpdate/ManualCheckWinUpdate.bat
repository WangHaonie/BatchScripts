@echo off
echo ManualCheckWinUpdate v1.0 by WangHaonie
echo GitHub: https://github.com/WangHaonie/BatchScripts/tree/main/ManualCheckWinUpdate
echo �ù��߿���ʵ���ֶ������µĹ���

start ms-settings:windowsupdate
usoclient startinteractivescan
echo.
echo ���гɹ�
exit /b
