# 📡 Telegram频道导航站部署脚本
# 自动化部署更新后的导航站 - 真实频道链接版本

Write-Host "🚀 开始部署Telegram频道导航站..." -ForegroundColor Green

# 检查Git状态
Write-Host "📊 检查Git状态..." -ForegroundColor Yellow
git status

# 添加所有更改
Write-Host "📦 添加文件到Git..." -ForegroundColor Yellow
git add -A

# 提交更改
$commitMessage = "✨ 更新真实Telegram频道链接 - 7个精选频道上线"
Write-Host "💾 提交更改: $commitMessage" -ForegroundColor Yellow
git commit -m "$commitMessage"

# 推送到远程仓库
Write-Host "🌐 推送到GitHub..." -ForegroundColor Yellow
git push origin main

# 等待GitHub Actions部署
Write-Host "⏳ 等待GitHub Actions自动部署..." -ForegroundColor Cyan
Write-Host "🔗 访问地址: https://q877220.github.io/repo-078/" -ForegroundColor Green
Write-Host "📱 真实Telegram频道已上线！" -ForegroundColor Magenta

# 显示频道列表
Write-Host "`n✈️ 已添加的Telegram频道:" -ForegroundColor Blue
Write-Host "📢 精选资讯: https://t.me/jjing12" -ForegroundColor White
Write-Host "💻 技术前沿: https://t.me/SDASA112" -ForegroundColor White  
Write-Host "🤖 创新科技: https://t.me/cjxx111" -ForegroundColor White
Write-Host "📊 深度观察: https://t.me/SEEWAS1" -ForegroundColor White
Write-Host "🎯 实用资源: https://t.me/ddf21312" -ForegroundColor White
Write-Host "🌐 热点速递: https://t.me/hai1146" -ForegroundColor White
Write-Host "🔧 工具集合: https://t.me/was23211" -ForegroundColor White

# 可选：打开网站
$openSite = Read-Host "`n是否打开网站? (y/n)"
if ($openSite -eq 'y' -or $openSite -eq 'Y') {
    Start-Process "https://q877220.github.io/repo-078/"
}

Write-Host "✅ 部署完成！" -ForegroundColor Green
