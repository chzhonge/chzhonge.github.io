---
title: "Gin http request test 筆記"
date: 2022-03-01T15:12:29+08:00
tags:
    - gin
    - golang
    - test
---

## gin

### 思路
參考相關文件、 repo ，在設計上的層級類似下列這樣

server => service (interface) => repository (interface)

將 interface 開出來，實作完之後一路使用注入的逐層掛進去。

開出 interface 除了規範 method 之外，還能在後續針對測試時，
方便撰寫 mock 注入。

```
server
  | - service
         | - repository
  略
```

### 測試
以使用 gin 為例

#### get

```golang

const wantGetMsg = "mock hello eric"

func TestHelloByName(t *testing.T) {
	gin.SetMode(gin.TestMode)
	r := gin.Default()

    // di mock service
	service := MockHelloService{}
	server := NewHelloServer(service)

    // mount router
	r.GET("/hello/:name", server.SayHello)

	rq := httptest.NewRequest(http.MethodGet, "/hello/eric", nil)
	rw := httptest.NewRecorder()
	r.ServeHTTP(rw, rq)

	if rw.Body.String() != wantGetMsg {
		t.Errorf("want: %q , get: %q", wantGetMsg, rw.Body.String())
	}
}
```

#### post form-data

header 要帶
```
rq.Header.Add("Content-Type", "application/x-www-form-urlencoded")
```

```golang

const wantPostMsg = "mock post my first post"

func TestPostFormData(t *testing.T) {
	gin.SetMode(gin.TestMode)
	r := gin.Default()

	service := MockHelloService{}
	server := NewHelloServer(service)

	r.POST("/msg", server.SayPost)

	formPayload := url.Values{}
	formPayload.Set("msg", "my first post")

	rq := httptest.NewRequest(http.MethodPost, "/msg", strings.NewReader(formPayload.Encode()))
	rq.Header.Add("Content-Type", "application/x-www-form-urlencoded")
	rw := httptest.NewRecorder()
	r.ServeHTTP(rw, rq)

	if rw.Body.String() != wantPostMsg {
		t.Errorf("want: %q , get: %q", wantPostMsg, rw.Body.String())
	}
}
```

#### post json
有兩種方式帶 json
- 直接用 json string 轉成 byte
- struct 透過 json.Marshal 轉成 byte

要記得帶上
```
rq.Header.Add("Content-Type", "application/json")
```

```golang

const wantPostJsonMsg = "mock json my name eric"

func TestPostJson(t *testing.T) {
	gin.SetMode(gin.TestMode)
	r := gin.Default()

	hs := MockHelloService{}
	ss := NewHelloServer(hs)

	r.POST("/json", ss.SayJson)

	sendJson := map[string]interface{}{
		"name": "eric",
	}

	b, _ := json.Marshal(sendJson)

	rq := httptest.NewRequest(http.MethodPost, "/json", bytes.NewBuffer(b))
	rq.Header.Add("Content-Type", "application/json")
	rw := httptest.NewRecorder()
	r.ServeHTTP(rw, rq)

	if rw.Body.String() != wantPostJsonMsg {
		t.Errorf("want: %q , get: %q", wantPostJsonMsg, rw.Body.String())
	}
}
```


## 參考文件
- [Revisiting HTTP Handlers](https://quii.gitbook.io/learn-go-with-tests/questions-and-answers/http-handlers-revisited)
- [04 - Testing A Gin HTTP Handler With Testify Mock](https://dev.to/jacobsngoodwin/04-testing-first-gin-http-handler-9m0)
- [github.com/JacobSNGoodwin/memrizr](https://github.com/JacobSNGoodwin/memrizr/blob/master/account/handler/signin_test.go)


## 延伸閱讀
- [https://github.com/golang/go/wiki/CodeReviewComments#interfaces](https://github.com/golang/go/wiki/CodeReviewComments#interfaces)
- [Should my methods return structs or interfaces in Go?](https://dev.to/lcaparelli/should-my-methods-return-structs-or-interfaces-in-go-3b7)