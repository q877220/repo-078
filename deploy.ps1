# 🚀 一键部署脚本 - 静态导航站
# PowerShell 自动化部署工具

param(
    [string]$Mode = "local",  # local, github, netlify, vercel
    [string]$Port = "8000",
    [switch]$Open = $true
)

# 🎯 脚本配置
$ProjectName = "静态导航站"
$Author = "q877220"
$Version = "1.0.0"

Write-Host "🚀 $ProjectName 部署工具 v$Version" -ForegroundColor Cyan
Write-Host "👤 作者: $Author" -ForegroundColor Gray
Write-Host "📅 $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
Write-Host "=" * 50 -ForegroundColor Gray

# 🔍 检查环境
function Test-Environment {
    Write-Host "🔍 环境检查中..." -ForegroundColor Yellow
    
    # 检查 Git
    if (Get-Command git -ErrorAction SilentlyContinue) {
        Write-Host "✅ Git 已安装" -ForegroundColor Green
    } else {
        Write-Host "❌ Git 未安装，请先安装 Git" -ForegroundColor Red
        exit 1
    }
    
    # 检查 Python
    if (Get-Command python -ErrorAction SilentlyContinue) {
        $pythonVersion = python --version
        Write-Host "✅ Python 已安装: $pythonVersion" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Python 未安装，将尝试使用其他方式启动服务器" -ForegroundColor Yellow
    }
    
    # 检查 Node.js
    if (Get-Command node -ErrorAction SilentlyContinue) {
        $nodeVersion = node --version
        Write-Host "✅ Node.js 已安装: $nodeVersion" -ForegroundColor Green
    }
    
    Write-Host ""
}

# 📦 项目初始化
function Initialize-Project {
    Write-Host "📦 项目初始化..." -ForegroundColor Yellow
    
    # 检查必要文件
    $requiredFiles = @("index.html", "styles/main.css", "scripts/main.js")
    foreach ($file in $requiredFiles) {
        if (Test-Path $file) {
            Write-Host "✅ $file 存在" -ForegroundColor Green
        } else {
            Write-Host "❌ $file 缺失" -ForegroundColor Red
            exit 1
        }
    }
    
    # 创建 favicon.ico (如果不存在)
    if (!(Test-Path "assets/favicon.ico")) {
        Write-Host "🎨 生成默认 favicon..." -ForegroundColor Blue
        New-Item -Path "assets" -ItemType Directory -Force | Out-Null
        # 这里可以添加 favicon 生成逻辑
    }
    
    Write-Host "✅ 项目文件检查完成" -ForegroundColor Green
    Write-Host ""
}

