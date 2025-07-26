# 🚀 静态导航站

> 企业级静态导航站 - 高效、现代、响应式

## ✨ 特性

- 🎨 **现代化设计** - 渐变背景 + 毛玻璃效果
- 🔍 **智能搜索** - 实时过滤 + 搜索引擎集成
- 📱 **响应式布局** - 完美适配所有设备
- ⚡ **高性能** - 懒加载 + 平滑动画
- 📊 **访问统计** - 本地数据分析
- 🌙 **深色模式** - 自动适配系统偏好
- ⌨️ **快捷键支持** - Ctrl+K 搜索, Ctrl+D 主题切换

## 🛠️ 技术栈

- **前端**: HTML5 + CSS3 + Vanilla JavaScript
- **设计**: CSS Grid + Flexbox + CSS Variables
- **功能**: Local Storage + Intersection Observer + Smooth Scroll
- **兼容**: 支持现代浏览器 (Chrome 80+, Firefox 75+, Safari 13+)

## 📦 项目结构

```
repo-078/
├── index.html          # 主页面
├── styles/
│   └── main.css         # 样式文件
├── scripts/
│   └── main.js          # 核心脚本
├── assets/              # 静态资源
├── deploy.ps1           # 部署脚本
└── README.md            # 项目文档
```

## 🚀 快速开始

### 本地运行
```bash
# 1. 克隆项目
git clone https://github.com/q877220/repo-078.git
cd repo-078

# 2. 启动本地服务器 (推荐使用 Python)
python -m http.server 8000

# 3. 浏览器访问
# http://localhost:8000
```

### 一键部署
```powershell
# Windows PowerShell 一键部署
.\deploy.ps1
```

## 📋 功能说明

### 🔍 搜索功能
- **实时过滤**: 输入关键词即时筛选网站
- **智能跳转**: 输入 URL 直接访问
- **搜索引擎**: 支持 Google、百度、GitHub 搜索
- **快捷键**: `Ctrl + K` 快速聚焦搜索框

### 📊 数据统计
- **访问计数**: 自动记录每个网站的访问次数
- **访问日志**: 详细记录访问时间和来源
- **数据导出**: 支持导出书签和统计数据

### 🎨 界面特性
- **毛玻璃效果**: 导航栏背景模糊
- **渐变背景**: 动态渐变色彩
- **平滑动画**: 卡片悬停和加载动画
- **响应式**: 完美适配手机、平板、桌面

## ⌨️ 快捷键

| 快捷键 | 功能 |
|--------|------|
| `Ctrl + K` | 聚焦搜索框 |
| `Ctrl + D` | 切换深色模式 |
| `Esc` | 清除搜索内容 |
| `Enter` | 执行搜索 |

## 🔧 自定义配置

### 添加新网站
在 `index.html` 中的对应分类下添加卡片:

```html
<div class="card">
    <div class="card-icon">🆕</div>
    <h4>网站名称</h4>
    <p>网站描述</p>
    <a href="https://example.com" target="_blank" class="card-link">访问</a>
</div>
```

### 修改主题色彩
在 `styles/main.css` 的 `:root` 中修改 CSS 变量:

```css
:root {
    --primary-color: #6366f1;    /* 主色调 */
    --secondary-color: #f59e0b;  /* 辅助色 */
    --dark-color: #1f2937;       /* 深色 */
}
```

## 🌐 部署方式

### GitHub Pages
1. 推送代码到 GitHub 仓库
2. 进入仓库设置 → Pages
3. 选择 `main` 分支部署

### Netlify
1. 连接 GitHub 仓库
2. 设置构建命令: 无需构建
3. 发布目录: `/`

### Vercel
```bash
# 安装 Vercel CLI
npm i -g vercel

# 部署
vercel --prod
```

## 📱 移动端优化

- **触摸友好**: 按钮大小适配触摸操作
- **滑动流畅**: 原生滚动体验
- **加载优化**: 图片懒加载 + 资源压缩
- **离线支持**: 可扩展 Service Worker

## 🔒 隐私保护

- **本地存储**: 所有数据存储在浏览器本地
- **无跟踪**: 不使用第三方分析工具
- **安全跳转**: 外链在新标签页打开

## 🛡️ 浏览器兼容性

| 浏览器 | 版本 | 支持状态 |
|--------|------|----------|
| Chrome | 80+ | ✅ 完全支持 |
| Firefox | 75+ | ✅ 完全支持 |
| Safari | 13+ | ✅ 完全支持 |
| Edge | 80+ | ✅ 完全支持 |

## 📈 性能指标

- **首屏加载**: < 1s
- **交互延迟**: < 100ms
- **文件大小**: < 50KB
- **灯塔评分**: 95+

## 🤝 贡献指南

1. Fork 本仓库
2. 创建特性分支: `git checkout -b feature/新功能`
3. 提交更改: `git commit -m '添加新功能'`
4. 推送分支: `git push origin feature/新功能`
5. 提交 Pull Request

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

## 📞 联系方式

- **作者**: q877220
- **邮箱**: dev@example.com
- **GitHub**: [@q877220](https://github.com/q877220)

---

<p align="center">
  <strong>🚀 专为硬核开发者打造 | 高效导航，一键直达</strong>
</p>
Auto-generated repository
