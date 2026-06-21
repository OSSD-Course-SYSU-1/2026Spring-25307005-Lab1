#!/bin/bash

# HarmonyOS 多端构建脚本
# 支持构建 phone、tablet、pc 三个平台

HVIGORW="C:\DevEco Studio\tools\node\node.exe C:\DevEco Studio\tools\hvigor\bin\hvigorw.js"

echo "=========================================="
echo "HarmonyOS 多端构建脚本"
echo "=========================================="

# 构建函数
build_platform() {
    platform=$1
    device_type=$2
    modules=$3
    
    echo ""
    echo "开始构建 $platform 平台..."
    echo "设备类型: $device_type"
    echo "构建模块: $modules"
    echo "------------------------------------------"
    
    $HVIGORW --mode module -p module=$modules -p product=$platform -p requiredDeviceType=$device_type assembleHap assembleHsp --analyze=normal --parallel --incremental --daemon
    
    if [ $? -eq 0 ]; then
        echo "✓ $platform 平台构建成功"
    else
        echo "✗ $platform 平台构建失败"
        return 1
    fi
}

# 选择构建平台
echo ""
echo "请选择要构建的平台:"
echo "1. phone (手机)"
echo "2. tablet (平板)"
echo "3. pc (PC/2in1)"
echo "4. 全部平台"
echo ""
read -p "请输入选项 (1-4): " choice

case $choice in
    1)
        build_platform "phone" "phone" "entry@default,phone@default,common@default,calculator@default"
        ;;
    2)
        build_platform "tablet" "tablet" "tablet@default,common@default,calculator@default"
        ;;
    3)
        build_platform "pc" "2in1" "pc@default,common@default,calculator@default"
        ;;
    4)
        echo "构建所有平台..."
        build_platform "phone" "phone" "entry@default,phone@default,common@default,calculator@default"
        build_platform "tablet" "tablet" "tablet@default,common@default,calculator@default"
        build_platform "pc" "2in1" "pc@default,common@default,calculator@default"
        ;;
    *)
        echo "无效的选项"
        exit 1
        ;;
esac

echo ""
echo "=========================================="
echo "构建完成"
echo "=========================================="
