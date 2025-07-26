// 🚀 导航站核心 JavaScript 功能

class NavigationHub {
    constructor() {
        this.init();
        this.bindEvents();
        this.loadUserPreferences();
    }

    init() {
        console.log('🚀 导航站初始化中...');
        this.setupSearchFunctionality();
        this.setupSmoothScrolling();
        this.setupLazyLoading();
        this.trackVisitCounts();
    }

    // 🔍 搜索功能
    setupSearchFunctionality() {
        const searchInput = document.getElementById('searchInput');
        const searchBtn = document.getElementById('searchBtn');
        const cards = document.querySelectorAll('.card');

        if (searchInput) {
            searchInput.addEventListener('input', (e) => {
                this.performSearch(e.target.value, cards);
            });

            searchInput.addEventListener('keypress', (e) => {
                if (e.key === 'Enter') {
                    this.handleSearchSubmit(e.target.value);
                }
            });
        }

        if (searchBtn) {
            searchBtn.addEventListener('click', () => {
                this.handleSearchSubmit(searchInput.value);
            });
        }
    }

    // 🔍 实时搜索过滤
    performSearch(query, cards) {
        const searchTerm = query.toLowerCase().trim();

        cards.forEach(card => {
            const title = card.querySelector('h4').textContent.toLowerCase();
            const description = card.querySelector('p').textContent.toLowerCase();
            
            if (title.includes(searchTerm) || description.includes(searchTerm)) {
                card.style.display = 'block';
                card.style.animation = 'fadeInUp 0.3s ease';
                this.highlightSearchTerm(card, searchTerm);
            } else {
                card.style.display = searchTerm ? 'none' : 'block';
            }
        });

        // 更新分类标题显示
        this.updateCategoryVisibility(searchTerm);
    }

    // 🎯 高亮搜索词
    highlightSearchTerm(card, term) {
        if (!term) return;

        const title = card.querySelector('h4');
        const description = card.querySelector('p');

        [title, description].forEach(element => {
            const originalText = element.dataset.originalText || element.textContent;
            if (!element.dataset.originalText) {
                element.dataset.originalText = originalText;
            }

            const regex = new RegExp(`(${term})`, 'gi');
            const highlightedText = originalText.replace(regex, '<span class="highlight">$1</span>');
            element.innerHTML = highlightedText;
        });
    }

    // 📂 更新分类可见性
    updateCategoryVisibility(searchTerm) {
        const categories = document.querySelectorAll('.category');
        
        categories.forEach(category => {
            const visibleCards = category.querySelectorAll('.card[style*="display: block"], .card:not([style*="display: none"])');
            const categoryTitle = category.querySelector('h3');
            
            if (searchTerm && visibleCards.length === 0) {
                category.style.display = 'none';
            } else {
                category.style.display = 'block';
            }
        });
    }

    // 🔍 搜索提交处理
    handleSearchSubmit(query) {
        if (!query.trim()) return;

        // 检查是否为 URL
        if (this.isValidUrl(query)) {
            window.open(query.startsWith('http') ? query : `https://${query}`, '_blank');
            return;
        }

        // 使用搜索引擎
        const searchEngines = {
            'google': `https://www.google.com/search?q=${encodeURIComponent(query)}`,
            'baidu': `https://www.baidu.com/s?wd=${encodeURIComponent(query)}`,
            'github': `https://github.com/search?q=${encodeURIComponent(query)}`
        };

        const defaultEngine = localStorage.getItem('preferredSearchEngine') || 'google';
        window.open(searchEngines[defaultEngine], '_blank');
    }

    // 🌐 URL 验证
    isValidUrl(string) {
        try {
            new URL(string.startsWith('http') ? string : `https://${string}`);
            return true;
        } catch (_) {
            return false;
        }
    }

    // 🎯 平滑滚动
    setupSmoothScrolling() {
        const navLinks = document.querySelectorAll('.nav-link');
        
        navLinks.forEach(link => {
            link.addEventListener('click', (e) => {
                const targetId = link.getAttribute('href');
                if (targetId.startsWith('#')) {
                    e.preventDefault();
                    const targetElement = document.querySelector(targetId);
                    
                    if (targetElement) {
                        targetElement.scrollIntoView({
                            behavior: 'smooth',
                            block: 'start'
                        });
                        
                        // 更新活动导航
                        this.updateActiveNav(link);
                    }
                }
            });
        });
    }

    // 🎯 更新活动导航
    updateActiveNav(activeLink) {
        document.querySelectorAll('.nav-link').forEach(link => {
            link.classList.remove('active');
        });
        activeLink.classList.add('active');
    }

