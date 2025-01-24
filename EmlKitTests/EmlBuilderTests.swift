//
//  EmlBuilderTests.swift
//  EmlKitTests
//
//  Created by zhenghongyi on 2024/11/14.
//

import XCTest

final class EmlBuilderTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUsersAndSubject() {
        let builder = EmlBuilder()
        builder.from = ("用户A", "aaa@6010.com")
        builder.to =  [("用户A", "aaa@6010.com"), ("用户B", "bbb@6010.com")]
        builder.subject = "房间里的撒酒疯乐凯大街收垃圾开理发鲸打卡拉萨放大输了放得开啦设计费"
        
        let eml = builder.buildEml()
        print(eml)
        XCTAssertTrue(eml.hasSuffix("From: =?UTF-8?B?55So5oi3QQ==?= <aaa@6010.com>\r\nTo: =?UTF-8?B?55So5oi3QQ==?= <aaa@6010.com>,\r\n\t=?UTF-8?B?55So5oi3Qg==?= <bbb@6010.com>\r\nSubject: =?UTF-8?B?5oi/6Ze06YeM55qE5pKS6YWS55av5LmQ5Yev5aSn6KGX5pS25Z6D5Zy+5byA55CG?=\r\n\t=?UTF-8?B?5Y+R6bK45omT5Y2h5ouJ6JCo5pS+5aSn6L6T5LqG5pS+5b6X5byA5ZWm6K6+6K6h?=\r\n\t=?UTF-8?B?6LS5?=\r\nMIME-Version: 1.0\r\n"))
    }
    
    func testSimpleBodyText() {
        let builder = EmlBuilder()
        builder.from = ("用户A", "aaa@6010.com")
        builder.to =  [("用户A", "aaa@6010.com"), ("用户B", "bbb@6010.com")]
        builder.subject = "房间里的撒酒疯乐凯大街收垃圾开理发鲸打卡拉萨放大输了放得开啦设计费"
        let plainText = "房间里的撒酒疯乐凯大街收垃圾开理发鲸打卡拉萨放大输了放得开啦设计费"
        builder.text = .plain(content: plainText)
        
        let eml = builder.buildEml()
        print(eml)
        let mainPart = EmlParsePart.parse(mime: eml)
        XCTAssertTrue(mainPart.isAlternativePart)
        let subParts = mainPart.parts
        XCTAssertTrue(subParts.count == 2)
        let plainPart = subParts[0]
        let htmlPart = subParts[1]
        XCTAssertTrue(plainPart.isPlainPart)
        XCTAssertTrue(htmlPart.isHtmlPart)
        XCTAssertEqual(plainPart.body, plainText.mimeEncode(enableMutliLines: true).encoded.joined(separator: "\r\n"))
    }
    
    func testSimpleBodyHtml() {
        let builder = EmlBuilder()
        builder.from = (nil, "aaa@6010.com")
        builder.to =  [(nil, "bbb@6010.com")]
        builder.subject = "S"
        builder.text = .html(content: "Fdsa")
        let eml = builder.buildEml()
        print(eml)
        let mainPart = EmlParsePart.parse(mime: eml)
        XCTAssertTrue(mainPart.isAlternativePart)
        let subParts = mainPart.parts
        XCTAssertTrue(subParts.count == 1)
        let htmlPart = subParts[0]
        XCTAssertEqual(htmlPart.body, "Fdsa")
    }
    
    func testOneInlineTextEml() {
        let builder = EmlBuilder()
        builder.from = ("用户A", "aaa@6010.com")
        builder.to =  [("用户A", "aaa@6010.com"), ("用户B", "bbb@6010.com")]
        builder.subject = "房间里的撒酒疯乐凯大街收垃圾开理发鲸打卡拉萨放大输了放得开啦设计费"
        let plainText = "房间里的撒酒疯乐凯大街收垃圾开理发鲸打卡拉萨放大输了放得开啦设计费"
        builder.text = .plain(content: plainText)
        
        let inlinePart = EmlBuildPart()
        inlinePart.contentType = "image/png"
        inlinePart.fileName = "baidulogo.png"
        inlinePart.contentID = "70203924$1$191930bc413$Coremail$aaa$6010.com>"
        inlinePart.body = """
        UklGRqQVAABXRUJQVlA4WAoAAAAQAAAA/QAATwAAQUxQSE4HAAAB8Ibt/yKn/f89B3cmuCWZ4K6H
        B3d3t2xwr3v6zlJ3d1vq7i1ODHfXyNDYgTULfeOB1/PGvPy12b0bERMAJW9VpwZIredUgMi38r0H
        """
        builder.inlineFiles = [inlinePart]
        
        let eml = builder.buildEml()
        print(eml)
        let mainPart = EmlParsePart.parse(mime: eml)
        XCTAssertTrue(mainPart.isRelatedPart)
        let subParts = mainPart.parts
        XCTAssertEqual(subParts.count, 2)
        let textPart = subParts[0]
        let inlinesPart = subParts[1]
        XCTAssertTrue(textPart.isAlternativePart)
        XCTAssertTrue(inlinesPart.isInlinePart)
    }
    
    func testMultiInlinesTextEml () {
        let builder = EmlBuilder()
        builder.from = ("用户A", "aaa@6010.com")
        builder.to =  [("用户A", "aaa@6010.com"), ("用户B", "bbb@6010.com")]
        builder.subject = "房间里的撒酒疯乐凯大街收垃圾开理发鲸打卡拉萨放大输了放得开啦设计费"
        let plainText = "房间里的撒酒疯乐凯大街收垃圾开理发鲸打卡拉萨放大输了放得开啦设计费"
        builder.text = .plain(content: plainText)
        
        let inlinePart1 = EmlBuildPart()
        inlinePart1.contentType = "image/png"
        inlinePart1.fileName = "baidulogo.png"
        inlinePart1.contentID = "70203924$1$191930bc413$Coremail$aaa$6010.com>"
        inlinePart1.body = """
        UklGRqQVAABXRUJQVlA4WAoAAAAQAAAA/QAATwAAQUxQSE4HAAAB8Ibt/yKn/f89B3cmuCWZ4K6H
        B3d3t2xwr3v6zlJ3d1vq7i1ODHfXyNDYgTULfeOB1/PGvPy12b0bERMAJW9VpwZIredUgMi38r0H
        """
        
        let inlinePart2 = EmlBuildPart()
        inlinePart2.contentType = "image/png"
        inlinePart2.fileName = "百度.png"
        inlinePart2.contentID = "123134214320987"
        inlinePart2.body = """
        UklGRqQVAABXRUJQVlA4WAoAAAAQAAAA/QAATwAAQUxQSE4HAAAB8Ibt/yKn/f89B3cmuCWZ4K6H
        B3d3t2xwr3v6zlJ3d1vq7i1ODHfXyNDYgTULfeOB1/PGvPy12b0bERMAJW9VpwZIredUgMi38r0H
        """
        
        builder.inlineFiles = [inlinePart1, inlinePart2]
        
        let eml = builder.buildEml()
        
        let mainPart = EmlParsePart.parse(mime: eml)
        XCTAssertTrue(mainPart.isRelatedPart)
        let subParts = mainPart.parts
        XCTAssertEqual(subParts.count, 3)
        let textPart = subParts[0]
        let inline1Part = subParts[1]
        let inline2Part = subParts[2]
        XCTAssertTrue(textPart.isAlternativePart)
        XCTAssertTrue(inline1Part.isInlinePart)
        XCTAssertTrue(inline2Part.isInlinePart)
    }
    
    func testOneFileTextEml() {
        let builder = EmlBuilder()
        builder.from = ("用户A", "aaa@6010.com")
        builder.to =  [("用户A", "aaa@6010.com"), ("用户B", "bbb@6010.com")]
        builder.subject = "房间里的撒酒疯乐凯大街收垃圾开理发鲸打卡拉萨放大输了放得开啦设计费"
        let plainText = "房间里的撒酒疯乐凯大街收垃圾开理发鲸打卡拉萨放大输了放得开啦设计费"
        builder.text = .plain(content: plainText)
        
        let filePart = EmlBuildPart()
        filePart.contentType = "application/rtf"
        filePart.fileName = "Xcode15解决思路.rtf"
        filePart.body = """
        e1xydGYxXGFuc2lcYW5zaWNwZzkzNlxjb2NvYXJ0ZjI3NTcKXGNvY29hdGV4dHNjYWxpbmcwXGNv
        Y29hcGxhdGZvcm0we1xmb250dGJsXGYwXGZzd2lzc1xmY2hhcnNldDAgSGVsdmV0aWNhO1xmMVxm
        """
        builder.files = [filePart]
        
        let eml = builder.buildEml()
        print(eml)
        let mainPart = EmlParsePart.parse(mime: eml)
        XCTAssertTrue(mainPart.isMixedPart)
        let subParts = mainPart.parts
        XCTAssertEqual(subParts.count, 2)
        let textPart = subParts[0]
        let filesPart = subParts[1]
        XCTAssertTrue(textPart.isAlternativePart)
        XCTAssertTrue(filesPart.isAttachmentPart)
    }
    
    func testFullEml() {
        let builder = EmlBuilder()
        builder.from = ("用户A", "aaa@6010.com")
        builder.to =  [("用户A", "aaa@6010.com"), ("用户B", "bbb@6010.com")]
        builder.subject = "房间里的撒酒疯乐凯大街收垃圾开理发鲸打卡拉萨放大输了放得开啦设计费"
        let plainText = "房间里的撒酒疯乐凯大街收垃圾开理发鲸打卡拉萨放大输了放得开啦设计费"
        builder.text = .plain(content: plainText)
        
        let inlinePart = EmlBuildPart()
        inlinePart.contentType = "image/png"
        inlinePart.fileName = "baidulogo.png"
        inlinePart.contentID = "70203924$1$191930bc413$Coremail$aaa$6010.com>"
        inlinePart.body = """
        UklGRqQVAABXRUJQVlA4WAoAAAAQAAAA/QAATwAAQUxQSE4HAAAB8Ibt/yKn/f89B3cmuCWZ4K6H
        B3d3t2xwr3v6zlJ3d1vq7i1ODHfXyNDYgTULfeOB1/PGvPy12b0bERMAJW9VpwZIredUgMi38r0H
        """
        builder.inlineFiles = [inlinePart]
        
        let filePart = EmlBuildPart()
        filePart.contentType = "application/rtf"
        filePart.fileName = "Xcode15解决思路.rtf"
        filePart.body = """
        e1xydGYxXGFuc2lcYW5zaWNwZzkzNlxjb2NvYXJ0ZjI3NTcKXGNvY29hdGV4dHNjYWxpbmcwXGNv
        Y29hcGxhdGZvcm0we1xmb250dGJsXGYwXGZzd2lzc1xmY2hhcnNldDAgSGVsdmV0aWNhO1xmMVxm
        """
        builder.files = [filePart]
        
        let eml = builder.buildEml()
        print(eml)
        let mainPart = EmlParsePart.parse(mime: eml)
        XCTAssertTrue(mainPart.isMixedPart)
        let subParts = mainPart.parts
        XCTAssertEqual(subParts.count, 2)
        let relatedPart = subParts[0]
        let filesPart = subParts[1]
        XCTAssertTrue(relatedPart.isRelatedPart)
        XCTAssertTrue(filesPart.isAttachmentPart)
    }
    
    func testOnlyOneFile() {
        let builder = EmlBuilder()
        builder.from = ("用户A", "aaa@6010.com")
        builder.to =  [("用户A", "aaa@6010.com"), ("用户B", "bbb@6010.com")]
        builder.subject = "房间里的撒酒疯乐凯大街收垃圾开理发鲸打卡拉萨放大输了放得开啦设计费"
        
        let filePart = EmlBuildPart()
        filePart.contentType = "application/rtf"
        filePart.fileName = "Xcode15解决思路.rtf"
        filePart.body = """
        e1xydGYxXGFuc2lcYW5zaWNwZzkzNlxjb2NvYXJ0ZjI3NTcKXGNvY29hdGV4dHNjYWxpbmcwXGNv
        Y29hcGxhdGZvcm0we1xmb250dGJsXGYwXGZzd2lzc1xmY2hhcnNldDAgSGVsdmV0aWNhO1xmMVxm
        """
        filePart.breakKey = builder.breakKey.rawValue
        builder.files = [filePart]
        
        let eml = builder.buildEml()
        print(eml)
        let mainPart = EmlParsePart.parse(mime: eml)
        XCTAssertTrue(mainPart.isAttachmentPart)
    }
}
