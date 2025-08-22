#!/bin/bash

echo "🚀 快速部署到手机..."

# 1. 提交代码
git add -A
git commit -m "Quick update: $(date '+%H:%M:%S')"
git push

echo "✅ 代码已推送，等待构建完成..."
echo ""
echo "📱 手机下载方式："
echo "1. 手机访问: https://github.com/HenryDoi/TestiOSApp/actions"
echo "2. 点击最新构建 → 下载 TestiOSApp-IPA"
echo "3. TrollStore安装"
echo ""
echo "⏰ 预计等待时间: 5-8分钟"
echo ""
echo "💡 建议：收藏GitHub Actions页面到手机桌面"

# 生成二维码链接（如果有qrencode）
if command -v qrencode &> /dev/null; then
    echo ""
    echo "📱 二维码："
    qrencode -t UTF8 "https://github.com/HenryDoi/TestiOSApp/actions"
fi

# 可选：自动打开Actions页面
if command -v start &> /dev/null; then
    start https://github.com/HenryDoi/TestiOSApp/actions
elif command -v open &> /dev/null; then
    open https://github.com/HenryDoi/TestiOSApp/actions
fi