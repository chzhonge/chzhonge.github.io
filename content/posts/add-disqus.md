---
title: "[2022-沒工作系列-03] Hugo PaperMod 主題安裝 Disqus"
date: 2022-01-30T23:23:41+08:00
tags:
  - Hugo
  - Golang
  - PaperMod
  - Disqus
  - wip
---

## 註冊 Disqus
1. 進入 [Disqus](https://disqus.com/) 註冊，基本上按步驟做，列出幾個比較重要的。
2. Select plan 選擇 Basic 方案
3. Select Platform 選擇手動安裝
4. 會出現兩份要放入的 html ，用途應該分別為 comment 以及 count
5. 後續把設定完成。


## 在 Hugo PaperMod 主題設定
因每個主題針對 comment 的設定可能不一樣，這以我用的 PaperMod 為例

1. 調整專案根目錄下的 config.yml
    - 新增 disqus 設定， shortname 按照在 disqus 的設定
    - 在 params 下，調整 comments 為 true

```
// 這邊
disqus:
  enable: true
  shortname: chzlab-net
  count: true
// 到這邊

params:
  title: Deric's BLOG
  // 略
  comments: true // 多這

```
2. 在專案根目錄下建立資料夾 layouts
3. 在 layouts 資料夾下 建立 partials 資料夾
4. 從專案根目錄下的 `/themes/PaperMod/layouts/partials/comments.html` 複製到 `/layouts/partials/comments.html`

```shell

cp ./themes/PaperMod/layouts/partials/comments.html ./layouts/partials/comments.html

```

5. 接下來要放入 comment 需要的 js
```
<div id="disqus_thread"></div>
<script>
    /**
    *  RECOMMENDED CONFIGURATION VARIABLES: EDIT AND UNCOMMENT THE SECTION BELOW TO INSERT DYNAMIC VALUES FROM YOUR PLATFORM OR CMS.
    *  LEARN WHY DEFINING THESE VARIABLES IS IMPORTANT: https://disqus.com/admin/universalcode/#configuration-variables    */
    /*
    var disqus_config = function () {
    this.page.url = PAGE_URL;  // Replace PAGE_URL with your page's canonical URL variable
    this.page.identifier = PAGE_IDENTIFIER; // Replace PAGE_IDENTIFIER with your page's unique identifier variable
    };
    */
    (function () { // DON'T EDIT BELOW THIS LINE
        var d = document, s = d.createElement('script');
        // 略
        (d.head || d.body).appendChild(s);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript">comments powered by
        Disqus.</a></noscript>

```


6. 調整 `/layouts/partials/comments.html`

```
/* 調整前 */

{{- /* Comments area start */ -}}
{{- /* to add comments read => https://gohugo.io/content-management/comments/ */ -}}
{{- /* Comments area end */ -}}

```
有兩種方式
 - 在 專案根目錄 `/layouts/partials/` 下 建立一個新的 `disqus.html` 用 partial 載進來。
 - 直接把 js 貼到 to add comments read 取代掉。

這邊我是用第一種方式

```
/* 調整後 */

{{- /* Comments area start */ -}}
<div class="disqus markdown">
    {{ partial "disqus.html" . }}
</div>
{{- /* Comments area end */ -}}
```

7. 這時 layouts 架構如下
```
layouts
   - partials
       - disqus.html # 新增的
       - comments.html
```

8. 確認本機有出現 comment 區塊

9. 部屬到正式機，確認可以正常留言。