---
title: 正規表達式-基本概念
date: 2020-02-28 19:09:58
tags:
    - 正規表達式
    - regex
    - 正規式
    - 筆記
---

記錄 [精通正規式表達式]() 相關的心得與筆記

<!-- more -->


| 詮釋字元 | 名稱 | 匹配內容 |
| --- | --- | --- |
| . | 句點 | 任何一個字元 |
| [...] | 字元類別(character class) | 任何一個列出的字元 |
| [^...] | 反轉字元類別 | 任何一個沒有列出的字元 |
| ^ | 脫字號 | 行首位置 |
| $ | 錢號 | 行尾位置 |
| ＼| or、或、bar | 匹配由它分隔的任一表達式 |
| () | 括號 | 限制 \| 範圍 |
| \\< | word boundary | 單字開頭位置 (單詞邊界、metasequences、詮釋序列) |
| \\> | word boundary | 單字結束位置 (單詞邊界、metasequences、詮釋序列) |

特殊情境解釋：
- 在 `字元類別` 狀況，要確認 使用的詮釋字元 在 `字元類別` 內是否有意義。

- 字元類別只能在目標字串內匹配單一字元。

```
- 情境
    a[a-z] 字元類別內：有意義，表示範圍
    a[-az] 字元類別內：無意義，因未放置在範圍間，僅會當成 - 號

| 情境
    a[a|b] 字元類別內：無意義，僅代表 | 號。
```

量詞重複詮釋字元

| 詮釋字元 | 至少需要 | 最多嘗試 | 意義|
| --- | --- | --- | --- |
| \? | 無 | 1 | 允許一個;不必要(一個可省略) |
| * | 無 | 不限 | 允許無限個;不必要(任何數量皆可)) |
| + | 1 | 不限 | 允許無限個;必要一個(至少一個)) |

其他

| 詮釋字元 | 說明 |
| --- | --- |
| \w | 表示 [a-zA-Z0-9_] |
| \d | 表示 [0-9] |
| \s | 匹配 空白字元 （空白、Tab、換行、換頁) |
| \| | 匹配它分隔的左右兩個表達式之一 |
| {下限, 上限} | 至少需要下限，最多允許上限 |
| (...) | 限制選項範圍、為量詞提供群組、捕捉參考 |
| \1, \2 | 參考，匹配先前某組，括號之內匹配的內容 |
| (?:...) | 匹配，但不捕捉 |
|(?\<name\>...) | 給匹配對象群組設定 名稱 |

旁觀比對
> 旁觀比對，會檢查子表達式是否匹配，但不會取用任何匹配文字。只會找到文字內可以匹配的位置。
目標為基準的左或右邊。

| 詮釋字元 | 說明 |
| --- | --- |
| (?=...) | lookahead (往右旁觀比對)，往前看 右邊必須是|
| (?!...) | lookahead 不可為 ... |
| (?<=...) | lookbehind (往左旁觀比對)，往後看  左邊必須是|
| (?<!...) | lookbehind 不可為 ... |

```
(?<=www\.)xxx(?=\.net)

// 我要找 xxx
// 它的左邊必須是 wwww\.
// 它的右邊必須是 \.net

www.xxx.net
```

[RegExp 應用： lookahead , lookbehind - 無聊技術研究](http://darkk6.blogspot.com/2017/03/regexp-lookahead-lookbehind.html)