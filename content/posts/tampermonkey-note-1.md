---
title: "[2022-沒工作系列-04] Tampermonkey 筆記"
date: 2022-02-04T19:24:53+08:00
tags:
    - "Tampermonkey"
    - "javascript"
---

## 需求
之前寫 Tampermonkey 的腳本，有些部分，一直沒時間優化，分別為：

- 自動複製檔名到 clipboard
- 下載檔案時自動命名
- 跨 script 取用變數

現在有空檔，來研究一下。

## 自動複製檔名到 clipboard
忘記之前踩到什麼問題，這次直接用 Clipboard API 就達到效果了。
writeText 可以直接帶 string 。

```js
    navigator.clipboard.writeText(GM_getValue('xxxx'))
        .then(() => {
        console.log("Copied to clipboard successfully!");
    })
    // 略
```


### 參考文件
- [https://w3c.github.io/clipboard-apis/#dom-clipboard-write](https://w3c.github.io/clipboard-apis/#dom-clipboard-write)
- [https://developer.mozilla.org/en-US/docs/Web/API/Clipboard_API](https://developer.mozilla.org/en-US/docs/Web/API/Clipboard_API)

## 下載檔案時自動命名
如果是針對 a 元素，可以直接增加 `download` attribute，使他調整下載的檔名，
但是如果 server 有特別回 `content-disposition` header 會以 server 為準，所以就不會有作用。

還有一個作法是利用 axios get 檔案後，重新塞到新連結後，再來下載就不會前面提到的問題，
不過因為我要操作的檔案不小，不適合這種作法。

所以現階段現自動設定到 clipboard ，手動貼上改檔名。


### 參考文件
- [Javascript rename file on download](https://stackify.dev/113532-javascript-rename-file-on-download)
- [Javascript: set filename to be downloaded](https://stackoverflow.com/questions/16376161/javascript-set-filename-to-be-downloaded/16377813)


## 跨 script 取用變數
用法很簡單，在 Tampermonkey 腳本增加下列兩行
```
// @grant        GM_setValue
// @grant        GM_getValue
```

原來是拆成兩個 script，後來上網找，其實直接在程式中增加 if 判斷當前 host 就可以合併了，
這樣就可以透過 `GM_getValue` 、 `GM_setValue` 來操作暫時的儲存的值。
也可以用 `GM.getValue `、 `GM.setValue`，不過這兩個回傳 Promise ，對我的情境有點麻煩，就先使用舊的方式。


### 參考文件
- [How to make GM_getValue existent in Greasemonkey on Firefox?](https://stackoverflow.com/questions/47476373/how-to-make-gm-getvalue-existent-in-greasemonkey-on-firefox)
- [Use a different variable for each domain in a Greasemonkey script](https://stackoverflow.com/questions/27370057/use-a-different-variable-for-each-domain-in-a-greasemonkey-script)
- [Tampermonkey 数据存储之 GM_setValue / GM_getValue](https://www.sunzhongwei.com/tampermonkey-gm_setvaluegm_getvalue-of-data-storage)






