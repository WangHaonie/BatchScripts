@echo off
title 管理员权限检查器 v2.0 by WangHaonie
echo "%username%" | findstr /i "Administrator" > nul
if %errorlevel% equ 0 (
    echo 当前用户是系统内置管理员 Administrator
) else (
    echo 当前用户不是系统内置管理员 Administrator
)
net localgroup Administrators | findstr /i /c:"%username%" > nul
if %errorlevel% equ 0 (
    echo 当前用户 %username% 在 Administrators 组中
) else (
    echo 当前用户 %username% 貌似不在 Administrators 组中
)
reg query "HKU\S-1-5-19" > nul 2>&1
if %errorlevel% equ 0 (
    echo 当前用户 %username% 具有管理员权限
) else (
    echo 当前用户 %username% 根本就没有管理员权限
)
pause >nul