---
title: "[2022-沒工作系列-02] Golang Command 入門"
date: 2022-01-30T21:10:37+08:00
tags:
  - golang
  - command
  - flag
  - "2022沒工作系列"
---

## 基本用法
目前練習先使用 flag package

```golang


func init() {
	flag.StringVar(&sourceFolder, "s", "", "source folder path [required]")
    // 設定要吃的參數，使用有帶 Var func 會把值存到 第一個參數中
    // output -s [path]

	flag.Usage = usage
    // 執行沒帶參數 或帶 --help / -h 會顯示的提示訊息
}

func usage() {
	fmt.Fprintln(os.Stderr, "Usage: parse [options]")
	flag.PrintDefaults()
    // 透過 flag 設定的參數說明都印出來
}
```

## 參考文件
- [Can command line flags in Go be set to mandatory?](https://stackoverflow.com/questions/31786215/can-command-line-flags-in-go-be-set-to-mandatory)
- [Go by Example: Command-Line Subcommands](https://gobyexample.com/command-line-subcommands)
- [Golang 官方文件 flag](https://pkg.go.dev/flag#Flag)

## 其他套件
- [go-flags](https://github.com/jessevdk/go-flags)
- [cobra](https://github.com/spf13/cobra)