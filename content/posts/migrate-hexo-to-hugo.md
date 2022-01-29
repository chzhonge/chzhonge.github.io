---
title: "[2022-沒工作系列-01] Migrate Hexo to Hugo"
date: 2022-01-29T17:23:58+08:00
tags:
    - hexo
    - hugo
    - "github pages"
    - "2022沒工作系列"
---

## 原因
原本是用 Hexo ， 因會在 windows、 linux 下切換開發，有時 node 在 windows terminal 會有些詭異問題發生，
決定換成 golang 的 Hugo ，省的麻煩。

## windows 安裝 Hugo
[Hugo 官方文件](https://gohugo.io/getting-started/installing/)

可以使用在 win 上面的套件管理器 Chocolatey 或 Scoop ，差異似乎是在權限以及相依性，有點不太一樣，沒有細看。
有興趣可以參考

[Scoop or Chocolatey? Which Windows 10 package manager should you use?](https://www.onmsft.com/feature/scoop-or-chocolatey-which-windows-10-package-manager-should-you-use)

後來我選了 Scoop ，剛裝完可以用，當我把 terminal 關掉重開就又壞了......

為了省事直接使用第三個方案，從 [Hugo Github](https://github.com/gohugoio/hugo/releases) 直接裝執行檔來用，安裝位置就看個人習慣，
裝完記得在 path 裡面把路徑設定進去，因為在 win 的環境下習慣用 git bash ，所以我是這樣設定。

```
# .bashrc
PATH=$PATH:/c/work/tools/
```
如果要用 win 內建的話，就直接在環境變數 path 裡面加。

最後 terminal 下輸入 hugo ，正常執行。

---
## 轉換步驟

### Hexo 前置作業
1. 進入到 blog 的 repo
2. 開 git branch br: `feature/migration-to-hugo`
3. 保留 要轉移或參考 Hexo 檔案
    1. source 裡面的 `_posts` 文章資料夾
    2. `_config.yml` meta、og 設定，供後面設定參考用。
    3. 相關圖片、icon 靜態檔 etc: favicon 。
    4. 其他看個人設定
4. 移除上述以外的檔案以及資料夾。

### Hugo 設定

1. 找個喜歡的 [themes](https://themes.gohugo.io)
    - [PaperMod](https://github.com/adityatelange/hugo-PaperMod)
    - [Clarity](https://themes.gohugo.io/themes/hugo-clarity)
2. 這邊是使用 PaperMod
3. 移動到 blog repo
4. 參考 [theme 文件](https://github.com/adityatelange/hugo-PaperMod/wiki/Installation#guide)
```
# 會把 Hugo config 建立出來
hugo new site <name of site> -f yml
```
5. 載入 theme ，我這邊使用的的是 文件上 [method 2 git submodule](https://github.com/adityatelange/hugo-PaperMod/wiki/Installation#method-2)

註記：如果 git 版本比較新，文件上指令要是 `git submodule--helper`

6. 參考 [theme config.yml](https://github.com/adityatelange/hugo-PaperMod/blob/exampleSite/config.yml) 跟以前的 Hexo 做相關設定
7. 將以前 `Hexo` 的 `souce/posts` 搬到 `content/posts` 裡面。
8. 設定 [Archives Layout](https://github.com/adityatelange/hugo-PaperMod/wiki/Features#archives-layout)
9. 建立 static 資料夾，將以前的靜態資源放進來，我這裡只有放 favicon
10. 本機起 server 確認有沒有問題
```
hugo server
```
---
## GitHub 設定
### 設定 Action
1. 在 repo `.github/workflows/` 下建立 action 設定。
```
touch github-pages.yml
```
2. 參考[官方文件](https://github.com/peaceiris/actions-hugo#getting-started)，基本上可以照抄，要特別注意註解的地方
```
# github-pages.yml
name: GitHub Pages

on:
  push:
    branches:
      - main  # Set a branch to deploy 這：指當哪一個 br 做 push 時，要做事，這邊我是設定成 hugo
  pull_request:

jobs:
  deploy:
    runs-on: ubuntu-20.04
    concurrency:
      group: ${{ github.workflow }}-${{ github.ref }}
    steps:
      - uses: actions/checkout@v2
        with:
          submodules: true  # Fetch Hugo themes (true OR recursive)
          fetch-depth: 0    # Fetch all history for .GitInfo and .Lastmod

      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v2
        with:
          hugo-version: '0.91.2'
          # extended: true

      - name: Build
        run: hugo --minify

      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        if: ${{ github.ref == 'refs/heads/main' }} # 當前 br 名稱符合條件才執行，這邊我使用的 br 一樣是 hugo
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./public
          publish_branch: master # 要推到哪一個 br 會影響到後面的 GitHub Page 設定，沒設定預設是 gh-pages
```

參考文件
[使用 Github Actions 來自動化部署 Hugo 到 Github Pages](https://blog.puckwang.com/posts/2020/use-github-actions-deploy-hugo/)


### 設定 Pages
1. 到 https://github.com/{user_name}/{repo_name}/settings/pages 設定
    - source br: master
    - 資料夾： /root

2. 有買 domain 的話，設定 custom domain。

## 部屬
都完成後，在對應的 br push 後，action 就會自動 build 後 deploy 更新 GitHub Page 。