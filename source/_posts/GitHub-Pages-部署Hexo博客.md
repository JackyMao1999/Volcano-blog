---
title: GitHub Pages 部署 Hexo 博客
tags:
  - Hexo
  - GitHub Pages
  - 博客
categories:
  - 技术
cover:
---

## 前言

Hexo 是一个快速、简洁且高效的静态博客框架，支持 Markdown 语法，可以一键部署到 GitHub Pages 上免费托管。本文记录完整的部署流程。

---

## 准备工作

在开始之前，你需要准备：

- **Node.js** (>= 20)
- **Git**
- **GitHub 账号**
- 一个文本编辑器

---

## 第一步：安装 Hexo

```bash
npm install -g hexo-cli
hexo init my-blog
cd my-blog
npm install
```

`hexo init` 会自动生成 Hexo 项目的基本骨架：

```
my-blog/
├── _config.yml        # 站点配置
├── source/            # 源文件（文章、页面）
│   └── _posts/        # 文章目录
├── themes/            # 主题目录
├── scaffolds/         # 文章模板
└── package.json
```

---

## 第二步：配置站点信息

编辑 `_config.yml`，修改站点基本信息：

```yaml
title: My Blog
subtitle: 我的技术博客
description: 记录技术与思考
author: YourName
language: zh-CN
timezone: Asia/Shanghai
```

---

## 第三步：选择主题

Hexo 拥有丰富的主题生态。以 Volantis 为例：

```bash
npm install hexo-theme-volantis
```

然后在 `_config.yml` 中启用：

```yaml
theme: volantis
```

---

## 第四步：编写文章

创建新文章：

```bash
hexo new "文章标题"
```

在 `source/_posts/` 下会生成对应的 Markdown 文件。编辑它：

```markdown
---
title: 文章标题
tags:
  - 标签1
  - 标签2
categories:
  - 分类名
---

这里是正文，支持 **Markdown** 语法。
```

---

## 第五步：本地预览

```bash
hexo server
# 访问 http://localhost:4000
```

`hexo server` 支持热更新，修改文件后浏览器会自动刷新。

---

## 第六步：部署到 GitHub Pages

### 6.1 创建 GitHub 仓库

在 GitHub 上创建一个仓库，有两种命名方式：

| 站点类型 | 仓库名 |
|---------|--------|
| 用户/组织站点 | `username.github.io` |
| 项目站点 | `my-blog` |

### 6.2 配置 GitHub Actions

在项目根目录创建 `.github/workflows/deploy.yml`：

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [main]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: pages
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm
      - name: Install dependencies
        run: npm ci
      - name: Build site
        run: npm run build
      - uses: actions/upload-pages-artifact@v3
        with:
          path: ./public

  deploy:
    runs-on: ubuntu-latest
    needs: build
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - id: deployment
        uses: actions/deploy-pages@v4
```

### 6.3 配置 URL

在 `_config.yml` 中设置正确的 URL：

**用户站点**（`username.github.io`）：

```yaml
url: https://username.github.io
root: /
```

**项目站点**（`username.github.io/repo`）：

```yaml
url: https://username.github.io
root: /repo/
```

### 6.4 推送到 GitHub

```bash
git init
git add .
git commit -m "first commit"
git remote add origin git@github.com:username/repo.git
git branch -M main
git push -u origin main
```

### 6.5 启用 GitHub Pages

1. 进入仓库 **Settings → Pages**
2. **Source** 选择 **GitHub Actions**
3. 等待 Actions 运行完成，访问提供的 URL 即可看到博客
{% asset_img 1.png 部署流程 %}

---

## 常见问题

### 样式丢失/路径错误

检查 `_config.yml` 中的 `root` 设置是否正确。项目站点需要 `root: /repo-name/`。

### 自定义域名

在 `source/` 下创建 `CNAME` 文件，内容为你的域名，并将 `root` 改为 `/`。

### GitHub Pages 不更新

检查 Actions 是否运行成功，如果失败查看日志中的错误信息。

---

## 总结

通过 Hexo + GitHub Pages + GitHub Actions，你可以零成本搭建一个自动部署的静态博客。每次推送 `main` 分支，GitHub Actions 会自动构建并发布，省去了手动部署的麻烦。
