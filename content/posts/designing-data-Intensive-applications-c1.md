---
title: "資料密集型應用系統設計 (1)"
date: 2022-02-05T12:28:10+08:00
tags:
    - "資料密集型應用系統設計"
    - "資料庫"
    - "筆記"
    - "wip"
---

## 第一章 可靠性，可擴展性，可維護性的應用系統

### 背景
目前多數的系統，屬於資料密集型 (data-intensive)，著重於資料的量級、複雜度、快速變化等狀況延伸的問題。
主要組成為：資料庫、 cache 、 search index 、 steam processing 、 batch processing。
會根據情境來設計出相對合適的架構。

### 資料系統思維
書中將 Redis 、 Apache Kafka 等非 DB 也歸類在資料系統下的原因為，這些也根據情境提供了類似的功能使用，
不再是以傳統的角度，去分類這些服務。會透過組合這些服務，設計出系統。

#### 三個思路
- 可靠 p.6
- 可擴展 p.10
    - twitter tweets 優化
        - user 觀看 feed 時，會先將關注的人的 feed 拉出合併，但在後續量級提昇造成查詢負擔。
        - user 增加一個 cache feed ，當有新 tweet 時，放入到對應的 cache feed。
        - 這邊最後的方式，根據 user 的 關注的人，來做兩種方式混合使用。
    - Amazon SLO 用 P99.9
- 可維護 p.18




