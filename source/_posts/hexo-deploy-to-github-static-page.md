---
title: Hexo 部屬至　GitHub Page
date: 2021-03-13 21:23:07
tags:
  - hexo
  - github
---


## 步驟
1. 開　repo 命名為 {username}.github.io，如果已經有了，請把那個 repo 改名。

2. 將專案下的 package.json ， 增加 scripts 區塊。
```
{
  "scripts": {
    "build": "hexo generate"
  },
  "hexo": {
    "version": "5.0.0"
  },
  "dependencies": {
    "hexo": "^5.0.0",
    ...
  }
}
```

3. 開一個 source branch ，並 push 上去。
> public 資料夾記得要在 .gitignore 增加
```
git push origin source
```

4. 建立 .github/workflows/pages.yml
```
.github/workflows/pages.yml
name: Pages

on:
  push:
    branches:
      - source  # default branch

jobs:
  pages:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Use Node.js 12.x
        uses: actions/setup-node@v1
        with:
          node-version: '12.x'
      - name: Cache NPM dependencies
        uses: actions/cache@v2
        with:
          path: node_modules
          key: ${{ runner.OS }}-npm-cache
          restore-keys: |
            ${{ runner.OS }}-npm-cache
      - name: Install Dependencies
        run: npm install
      - name: Build
        run: npm run build
      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./public
          publish_branch: master  # deploying branch
```

5. 進去 Github 的 repo 設定，設定 Source 相關參數
https://github.com/{username}/{username}.github.io/settings

![github-set](https://imgur.com/t28QgJm.png "image.png")

6. 如果有相關的 domain 設定，在 repo 的 source 下建立檔名為 CNAME 的檔案，內容為 購買的 domain

7. 基本上按照官方文件就可以 work。

## 問題
 - https 憑證異常，記得設定 CNAME 檔案，重新 deploy 。
 - favicon.icon 無法正常顯示，剛開始幾秒 tab 上有正常顯示，網頁讀取完後就變成沒有 icon ，後來調整使用 .png 格式就正常，不過原來在 gcp 都正常。

## 參考文件
- [Configuring an apex domain](https://docs.github.com/en/github/working-with-github-pages/managing-a-custom-domain-for-your-github-pages-site#configuring-a-subdomain)
- [GitHub Pages](https://hexo.io/docs/github-pages)
- [Hexo绑定自定义域名](http://www.mdslq.cn/archives/82234085.html)
- [如何使用 Hexo + Github Page 用 Cloudflare 綁定個人網址](https://wualnz.com/%E5%A6%82%E4%BD%95%E4%BD%BF%E7%94%A8-Hexo-Github-Page-%E7%94%A8-Cloudflare-%E7%B6%81%E5%AE%9A%E5%80%8B%E4%BA%BA%E7%B6%B2%E5%9D%80/)