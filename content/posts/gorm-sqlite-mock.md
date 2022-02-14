---
title: "Gorm Sqlite 測試相關問題"
date: 2022-02-10T22:28:47+08:00
tags:
    - golang
    - sqlite
    - gorm
    - test
    - mock
---

## failed to initialize database 原因
golang + gorm 搭配 sqlite 練習測試的時候發現，
把 db 用 go-sqlmock 的替換掉後，在跑測試時會噴

```
failed to initialize database, got error all expectations were already fulfilled, call to Query 'select sqlite_version()'
```

### mysql 解法
如果 db 是用 mysql 的話，只要這樣設定

```golang
	gDB, err := gorm.Open(mysql.New(mysql.Config{
        Conn: DB,
        SkipInitializeWithVersion: true,
	}), &gorm.Config{})
```
細節可以參考 [source code](https://github.com/go-gorm/mysql/blob/373b1f04e6b8d18e5b4a611c8e2aa5abc1d75dc2/mysql.go#L110)

### sqlite 暫解

不過在 sqlite 上面看 code 是沒有開這個參數 [source code](https://github.com/go-gorm/sqlite/blob/master/sqlite.go#L36)

因為只是練習，所以我這邊先直接寫一個新的 MockDialector 把它掛進來，
然後把 sqlite.Dialector() 複製過來後把 version 不需要的地方拿掉。

實際上應該把相關的 code 都看過，確認是不是有必要開這個參數出來，然後發個 issue ，
如果沒問題 pr 做出來之類的？

可是我 sqlite 、 mysql 底層都不熟，等有機會再來研究這塊。


```golang
# MockDialector

type MockDialector struct {
	sqlite.Dialector
}

func (dialector MockDialector) Initialize(db *gorm.DB) (err error) {
	if dialector.DriverName == "" {
		dialector.DriverName = sqlite.DriverName
	}

	if dialector.Conn != nil {
		db.ConnPool = dialector.Conn
	} else {
		conn, err := sql.Open(dialector.DriverName, dialector.DSN)
		if err != nil {
			return err
		}
		db.ConnPool = conn
    }

    /*
      關於 version 的 code 移除

    var version string
	if err := db.ConnPool.QueryRowContext(context.Background(), "select sqlite_version()").Scan(&version); err != nil {
		return err
	}
	// https://www.sqlite.org/releaselog/3_35_0.html
	if compareVersion(version, "3.35.0") >= 0 {
		callbacks.RegisterDefaultCallbacks(db, &callbacks.Config{
			CreateClauses:        []string{"INSERT", "VALUES", "ON CONFLICT", "RETURNING"},
			UpdateClauses:        []string{"UPDATE", "SET", "WHERE", "RETURNING"},
			DeleteClauses:        []string{"DELETE", "FROM", "WHERE", "RETURNING"},
			LastInsertIDReversed: true,
		})
	} else {
		callbacks.RegisterDefaultCallbacks(db, &callbacks.Config{
			LastInsertIDReversed: true,
		})
    }
    */

    // 留 else 這段
	callbacks.RegisterDefaultCallbacks(db, &callbacks.Config{
		LastInsertIDReversed: true,
	})

	for k, v := range dialector.ClauseBuilders() {
		db.ClauseBuilders[k] = v
	}
	return
}
```

```golang
// mock 就這樣掛進來

gdb, err := gorm.Open(mockdb.MockDialector{Dialector: sqlite.Dialector{Conn: db}})

```

## Query: could not match actual sql
用 mock.ExpectQuery() 會噴

```
Query: could not match actual sql: "SELECT `id` FROM `users` WHERE `users`.`username` = ? AND `users`.`deleted_at`
IS NULL ORDER BY `users`.`id` LIMIT 1" with expected regexp "SELECT `id` FROM `users` WHERE `users`.`username` = ? AND `users`.`deleted_at` IS NULL ORDER BY `users`.`id` LIMIT 1"
```

明明看起來沒問題，google 發現要用 regexp.QuoteMeta 來處理反斜線，加了就正常了。

## gorm insert mock  非手動設定值
有些欄位資料是透過 gorm 或是在 db 自行建立的，例如： created_at
這時候可以透過 sqlmock.AnyArg() [2] 作為測試的參數


## 使用 Suite

### 透過 SetupTest() 處理測試環境重置
維持測試的獨立性，可以透過在 SetupTest() 設定每次測試的初始化，
這個 method 會在每個測試前執行。[3]


## 參考文件
- [sqlmock-is-not-matching-query-but-query-is-identical-and-log-output-shows-the-s](https://stackoverflow.com/questions/59652031/sqlmock-is-not-matching-query-but-query-is-identical-and-log-output-shows-the-s)
- [[2]INSERT while mocking gorm](https://github.com/DATA-DOG/go-sqlmock/issues/118#issuecomment-614573409)
- [[3]官方 suite 說明](https://pkg.go.dev/github.com/stretchr/testify/suite?utm_source=godoc#SetupTestSuite)