# 🌐 本地服务器启动
function Start-LocalServer {
    param([string]$Port)
    
    Write-Host "🌐 启动本地服务器..." -ForegroundColor Yellow
    Write-Host "📍 端口: $Port" -ForegroundColor Gray
    
    # 尝试不同的服务器
    $serverStarted = $false
    
    # 1. 尝试 Python HTTP Server
    if (Get-Command python -ErrorAction SilentlyContinue) {
        Write-Host "🐍 使用 Python HTTP Server..." -ForegroundColor Blue
        try {
            Start-Process python -ArgumentList "-m", "http.server", $Port -NoNewWindow
            $serverStarted = $true
            $serverType = "Python"
        }
        catch {
            Write-Host "⚠️  Python 服务器启动失败" -ForegroundColor Yellow
        }
    }
    
    # 2. 尝试 Node.js http-server
    if (!$serverStarted -and (Get-Command npx -ErrorAction SilentlyContinue)) {
        Write-Host "📦 使用 Node.js http-server..." -ForegroundColor Blue
        try {
            Start-Process npx -ArgumentList "http-server", ".", "-p", $Port -NoNewWindow
            $serverStarted = $true
            $serverType = "Node.js"
        }
        catch {
            Write-Host "⚠️  Node.js 服务器启动失败" -ForegroundColor Yellow
        }
    }
    
    # 3. 尝试 PowerShell 内置服务器 (Windows 10+)
    if (!$serverStarted) {
        Write-Host "💻 使用 PowerShell 内置服务器..." -ForegroundColor Blue
        try {
            $job = Start-Job -ScriptBlock {
                param($Port, $Path)
                Add-Type -AssemblyName System.Net.HttpListener
                $listener = New-Object System.Net.HttpListener
                $listener.Prefixes.Add("http://localhost:$Port/")
                $listener.Start()
                
                while ($listener.IsListening) {
                    $context = $listener.GetContext()
                    $response = $context.Response
                    $request = $context.Request
                    
                    $localPath = $request.Url.LocalPath
                    if ($localPath -eq "/") { $localPath = "/index.html" }
                    
                    $filePath = Join-Path $Path $localPath.TrimStart('/')
                    
                    if (Test-Path $filePath) {
                        $content = Get-Content $filePath -Raw -Encoding UTF8
                        $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
                        $response.ContentLength64 = $buffer.Length
                        $response.OutputStream.Write($buffer, 0, $buffer.Length)
                    } else {
                        $response.StatusCode = 404
                    }
                    
                    $response.Close()
                }
            } -ArgumentList $Port, (Get-Location).Path
            
            $serverStarted = $true
            $serverType = "PowerShell"
        }
        catch {
            Write-Host "❌ PowerShell 服务器启动失败" -ForegroundColor Red
        }
    }
    
    if ($serverStarted) {
        Write-Host "✅ 服务器启动成功 ($serverType)" -ForegroundColor Green
        Write-Host "🌍 访问地址: http://localhost:$Port" -ForegroundColor Cyan
        
        if ($Open) {
            Start-Sleep -Seconds 2
            Start-Process "http://localhost:$Port"
            Write-Host "🚀 浏览器已打开" -ForegroundColor Green
        }
        
        Write-Host ""
        Write-Host "按 Ctrl+C 停止服务器" -ForegroundColor Yellow
        Write-Host "=" * 50 -ForegroundColor Gray
        
        # 等待用户停止
        try {
            while ($true) {
                Start-Sleep -Seconds 1
            }
        }
        catch {
            Write-Host "🛑 服务器已停止" -ForegroundColor Red
        }
    } else {
        Write-Host "❌ 无法启动本地服务器" -ForegroundColor Red
        Write-Host "请手动打开 index.html 或安装 Python/Node.js" -ForegroundColor Yellow
    }
}

# 📤 GitHub 部署
function Deploy-ToGitHub {
    Write-Host "📤 部署到 GitHub Pages..." -ForegroundColor Yellow
    
    # 检查 Git 仓库
    if (!(Test-Path ".git")) {
        Write-Host "📁 初始化 Git 仓库..." -ForegroundColor Blue
        git init
        git branch -M main
    }
    
    # 添加所有文件
    Write-Host "📦 添加文件到 Git..." -ForegroundColor Blue
    git add .
    
    # 提交变更
    $commitMessage = "🚀 Deploy navigation site - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    git commit -m $commitMessage
    
    # 推送到远程仓库
    Write-Host "🚀 推送到 GitHub..." -ForegroundColor Blue
    try {
        git push origin main
        Write-Host "✅ 部署到 GitHub 成功" -ForegroundColor Green
        Write-Host "🌍 GitHub Pages 将在几分钟内生效" -ForegroundColor Cyan
    }
    catch {
        Write-Host "❌ 推送失败，请检查远程仓库配置" -ForegroundColor Red
        Write-Host "💡 提示: git remote add origin https://github.com/username/repo.git" -ForegroundColor Yellow
    }
}

# 🔄 Netlify 部署
function Deploy-ToNetlify {
    Write-Host "🔄 部署到 Netlify..." -ForegroundColor Yellow
    
    if (Get-Command netlify -ErrorAction SilentlyContinue) {
        Write-Host "🌐 使用 Netlify CLI 部署..." -ForegroundColor Blue
        netlify deploy --prod --dir .
        Write-Host "✅ Netlify 部署完成" -ForegroundColor Green
    } else {
        Write-Host "❌ Netlify CLI 未安装" -ForegroundColor Red
        Write-Host "💡 安装命令: npm install -g netlify-cli" -ForegroundColor Yellow
        Write-Host "🌐 或手动上传到 https://app.netlify.com/drop" -ForegroundColor Cyan
    }
}

