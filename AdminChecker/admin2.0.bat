@echo off
title ����ԱȨ�޼���� v2.0 by WangHaonie
echo "%username%" | findstr /i "Administrator" > nul
if %errorlevel% equ 0 (
    echo ��ǰ�û���ϵͳ���ù���Ա Administrator
) else (
    echo ��ǰ�û�����ϵͳ���ù���Ա Administrator
)
net localgroup Administrators | findstr /i /c:"%username%" > nul
if %errorlevel% equ 0 (
    echo ��ǰ�û� %username% �� Administrators ����
) else (
    echo ��ǰ�û� %username% ò�Ʋ��� Administrators ����
)
reg query "HKU\S-1-5-19" > nul 2>&1
if %errorlevel% equ 0 (
    echo ��ǰ�û� %username% ���й���ԱȨ��
) else (
    echo ��ǰ�û� %username% ������û�й���ԱȨ��
)
pause >nul