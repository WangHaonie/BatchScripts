@echo off
title ����ԱȨ�޼���� v2.0 by WangHaonie
echo "%username%" | findstr /i "Administrator" > nul
if %errorlevel% equ 0 (
    echo ��ϲ����ǰ�û���ϵͳ���ù���Ա Administrator
) else (
    echo �Բۣ���ǰ�û�����ϵͳ���ù���Ա Administrator
)
net localgroup Administrators | findstr /i /c:"%username%" > nul
if %errorlevel% equ 0 (
    echo ��ϲ����ǰ�û� %username% �� Administrators ����
) else (
    echo ��ȥ����ǰ�û� %username% ò�Ʋ��� Administrators ����
)
reg query "HKU\S-1-5-19" > nul 2>&1
if %errorlevel% equ 0 (
    echo ��ϲ����ǰ�û� %username% ���й���ԱȨ��
) else (
    echo ţ�ƣ���ǰ�û� %username% ������û�й���ԱȨ��
)
pause >nul