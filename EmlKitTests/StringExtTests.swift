//
//  StringExtTests.swift
//  EmlKitTests
//
//  Created by zhenghongyi on 2024/10/14.
//

import XCTest

final class StringExtTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testQPDecode() {
        XCTAssertEqual("=E6=88=AA=E5=B1=8F".qpDecode(), "截屏")
        XCTAssertEqual("123=E6=88=AA=E5=B1=8F".qpDecode(), "123截屏")
        XCTAssertEqual("MF1MD=E6=88=AA=E5=B1=8F".qpDecode(), "MF1MD截屏")
    }
    
    func testGB2312() {
        var origStr = "%D7%CF%BD%FB%B3%C7%C4%A7%D6%E4_%CE%DE%CF%DE%D0%A1%CB%B5%CD%F8_www.55x.cn.rar"
        XCTAssertEqual(origStr.removingPercentEncoding(using: .gb_18030_2000), "紫禁城魔咒_无限小说网_www.55x.cn.rar")
        origStr = "=?gb2312?Q?=D7=CF=BD=FB=B3=C7=C4=A7=D6=E4_=CE=DE=CF=DE=D0=A1=CB=B5=CD=F8?="
        XCTAssertEqual(origStr.mimeDecode, "紫禁城魔咒_无限小说网")
        origStr = "=?gb2312?B?b3V0bG9va7ei0MWjrNa7x6nD+w==?="
        XCTAssertEqual(origStr.mimeDecode, "outlook发信，只签名")
    }

    func testFileNameDecode() {
        XCTAssertEqual("=?UTF-8?Q?IMG=5F0017.PNG?=".mimeDecode, "IMG_0017.PNG")
        XCTAssertEqual("=?utf-8?b?SU1HXzAwMTcuUE5H?=".mimeDecode, "IMG_0017.PNG")
        XCTAssertEqual("=?utf-8?Q?=E6=88=AA=E5=B1=8F_?=2024-02-27 =?utf-8?Q?=E4=B8=8B=E5=8D=882.55.25.pdf?=".mimeDecode, "截屏_2024-02-27 下午2.55.25.pdf")
    }
    
    func testQPBreak() {
        XCTAssertEqual("<p>=E5=86=85=E5=AE=B9=E5=86=85=E5=AE=\r\n=B9</p>".qpDecode(breakKey: .rn), "<p>内容内容</p>")
    }
    
    func testIsASCIICharacter() {
        var charSet: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
        for item in charSet {
            XCTAssertTrue(String.isASCIICharacter(item))
            XCTAssertTrue(String.isASCIICharacter(item.uppercased().first!))
        }
        charSet = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        for item in charSet {
            XCTAssertTrue(String.isASCIICharacter(item))
        }
        for item in "`~!@#$%^&*()-_=+[{]}\\|;:'\",<.>/?" {
            XCTAssertTrue(String.isASCIICharacter(item))
        }
        XCTAssertFalse(String.isASCIICharacter("富"))
        XCTAssertFalse(String.isASCIICharacter("一"))
    }
    
    func testQPEncode() {
        XCTAssertEqual("fl23il".qpEncode(), "fl23il")
        XCTAssertEqual("IMG_0017.PNG".qpEncode(), "IMG_0017.PNG")
        XCTAssertEqual("测试结果2013.PNG".qpEncode(), "=E6=B5=8B=E8=AF=95=E7=BB=93=E6=9E=9C2013.PNG")
        XCTAssertEqual("学习资料2015年6月份.pdf".qpEncode(), "=E5=AD=A6=E4=B9=A0=E8=B5=84=E6=96=992015=E5=B9=B46=E6=9C=88=E4=BB=BD.pdf")
        XCTAssertEqual("截屏 202内容.png".qpEncode(), "=E6=88=AA=E5=B1=8F 202=E5=86=85=E5=AE=B9.png")
        XCTAssertEqual("截屏+202内容.png".qpEncode(), "=E6=88=AA=E5=B1=8F+202=E5=86=85=E5=AE=B9.png")
        XCTAssertEqual("发放大镜付了定金阿拉法到啦刷卡机卡拉季放大发多少啊范德萨".qpEncode(), "=E5=8F=91=E6=94=BE=E5=A4=A7=E9=95=9C=E4=BB=98=E4=BA=86=E5=AE=9A=E9=87=91=\n=E9=98=BF=E6=8B=89=E6=B3=95=E5=88=B0=E5=95=A6=E5=88=B7=E5=8D=A1=E6=9C=BA=\n=E5=8D=A1=E6=8B=89=E5=AD=A3=E6=94=BE=E5=A4=A7=E5=8F=91=E5=A4=9A=E5=B0=91=\n=E5=95=8A=E8=8C=83=E5=BE=B7=E8=90=A8")
        XCTAssertEqual("fdlajfkldjsalfjdklsajfkldjsfjdklsafjkldsajfkldjsfdklsajfdkljsafkldjsfdklsafjdlfjdlasj".qpEncode(), "fdlajfkldjsalfjdklsajfkldjsfjdklsafjkldsajfkldjsfdklsajfdkljsafkldjsfdklsaf=\njdlfjdlasj")
        XCTAssertEqual("1234发放大镜付了定金".qpEncode(), "1234=E5=8F=91=E6=94=BE=E5=A4=A7=E9=95=9C=E4=BB=98=E4=BA=86=E5=AE=9A=\n=E9=87=91")
        XCTAssertEqual("123发放大镜付了定金".qpEncode(), "123=E5=8F=91=E6=94=BE=E5=A4=A7=E9=95=9C=E4=BB=98=E4=BA=86=E5=AE=9A=E9=87=91")
    }
    
    func testMimeEncode() {
        var message: String = "Trump 特朗普"
        var encodeResult = message.mimeEncode()
        XCTAssertEqual(encodeResult.encodeType, .quotedPrintable)
        XCTAssertEqual(encodeResult.encoded.count, 1)
        XCTAssertEqual(encodeResult.encoded.first, "Trump =E7=89=B9=E6=9C=97=E6=99=AE")
        
        message = "郑成功"
        encodeResult = message.mimeEncode()
        XCTAssertEqual(encodeResult.encodeType, .base64)
        XCTAssertEqual(encodeResult.encoded.count, 1)
        XCTAssertEqual(encodeResult.encoded.first, "6YOR5oiQ5Yqf")
        
        message = "abc"
        encodeResult = message.mimeEncode()
        XCTAssertNil(encodeResult.encodeType)
        XCTAssertEqual(encodeResult.encoded.count, 1)
        XCTAssertEqual(encodeResult.encoded.first, "abc")
        
        message = "a bc"
        encodeResult = message.mimeEncode()
        XCTAssertNil(encodeResult.encodeType)
        XCTAssertEqual(encodeResult.encoded.count, 1)
        XCTAssertEqual(encodeResult.encoded.first, "a bc")
        
        message = "fdlajfkldjsalfjdklsajfkldjsfjdklsafjkldsajfkldjsfdklsajfdkljsafkldjsfdklsafjdlfjdlasj"
        encodeResult = message.mimeEncode()
        XCTAssertNil(encodeResult.encodeType)
        XCTAssertEqual(encodeResult.encoded.count, 1)
        XCTAssertEqual(encodeResult.encoded.first, "fdlajfkldjsalfjdklsajfkldjsfjdklsafjkldsajfkldjsfdklsajfdkljsafkldjsfdklsafjdlfjdlasj")
        
        message = "1234发放大镜付了定金"
        encodeResult = message.mimeEncode(type: .quotedPrintable, enableMutliLines: true)
        XCTAssertEqual(encodeResult.encodeType, .quotedPrintable)
        XCTAssertEqual(encodeResult.encoded.count, 2)
        XCTAssertEqual(encodeResult.encoded[0], "1234=E5=8F=91=E6=94=BE=E5=A4=A7=E9=95=9C=E4=BB=98=E4=BA=86=E5=AE=9A")
        XCTAssertEqual(encodeResult.encoded[1], "=E9=87=91")
        
        message = "附件打开了封疆大吏撒剪发卡溜达鸡收垃圾离开家"
        encodeResult = message.mimeEncode(type: .base64, enableMutliLines: true)
        XCTAssertEqual(encodeResult.encodeType, .base64)
        XCTAssertEqual(encodeResult.encoded.count, 2)
        XCTAssertEqual(encodeResult.encoded[0], "6ZmE5Lu25omT5byA5LqG5bCB55aG5aSn5ZCP5pKS5Ymq5Y+R5Y2h5rqc6L6+6bih")
        XCTAssertEqual(encodeResult.encoded[1], "5pS25Z6D5Zy+56a75byA5a62")
    }

    func testBase64Format() {
        let base64Str = "MIIFpgYJKoZIhvcNAQcCoIIFlzCCBZMCAQExDTALBglghkgBZQMEAgEwCwYJKoZI\nhvcNAQcBoIIDDzCCAwswggHzAhRDfFu8ZgB340jYj3bBnl0p3LB6LjANBgkqhkiG\n9w0BAQ0FADA1MQswCQYDVQQGEwJDTjERMA8GA1UECgwIQ29yZW1haWwxEzARBgNV\nBAMMCkNvcmVtYWlsQ0EwHhcNMjQwODE0MDcyMzQwWhcNMzQwODE0MDcyMzQwWjBP\nMQswCQYDVQQGEwJDTjERMA8GA1UECgwIQ29yZW1haWwxEDAOBgNVBAMMB+eUqOaI\nt0ExGzAZBgkqhkiG9w0BCQEWDGFhYUA2MDEwLmNvbTCCASIwDQYJKoZIhvcNAQEB\nBQADggEPADCCAQoCggEBANEwzZrtKQG/GjcPmuER9WkN6Shgc/zM1AljRXmTkzDP\n/wK+l+/Tmpy3/shBusn0NVStKEmM84fc59+h76kXr57BbzLByfTrbsNgWgv6VO7H\nYy9A2gH+6gDtgpCOu39oakZkKiPWzyf/o+2h48mf2zIfhdacu61n9s/GeDG1/eGq\np/c9YoC/UissnlpXl+vu8zbQf2tVRxDBLetj7vi5DDCACz9TktEtYW2TWYt8w+QI\nZScvP1VKF4Z7AkxDws/151+seP3ZeBpsQI4RIRQJxC0DaCfScXCaH6BifFixRSPW\npZZtc2QWBBTdPU088ETvx5MgjM0Y7Jfb5T1E6/RDi4cCAwEAATANBgkqhkiG9w0B\nAQ0FAAOCAQEAVWfQLHarghXGd7Mt3rfb2+j5XnjLQbWKBd43ZfkgOKoT/oO2i25C\nMUiB6AvgmklnOaPHdYhk/XyHwWIapRwq84QZ/wWf8GcJvFQgzsnNtuY1NhIltf4p\nGmvRZxYw+dmfcGYdzu5itDstigJnYYF6+ZqL4imsJA5KYXFIOioN3deOS9hv+TIe\n0PNouGsPv9HYvjDdrSJQRjEuK4srBSijFgI9YxzrawQjQ2lbv5pTcXwbZZm3WgRz\neKjueQ+mrvh9gqzlp61a7/scJUE+Sbr2HDjZGY6Lme5PDetx4h1YY7VTrVpMUtZD\nVbA/0CsgtMs8pU+OW7Qy4I8qWr6r+e3aiTGCAl0wggJZAgEBME0wNTELMAkGA1UE\nBhMCQ04xETAPBgNVBAoMCENvcmVtYWlsMRMwEQYDVQQDDApDb3JlbWFpbENBAhRD\nfFu8ZgB340jYj3bBnl0p3LB6LjALBglghkgBZQMEAgGggeQwGAYJKoZIhvcNAQkD\nMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjQxMTI5MDkyNzA0WjAvBgkq\nhkiG9w0BCQQxIgQgxcK2RUcsWhtg7QMiCMe5kl2nEL9UQueym2fQSTrXN9kweQYJ\nKoZIhvcNAQkPMWwwajALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFl\nAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAw\nBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwDQYJKoZIhvcNAQEBBQAEggEAN52rqC57\nnLzyvzYx9YeHFM+TJIkf9ZtJnyyp0LruYoMPNKLq1MmdXw6/K27/dRU4u2ROYdq7\nM83qkWPmn027ZUYOt1rtS7LLTaIDSffAdVpWZvNUMHOc6UZB87v3XTh9KSZL/Px/\nULOnvXehx2drI6AT/lrcTEI5VtOsXjjmRglCjVqcxiutRYTdQhbpPmrN9lu5TLxQ\nU8Izm69Sk2+EUadgxsxJKB9Wmalmj9JkW6EpCrmzpJ8h9asYTGjYqoU1B+JX4m+6\n6DfP9Q5g1nR80yLNeVmI0vnyjSrTFP9vPXZgRSVvD8ltZ5ZDMkyseSnM7fGu9XAF\n0s7lKzjC+VsNNA=="
        XCTAssertEqual(base64Str, base64Str.toBase64Format())
        XCTAssertEqual(base64Str.replacingOccurrences(of: "\n", with: "").toBase64Format(), base64Str)
    }
}
