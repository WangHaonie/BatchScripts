@echo off
echo WinNtpUpdater v1.0 by WangHaonie
echo GitHub: https://github.com/WangHaonie/BatchScripts/tree/main/WinNtpUpdater
echo �ù��߿��Խ�� Windows ϵͳʱ���޷�ͬ���򲻻�ͬ�������
echo.
pause
cls
echo ���������µ� NTP ��������ntp1.aliyun.com
w32tm /config /manualpeerlist:ntp1.aliyun.com /syncfromflags:manual /reliable:YES /update
echo.
echo ������������ Windows Time ����
net stop w32time
net start w32time
echo.
echo �������� Windows Time ����Ϊ �Զ�
sc config w32time start= auto
echo.
echo ���ڳ���ͬ��ʱ��
w32tm /resync
echo ��ǰʱ�䣺%DATE%%TIME%
echo.
echo �ű�ִ����ϣ����㿴���˴������Ҽ��νű�ѡ���Թ���Ա�������
pause >nul