# ⚡ Vercel 部署
function Deploy-ToVercel {
    Write-Host "⚡ 部署到 Vercel..." -ForegroundColor Yellow
    
    if (Get-Command vercel -ErrorAction SilentlyContinue) {
        Write-Host "🚀 使用 Vercel CLI 部署..." -ForegroundColor Blue
        vercel --prod
        Write-Host "✅ Vercel 部署完成" -ForegroundColor Green
    } else {
        Write-Host "❌ Vercel CLI 未安装" -ForegroundColor Red
        Write-Host "💡 安装命令: npm install -g vercel" -ForegroundColor Yellow
    }
}

# 🧹 清理工具
function Clear-DeploymentCache {
    Write-Host "🧹 清理部署缓存..." -ForegroundColor Yellow
    
    $cacheFiles = @(".vercel", ".netlify", "node_modules", "*.log")
    foreach ($pattern in $cacheFiles) {
        Get-ChildItem -Path . -Name $pattern -Recurse -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force
    }
    
    Write-Host "✅ 缓存清理完成" -ForegroundColor Green
}

# 📊 项目统计
function Show-ProjectStats {
    Write-Host "📊 项目统计信息" -ForegroundColor Cyan
    Write-Host "=" * 30 -ForegroundColor Gray
    
    # 文件统计
    $htmlFiles = (Get-ChildItem -Filter "*.html" -Recurse).Count
    $cssFiles = (Get-ChildItem -Filter "*.css" -Recurse).Count
    $jsFiles = (Get-ChildItem -Filter "*.js" -Recurse).Count
    
    Write-Host "📄 HTML 文件: $htmlFiles" -ForegroundColor Green
    Write-Host "🎨 CSS 文件: $cssFiles" -ForegroundColor Green
    Write-Host "⚡ JS 文件: $jsFiles" -ForegroundColor Green
    
    # 代码行数统计
    $totalLines = 0
    Get-ChildItem -Include @("*.html", "*.css", "*.js") -Recurse | ForEach-Object {
        $totalLines += (Get-Content $_.FullName).Count
    }
    Write-Host "📊 总代码行数: $totalLines" -ForegroundColor Cyan
    
    # 文件大小
    $totalSize = (Get-ChildItem -Recurse | Measure-Object -Property Length -Sum).Sum
    $sizeKB = [math]::Round($totalSize / 1KB, 2)
    Write-Host "💾 项目大小: $sizeKB KB" -ForegroundColor Cyan
    
    Write-Host ""
}

# 🎯 主函数
function Main {
    Clear-Host
    
    # 环境检查
    Test-Environment
    Initialize-Project
    Show-ProjectStats
    
    # 根据模式执行相应操作
    switch ($Mode.ToLower()) {
        "local" {
            Start-LocalServer -Port $Port
        }
        "github" {
            Deploy-ToGitHub
        }
        "netlify" {
            Deploy-ToNetlify
        }
        "vercel" {
            Deploy-ToVercel
        }
        "clean" {
            Clear-DeploymentCache
        }
        default {
            Write-Host "🎯 使用方法:" -ForegroundColor Cyan
            Write-Host "  .\deploy.ps1 -Mode local    # 启动本地服务器" -ForegroundColor Gray
            Write-Host "  .\deploy.ps1 -Mode github   # 部署到 GitHub Pages" -ForegroundColor Gray
            Write-Host "  .\deploy.ps1 -Mode netlify  # 部署到 Netlify" -ForegroundColor Gray
            Write-Host "  .\deploy.ps1 -Mode vercel   # 部署到 Vercel" -ForegroundColor Gray
            Write-Host "  .\deploy.ps1 -Mode clean    # 清理缓存" -ForegroundColor Gray
            Write-Host ""
            Write-Host "📋 参数说明:" -ForegroundColor Cyan
            Write-Host "  -Port 8000     # 指定端口号 (默认 8000)" -ForegroundColor Gray
            Write-Host "  -Open          # 自动打开浏览器 (默认启用)" -ForegroundColor Gray
            Write-Host ""
            
            # 默认启动本地服务器
            Start-LocalServer -Port $Port
        }
    }
}

# 错误处理
trap {
    Write-Host "❌ 发生错误: $_" -ForegroundColor Red
    Write-Host "🔧 请检查配置或联系技术支持" -ForegroundColor Yellow
    exit 1
}

# 🚀 执行主函数
Main
