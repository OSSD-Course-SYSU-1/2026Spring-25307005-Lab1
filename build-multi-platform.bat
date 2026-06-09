@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM HarmonyOS 多端构建脚本
REM 支持构建 phone、tablet、pc 三个平台

set HVIGORW="C:\DevEco Studio\tools\node\node.exe" "C:\DevEco Studio\tools\hvigor\bin\hvigorw.js"

echo ==========================================
echo HarmonyOS 多端构建脚本
echo ==========================================

echo.
echo 请选择要构建的平台:
echo 1. phone (手机)
echo 2. tablet (平板)
echo 3. pc (PC/2in1)
echo 4. 全部平台
echo.
set /p choice="请输入选项 (1-4): "

if "%choice%"=="1" goto build_phone
if "%choice%"=="2" goto build_tablet
if "%choice%"=="3" goto build_pc
if "%choice%"=="4" goto build_all
echo 无效的选项
goto end

:build_phone
echo.
echo 开始构建 phone 平台...
echo 设备类型: phone
echo 构建模块: entry, phone, common, calculator
echo ------------------------------------------
%HVIGORW% --mode module -p module=entry@default,phone@default,common@default,calculator@default -p product=phone -p requiredDeviceType=phone assembleHap assembleHsp --analyze=normal --parallel --incremental --daemon
if %errorlevel% equ 0 (
    echo ✓ phone 平台构建成功
) else (
    echo ✗ phone 平台构建失败
)
goto end

:build_tablet
echo.
echo 开始构建 tablet 平台...
echo 设备类型: tablet
echo 构建模块: tablet, common, calculator
echo ------------------------------------------
%HVIGORW% --mode module -p module=tablet@default,common@default,calculator@default -p product=tablet -p requiredDeviceType=tablet assembleHap assembleHsp --analyze=normal --parallel --incremental --daemon
if %errorlevel% equ 0 (
    echo ✓ tablet 平台构建成功
) else (
    echo ✗ tablet 平台构建失败
)
goto end

:build_pc
echo.
echo 开始构建 pc 平台...
echo 设备类型: 2in1
echo 构建模块: pc, common, calculator
echo ------------------------------------------
%HVIGORW% --mode module -p module=pc@default,common@default,calculator@default -p product=pc -p requiredDeviceType=2in1 assembleHap assembleHsp --analyze=normal --parallel --incremental --daemon
if %errorlevel% equ 0 (
    echo ✓ pc 平台构建成功
) else (
    echo ✗ pc 平台构建失败
)
goto end

:build_all
echo 构建所有平台...
echo.
call :build_phone
call :build_tablet
call :build_pc
goto end

:end
echo.
echo ==========================================
echo 构建完成
echo ==========================================
pause
