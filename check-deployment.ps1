# 🔍 部署状态检查脚本
param(
    [string]$Url = "https://q877220.github.io/repo-078/",
    [int]$MaxRetries = 10,
    [int]$RetryDelay = 30
)

Write-Host "🔍 检查部署状态..." -ForegroundColor Cyan
Write-Host "🌍 目标URL: $Url" -ForegroundColor Gray
Write-Host "⏱️  最大重试次数: $MaxRetries, 间隔: $RetryDelay 秒" -ForegroundColor Gray
Write-Host "=" * 50 -ForegroundColor Gray

function Test-WebsiteStatus {
    param([string]$TestUrl)
    
    try {
        $response = Invoke-WebRequest -Uri $TestUrl -Method Head -TimeoutSec 10 -ErrorAction Stop
        return @{
            Success = $true
            StatusCode = $response.StatusCode
            StatusDescription = $response.StatusDescription
        }
    }
    catch {
        return @{
            Success = $false
            Error = $_.Exception.Message
        }
    }
}

function Test-PageContent {
    param([string]$TestUrl)
    
    try {
        $content = Invoke-WebRequest -Uri $TestUrl -TimeoutSec 15 -ErrorAction Stop
        
        $checks = @{
            HasTitle = $content.Content -match '<title>.*导航站.*</title>'
            HasCSS = $content.Content -match 'styles/main\.css'
            HasJS = $content.Content -match 'scripts/main\.js'
            HasNavigation = $content.Content -match 'class="nav"'
            HasSearchBox = $content.Content -match 'searchInput'
        }
        
        return @{
            Success = $true
            Checks = $checks
            ContentLength = $content.Content.Length
        }
    }
    catch {
        return @{
            Success = $false
            Error = $_.Exception.Message
        }
    }
}

# 🕐 等待部署完成
$attempt = 0
$deployed = $false

while ($attempt -lt $MaxRetries -and -not $deployed) {
    $attempt++
    
    Write-Host "🔄 第 $attempt 次检查..." -ForegroundColor Yellow
    
    # 检查主页状态
    $status = Test-WebsiteStatus -TestUrl $Url
    
    if ($status.Success -and $status.StatusCode -eq 200) {
        Write-Host "✅ 网站可访问 (状态码: $($status.StatusCode))" -ForegroundColor Green
        
        # 检查页面内容
        $content = Test-PageContent -TestUrl $Url
        
        if ($content.Success) {
            Write-Host "✅ 页面内容加载成功 ($($content.ContentLength) 字节)" -ForegroundColor Green
            
            # 检查关键元素
            $allChecks = $true
            foreach ($check in $content.Checks.GetEnumerator()) {
                if ($check.Value) {
                    Write-Host "  ✅ $($check.Key): 通过" -ForegroundColor Green
                } else {
                    Write-Host "  ❌ $($check.Key): 失败" -ForegroundColor Red
                    $allChecks = $false
                }
            }
            
            if ($allChecks) {
                $deployed = $true
                Write-Host "🎉 部署验证成功!" -ForegroundColor Green
            } else {
                Write-Host "⚠️  部分检查失败，继续等待..." -ForegroundColor Yellow
            }
        } else {
            Write-Host "❌ 页面内容检查失败: $($content.Error)" -ForegroundColor Red
        }
    } else {
        if ($status.Success) {
            Write-Host "❌ 网站返回状态码: $($status.StatusCode)" -ForegroundColor Red
        } else {
            Write-Host "❌ 网站无法访问: $($status.Error)" -ForegroundColor Red
        }
    }
    
    if (-not $deployed -and $attempt -lt $MaxRetries) {
        Write-Host "⏳ 等待 $RetryDelay 秒后重试..." -ForegroundColor Gray
        Start-Sleep -Seconds $RetryDelay
    }
}

Write-Host "=" * 50 -ForegroundColor Gray

if ($deployed) {
    Write-Host "🎉 静态导航站部署成功!" -ForegroundColor Green
    Write-Host "🌍 访问地址: $Url" -ForegroundColor Cyan
    Write-Host "📊 GitHub仓库: https://github.com/q877220/repo-078" -ForegroundColor Cyan
    Write-Host "🔧 GitHub Actions: https://github.com/q877220/repo-078/actions" -ForegroundColor Cyan
    
    # 额外检查资源文件
    Write-Host ""
    Write-Host "🔍 检查资源文件..." -ForegroundColor Yellow
    
    $resources = @(
        "$Url/styles/main.css",
        "$Url/scripts/main.js",
        "$Url/assets/favicon.svg"
    )
    
    foreach ($resource in $resources) {
        $resourceStatus = Test-WebsiteStatus -TestUrl $resource
        if ($resourceStatus.Success -and $resourceStatus.StatusCode -eq 200) {
            Write-Host "  ✅ $(Split-Path $resource -Leaf)" -ForegroundColor Green
        } else {
            Write-Host "  ❌ $(Split-Path $resource -Leaf)" -ForegroundColor Red
        }
    }
    
    Write-Host ""
    Write-Host "🚀 所有检查完成！导航站已成功部署并可正常访问。" -ForegroundColor Green
} else {
    Write-Host "❌ 部署验证失败或超时" -ForegroundColor Red
    Write-Host "💡 建议检查:" -ForegroundColor Yellow
    Write-Host "  1. GitHub Actions 工作流状态" -ForegroundColor Gray
    Write-Host "  2. GitHub Pages 设置" -ForegroundColor Gray
    Write-Host "  3. 仓库权限配置" -ForegroundColor Gray
    Write-Host "  4. 网络连接状态" -ForegroundColor Gray
}
