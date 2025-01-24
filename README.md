# EmlKit

一个简单轻量的对 Eml 进行解信和组信的工具。

编码目前只支持 Base64 和 QuotedPrintable；字符集目前只支持 Utf8 和 GB2312。

## 解信

解信使用的是 EmlParsePart

```
let eml = "eml内容"
let part = EmlParsePart.parse(mime: eml) // 开始解信
print(part.from) // 发信人
print(part.to) // 收信人
print(part.subject) // 主题
print(part.header) // 信头信息
let subParts = part.parts // 获取组成当前part的子part
let part1 = subParts[0]
print(part1.content) // 获取子part的原文
print(part1.body) // 获取子part的body部分
print(part1.decodeBody) // 获取子part的body部分的解码后内容
print(part.html) // 获取主part的html内容
```

## 组信

组信使用的是 EmlBuilder

```
let builder = EmlBuilder()
builder.from = ("用户A", "aaa@6010.com")
builder.to =  [("用户A", "aaa@6010.com"), ("用户B", "bbb@6010.com")]
builder.subject = "房间里的撒酒疯乐凯大街收垃圾开理发鲸打卡拉萨放大输了放得开啦设计费"

let eml = builder.buildEml()
print(eml)

输出结果是
From: =?UTF-8?B?55So5oi3QQ==?= <aaa@6010.com>\r\nTo: =?UTF-8?B?55So5oi3QQ==?= <aaa@6010.com>,\r\n\t=?UTF-8?B?55So5oi3Qg==?= <bbb@6010.com>\r\nSubject: =?UTF-8?B?5oi/6Ze06YeM55qE5pKS6YWS55av5LmQ5Yev5aSn6KGX5pS25Z6D5Zy+5byA55CG?=\r\n\t=?UTF-8?B?5Y+R6bK45omT5Y2h5ouJ6JCo5pS+5aSn6L6T5LqG5pS+5b6X5byA5ZWm6K6+6K6h?=\r\n\t=?UTF-8?B?6LS5?=\r\nMIME-Version: 1.0\r\n
```

以上只是简单的使用方式，更多的使用方法，请参考项目中的对应测试用例