---
title: python flask 體驗
date: 2021-01-22 14:00:00
tags:
    - python
    - flask
    - pip
---

# 原因

因為最近需要使用 python 作為 api 開發的環境，與團隊成員討論後，決定使用 flask web framework 框架，第一次使用，記錄相關的筆記。

# 套件管理 pip
pip 基本上可以當做 php 的 composer，
相關的紀錄會在 requirements.txt 。

## 指令
如果有更動過套件，記得在專案下 `pip freeze > requirements.txt`，把目前的套件記錄匯出來，避免套件不一致。
> 這邊他也會把相依的套件記錄也一併輸出。

### 安裝
```
pip install flask

// 指定版號
pip install -v flask==1.0

// 透過指定檔案安裝套件，通常都使用 requirements.txt 作為檔名
pip install -r [檔案名稱]
pip install -r requirements.txt
```
### 建立套件清單
```
pip freeze > [檔案名稱]
pip freeze > requirements.txt
```

# flask

## 啟用 debug mode

設定 env FLASK_ENV 為 developmen，開啟同時也會啟用 hot reload，這樣變動檔案馬上就會更新。

```
export FLASK_ENV=development
```

# uwsgi
待續
# gunicorn
待續

# 參考
[官方文件](https://flask.palletsprojects.com/en/master/debugging/)
