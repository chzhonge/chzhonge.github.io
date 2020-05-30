---
title: Mac安裝Composer
date: 2020-02-22 23:48:39
tags:
    - Composer
    - PHP
    - Mac
---

![composer](https://imgur.com/IEdAhDg.png "image.png")

基本前提為環境需要有 [PHP](https://www.php.net/) ，

後續按照 [Composer 安裝教學](https://getcomposer.org/download/) 步驟做。

<!-- more -->

```php
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'e0012edf3e80b6978849f5eff0d4b4e4c79ff1609dd1e613307e16318854d24ae64f26d17af3ef0bf7cfb710ca74755a') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
```

此時在執行指令的位置，會出現以下檔案

```
composer.phar
```

測試執行 composer.phar
```
composer.phar

// 顯示
   ______
  / ____/___  ____ ___  ____  ____  ________  _____
 / /   / __ \/ __ `__ \/ __ \/ __ \/ ___/ _ \/ ___/
/ /___/ /_/ / / / / / / /_/ / /_/ (__  )  __/ /
\____/\____/_/ /_/ /_/ .___/\____/____/\___/_/
                    /_/
Composer version 1.8.5 2019-04-09 17:46:47
略...
```

將檔案移動到

```
mv ./composer.phar /usr/local/bin/composer
// 將 composer.phar 複製到 /usr/local/bin/ 目錄下並同時改名為 composer
```
##### usr 相關說明
- [鳥哥的 Linux 私房菜](http://linux.vbird.org/linux_basic/0210filepermission.php)
- [/bin /usr/bin 和 /usr/local/bin 的故事](https://www.kawabangga.com/posts/3777)


在任意位置執行 composer，顯示以下訊息，確認載入成功。
```
composer

// 顯示
   ______
  / ____/___  ____ ___  ____  ____  ________  _____
 / /   / __ \/ __ `__ \/ __ \/ __ \/ ___/ _ \/ ___/
/ /___/ /_/ / / / / / / /_/ / /_/ (__  )  __/ /
\____/\____/_/ /_/ /_/ .___/\____/____/\___/_/
                    /_/
Composer version 1.8.5 2019-04-09 17:46:47
// 略
```