    // 🖼️ 懒加载设置
    setupLazyLoading() {
        const cards = document.querySelectorAll('.card');
        
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        }, {
            threshold: 0.1,
            rootMargin: '50px'
        });

        cards.forEach(card => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(20px)';
            card.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
            observer.observe(card);
        });
    }

    // 📊 访问统计
    trackVisitCounts() {
        const cardLinks = document.querySelectorAll('.card-link');
        
        cardLinks.forEach(link => {
            link.addEventListener('click', (e) => {
                const siteName = e.target.closest('.card').querySelector('h4').textContent;
                this.incrementVisitCount(siteName);
                this.logVisit(siteName, e.target.href);
            });
        });
    }

    // 📈 增加访问计数
    incrementVisitCount(siteName) {
        const visits = JSON.parse(localStorage.getItem('siteVisits') || '{}');
        visits[siteName] = (visits[siteName] || 0) + 1;
        localStorage.setItem('siteVisits', JSON.stringify(visits));
    }

    // 📝 记录访问日志
    logVisit(siteName, url) {
        const visitLog = {
            site: siteName,
            url: url,
            timestamp: new Date().toISOString(),
            userAgent: navigator.userAgent
        };
        
        const logs = JSON.parse(localStorage.getItem('visitLogs') || '[]');
        logs.push(visitLog);
        
        // 保留最近100条记录
        if (logs.length > 100) {
            logs.splice(0, logs.length - 100);
        }
        
        localStorage.setItem('visitLogs', JSON.stringify(logs));
        console.log('📊 访问记录:', visitLog);
    }

    // 💾 加载用户偏好
    loadUserPreferences() {
        const preferences = JSON.parse(localStorage.getItem('userPreferences') || '{}');
        
        // 应用主题偏好
        if (preferences.theme) {
            document.body.setAttribute('data-theme', preferences.theme);
        }
        
        // 应用搜索引擎偏好
        if (preferences.searchEngine) {
            localStorage.setItem('preferredSearchEngine', preferences.searchEngine);
        }
    }

    // 🎨 主题切换
    toggleTheme() {
        const currentTheme = document.body.getAttribute('data-theme');
        const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
        
        document.body.setAttribute('data-theme', newTheme);
        
        const preferences = JSON.parse(localStorage.getItem('userPreferences') || '{}');
        preferences.theme = newTheme;
        localStorage.setItem('userPreferences', JSON.stringify(preferences));
        
        console.log(`🎨 主题已切换到: ${newTheme}`);
    }

    // 📊 获取访问统计
    getVisitStats() {
        const visits = JSON.parse(localStorage.getItem('siteVisits') || '{}');
        const logs = JSON.parse(localStorage.getItem('visitLogs') || '[]');
        
        return {
            totalVisits: Object.values(visits).reduce((sum, count) => sum + count, 0),
            siteVisits: visits,
            recentLogs: logs.slice(-10)
        };
    }

    // 🔧 绑定事件
    bindEvents() {
        // 键盘快捷键
        document.addEventListener('keydown', (e) => {
            if (e.ctrlKey || e.metaKey) {
                switch(e.key) {
                    case 'k':
                        e.preventDefault();
                        document.getElementById('searchInput').focus();
                        break;
                    case 'd':
                        e.preventDefault();
                        this.toggleTheme();
                        break;
                }
            }
            
            // ESC 清除搜索
            if (e.key === 'Escape') {
                const searchInput = document.getElementById('searchInput');
                searchInput.value = '';
                this.performSearch('', document.querySelectorAll('.card'));
            }
        });

        // 滚动导航高亮
        window.addEventListener('scroll', () => {
            this.updateActiveNavOnScroll();
        });

        // 窗口大小变化适配
        window.addEventListener('resize', () => {
            this.handleResize();
        });
    }

    // 📍 滚动时更新导航
    updateActiveNavOnScroll() {
        const sections = document.querySelectorAll('section[id]');
        const navLinks = document.querySelectorAll('.nav-link');
        
        let currentSection = '';
        
        sections.forEach(section => {
            const rect = section.getBoundingClientRect();
            if (rect.top <= 150 && rect.bottom >= 150) {
                currentSection = section.id;
            }
        });
        
        navLinks.forEach(link => {
            link.classList.remove('active');
            if (link.getAttribute('href') === `#${currentSection}`) {
                link.classList.add('active');
            }
        });
    }

    // 📱 响应式处理
    handleResize() {
        const width = window.innerWidth;
        const nav = document.querySelector('.nav');
        
        if (width < 768) {
            nav.classList.add('mobile');
        } else {
            nav.classList.remove('mobile');
        }
    }
}

// 🚀 初始化应用
document.addEventListener('DOMContentLoaded', () => {
    window.navHub = new NavigationHub();
    console.log('✅ 导航站加载完成!');
});

// 🛠️ 全局工具函数
window.NavUtils = {
    // 导出书签
    exportBookmarks() {
        const visits = JSON.parse(localStorage.getItem('siteVisits') || '{}');
        const bookmarks = Object.entries(visits).map(([name, count]) => ({
            name,
            visitCount: count,
            exportDate: new Date().toISOString()
        }));
        
        const dataStr = JSON.stringify(bookmarks, null, 2);
        const dataBlob = new Blob([dataStr], {type: 'application/json'});
        
        const link = document.createElement('a');
        link.href = URL.createObjectURL(dataBlob);
        link.download = 'navigation-bookmarks.json';
        link.click();
    },
    
    // 清除数据
    clearData() {
        if (confirm('确定要清除所有数据吗？')) {
            localStorage.removeItem('siteVisits');
            localStorage.removeItem('visitLogs');
            localStorage.removeItem('userPreferences');
            location.reload();
        }
    },
    
    // 显示统计
    showStats() {
        const stats = window.navHub.getVisitStats();
        alert(`📊 访问统计:\n总访问: ${stats.totalVisits} 次\n最常用: ${Object.entries(stats.siteVisits).sort(([,a], [,b]) => b - a)[0]?.[0] || '无'}`);
    }
};

console.log('🎯 导航站脚本加载完成!');
