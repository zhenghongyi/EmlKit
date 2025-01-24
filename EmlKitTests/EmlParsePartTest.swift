//
//  EmlParsePartTest.swift
//  EmlKitTests
//
//  Created by zhenghongyi on 2024/10/14.
//

import XCTest

final class EmlParsePartTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSimple() {
        let eml = """
        Received: from emailgateway.icoremail.net (unknown [10.11.150.8])
            by mailtech_rd (Coremail) with SMTP id AgIMCgDnRwmRZNpmvxwAAA--.547S2;
            Fri, 06 Sep 2024 10:10:25 +0800 (CST)
        Received: from mailtech.cn (unknown [120.196.124.154])
            by mtasvr (Coremail) with SMTP id _____wDnGdiQZNpmQAEDAA--.10924S3;
            Fri, 06 Sep 2024 10:10:25 +0800 (CST)
        Received: from localhost (unknown [::1])
            by mailtech_rd (Coremail) with SMTP id TSWEB_00000001000078D966DA6478;
            Fri, 06 Sep 2024 10:10:00 +0800 (CST)
        Received: from hyzheng$coremail.cn ( [120.196.124.154] ) by
         ajax-webmail-mailtech (Coremail) ; Tue, 17 Oct 2023 10:12:37 +0800 (CST)
        X-Originating-IP: [120.196.124.154]
        Date: Fri, 6 Sep 2024 10:10:00 +0800 (CST)
        X-CM-HeaderCharset: UTF-8
        From: =?UTF-8?B?6YOR5rSq55uK?= <hyzheng@coremail.cn>
        To: =?UTF-8?B?6YOR5rSq55uK?= <hyzheng@coremail.cn>
        Subject: =?UTF-8?B?5LyB5Lia6LSm5Y+357ut6LS55YmN6K+m5oOF5o+Q5Lqk?=
        X-Priority: 3
        X-Mailer: Coremail Webmail Server Version 2023.2-cmXT6 build
         20230714(eb2b3919) Copyright (c) 2002-2023 www.mailtech.cn
         mispb-8dfce572-2f24-404d-b59d-0dd2e304114c-icoremail.cn
        Content-Transfer-Encoding: base64
        Content-Type: text/plain; charset=UTF-8
        MIME-Version: 1.0
        Message-ID: <416300fa.46.18b3b680fb1.Coremail.hyzheng@coremail.cn>
        X-Coremail-Locale: zh_CN
        X-CM-DELIVERINFO: =?B?qnStnHWDHpY/jD+Zu3pX6FtZb4A5oSAgAAXpoFyl3kY+ZOAl2Una2QCizppGz1G03N
            Him8AOzZVW2tFyB+GzFlvr1atvKi3xg9QSiICIcZA84ql7wdsgKsp1iSt38dIU9MKrdm8q
            LfGD1BKIgIhxkDziqXspgf7xtVxrhVtEvhalk8d/
        X-CM-TRANSID:AgIMCgDnRwmRZNpmvxwAAA--.547S2
        Authentication-Results: mailtech_rd; spf=neutral smtp.mail=hyzheng@cor
            email.cn;
        X-CM-SenderInfo: xk12xv1qj6u05uhptxfoof0/1tbiAQcECWUn+CsJhQAWsA
        X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
            Iv6xkF7I0E14v26r1j6r4UMVCEFcxC0VAYjxAxZFUvcSsGvfC2KfnxnUUI43ZEXa7IU8Vb
            yJUUUUU==


        5LyB5Lia6LSm5Y+357ut6LS55YmN6K+m5oOF5o+Q5Lqk
        """
        let part = EmlParsePart.parse(mime: eml)
        XCTAssertTrue(part.parts.count == 0)
        XCTAssertEqual(part.content, eml)
        XCTAssertEqual(part.body, "5LyB5Lia6LSm5Y+357ut6LS55YmN6K+m5oOF5o+Q5Lqk")
        let header = part.header
        XCTAssertTrue(header.count == 19)
        XCTAssertEqual(part.from, "郑洪益 <hyzheng@coremail.cn>")
        XCTAssertEqual(part.to, "郑洪益 <hyzheng@coremail.cn>")
        XCTAssertEqual(part.subject, "企业账号续费前详情提交")
    }
    
    func testTextEml() {
        let eml = """
        Received: from b$smime.cn ( [192.168.201.159] ) by ajax-webmail-tpl-centos7
         (Coremail) ; Sat, 12 Oct 2024 09:39:46 +0800 (GMT+08:00)
        X-Originating-IP: [192.168.201.159]
        Date: Sat, 12 Oct 2024 09:39:46 +0800 (GMT+08:00)
        X-CM-HeaderCharset: UTF-8
        From: b@smime.cn
        To: =?UTF-8?B?5Yqo5oCB6YKu5Lu25YiX6KGoMg==?= <dynamic2@smime.cn>
        Subject: =?UTF-8?B?5ZOI5ZOI?=
        X-Priority: 3
        X-Mailer: Coremail Webmail Server Version 2024.1-cmXT6 build
         20240522(f9ac29d3) lunkr_ios(4.0.8.2.773) Copyright (c) 2002-2024
         www.mailtech.cn mispb-8dfce572-2f24-404d-b59d-0dd2e304114c-icoremail.cn
        Content-Type: multipart/alternative;
            boundary="----=_Part_283_435110012.1728697186360"
        MIME-Version: 1.0
        Message-ID: <6924e858.6f.1927e61b839.Coremail.b@smime.cn>
        X-Coremail-Locale: zh_CN
        X-CM-TRANSID:AQAAfwC3NkFi0wlntggAAA--.65W
        X-CM-SenderInfo: 3e6vzxlphou0/1tbiAQAIC2cI4iAABQAAsq
        X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3GIAIbVAYFVCjjxCrMI
            AIbVAFxVCF77xC64kEw24lV2xY67C26IkvcIIF6IxKo4kEV4DvcSsGvfC2KfnxnUU==
        Delivered-To: dynamic2@smime.cn
        Precedence: list
        X-Ack: No
        Errors-to: b@smime.cn
        List-Post: <mailto:dynamic2@smime.cn>
        List-Id: coremail maillist dynamic2@smime.cn
        X-CM-Resent-From: dynamic2@smime.cn

        ------=_Part_283_435110012.1728697186360
        Content-Type: text/plain; charset=UTF-8
        Content-Transfer-Encoding: base64

        5LqG5LqG5LqGCgoKCuWPkeiHqkNvcmVtYWlsCg==
        ------=_Part_283_435110012.1728697186360
        Content-Type: text/html; charset=UTF-8
        Content-Transfer-Encoding: base64

        5LqG5LqG5LqGPGJyPjxicj48YnI+PGJyPuWPkeiHqkNvcmVtYWlsPGJyPg==
        ------=_Part_283_435110012.1728697186360--
        """
        let part = EmlParsePart.parse(mime: eml)
        let subParts = part.parts
        XCTAssertTrue(subParts.count == 2)
        let part1 = subParts[0]
        let part2 = subParts[1]
        XCTAssertTrue(part1.isPlainPart)
        XCTAssertTrue(part2.isHtmlPart)
        
        XCTAssertTrue(part1.isBase64Encoding)
        XCTAssertTrue(part2.isBase64Encoding)
        
        let body1 = part1.body
        XCTAssertEqual(body1, "5LqG5LqG5LqGCgoKCuWPkeiHqkNvcmVtYWlsCg==")
        let body2 = part2.body
        XCTAssertEqual(body2, "5LqG5LqG5LqGPGJyPjxicj48YnI+PGJyPuWPkeiHqkNvcmVtYWlsPGJyPg==")
        
        let txt = part1.decodeBody
        XCTAssertEqual(txt, "了了了\n\n\n\n发自Coremail\n")
        let html = part2.decodeBody
        XCTAssertEqual(html, "了了了<br><br><br><br>发自Coremail<br>")
    }
    
    func testTextAndFileEml() {
        let eml = """
        Received: from b$smime.cn ( [192.168.170.243] ) by ajax-webmail-tpl-centos7
         (Coremail) ; Thu, 10 Oct 2024 10:01:18 +0800 (GMT+08:00)
        X-Originating-IP: [192.168.170.243]
        Date: Thu, 10 Oct 2024 10:01:18 +0800 (GMT+08:00)
        X-CM-HeaderCharset: UTF-8
        From: b@smime.cn
        To: 11 <a@smime.cn>
        Subject: fffff
        X-Priority: 3
        X-Mailer: Coremail Webmail Server Version 2024.1-cmXT6 build
         20240522(f9ac29d3) lunkr_android(4.0.8.0.545) Copyright (c) 2002-2024
         www.mailtech.cn mispb-8dfce572-2f24-404d-b59d-0dd2e304114c-icoremail.cn
        X-CM-CTRLMSGS: nzH4YA==
        Content-Type: multipart/mixed;
            boundary="----=_Part_200_144267934.1728525678098"
        MIME-Version: 1.0
        Message-ID: <4af3b992.43.1927428b612.Coremail.b@smime.cn>
        X-Coremail-Locale: zh_CN
        X-CM-TRANSID:AQAAfwC3NkFvNQdnVAcAAA--.36W
        X-CM-SenderInfo: 3e6vzxlphou0/1tbiAQAIC2ZRthUAAQA5su
        X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3GIAIbVAYFVCjjxCrMI
            AIbVAFxVCF77xC64kEw24lV2xY67C26IkvcIIF6IxKo4kEV4DvcSsGvfC2KfnxnUU==

        ------=_Part_200_144267934.1728525678098
        Content-Type: multipart/alternative;
            boundary="----=_Part_202_850764773.1728525678098"

        ------=_Part_202_850764773.1728525678098
        Content-Type: text/plain; charset=UTF-8
        Content-Transfer-Encoding: base64

        CgpGdGRkZGQKCgoK5p2l6IeqQ29yZW1haWw=
        ------=_Part_202_850764773.1728525678098
        Content-Type: text/html; charset=UTF-8
        Content-Transfer-Encoding: base64

        PGJyPjxicj5GdGRkZGQ8YnI+PGJyPjxicj48YnI+5p2l6IeqQ29yZW1haWw=
        ------=_Part_202_850764773.1728525678098--

        ------=_Part_200_144267934.1728525678098
        Content-Type: application/zip; name=z_share_1010-1001.zip
        Content-Transfer-Encoding: base64
        Content-Disposition: attachment; filename="z_share_1010-1001.zip"

        UEsDBBQACAgIACJQSlkAAAAAAAAAAAAAAAAQAAAAbF9pbnRlcmZhY2UxLnR4dO19eXcbx5Xv//oU
        AOkAAADK7QEAAAA=
        ------=_Part_200_144267934.1728525678098--
        """
        
        let mainPart = EmlParsePart.parse(mime: eml)
        XCTAssertTrue(mainPart.isMixedPart)
        XCTAssertEqual(mainPart.partID, "----=_Part_200_144267934.1728525678098")
        
        var subParts = mainPart.parts
        XCTAssertTrue(subParts.count == 2)
        
        let alternativePart = subParts[0]
        XCTAssertTrue(alternativePart.isAlternativePart)
        
        let filePart = subParts[1]
        XCTAssertTrue(filePart.isAttachmentPart)
        XCTAssertEqual(filePart.fileName, "z_share_1010-1001.zip")
        
        subParts = alternativePart.parts
        XCTAssertTrue(subParts.count == 2)
        XCTAssertTrue(subParts[0].isPlainPart)
        XCTAssertTrue(subParts[1].isHtmlPart)
    }
    
    func testBreakRN() {
        let eml = "Date: Tue, 13 Aug 2024 15:58:53 +0800\r\nFrom: aaa@6010.com\r\nTo: ccc@6010.com\r\nMessage-ID: <60fe8403-95e7-4df2-bbe0-b7778ff2d74e@localhost>\r\nSubject: 135\r\nMIME-Version: 1.0\r\nContent-Type: multipart/alternative; boundary=\"66bb123d_592c583c_237\"\r\n\r\n--66bb123d_592c583c_237\r\nContent-Type: text/plain; charset=\"utf-8\"\r\nContent-Transfer-Encoding: quoted-printable\r\nContent-Disposition: inline\r\n\r\nHuffing\r\n\r\n=E5=8F=91=E8=87=AACoremail\r\n\r\n--66bb123d_592c583c_237\r\nContent-Type: text/html; charset=\"utf-8\"\r\nContent-Transfer-Encoding: quoted-printable\r\nContent-Disposition: inline\r\n\r\nHuffing<br><br><br><br>=E5=8F=91=E8=87=AACoremail<br>\r\n--66bb123d_592c583c_237--"
        let mainPart = EmlParsePart.parse(mime: eml)
        XCTAssertTrue(mainPart.isAlternativePart)
        let subParts = mainPart.parts
        XCTAssertTrue(subParts.count == 2)
        let txtPart = subParts[0]
        XCTAssertTrue(txtPart.isPlainPart)
        XCTAssertTrue(txtPart.isQPEncoding)
        XCTAssertEqual(txtPart.decodeBody, "Huffing\r\n\r\n发自Coremail")
        let htmlPart = subParts[1]
        XCTAssertTrue(htmlPart.isHtmlPart)
        XCTAssertTrue(htmlPart.isQPEncoding)
        XCTAssertEqual(htmlPart.decodeBody, "Huffing<br><br><br><br>发自Coremail<br>")
        XCTAssertEqual(mainPart.html, "Huffing<br><br><br><br>发自Coremail<br>")
    }
    
    func testInlineImgEml() {
        let eml = """
        Received: from hyzheng$coremail.cn ( [120.196.124.154] ) by
         ajax-webmail-mailtech (Coremail) ; Tue, 27 Aug 2024 16:58:58 +0800 (CST)
        X-Originating-IP: [120.196.124.154]
        Date: Tue, 27 Aug 2024 16:58:58 +0800 (CST)
        X-CM-HeaderCharset: UTF-8
        From: =?UTF-8?B?6YOR5rSq55uK?= <hyzheng@coremail.cn>
        To: =?UTF-8?B?6YOR5rSq55uK?= <hyzheng@coremail.cn>
        Subject: =?UTF-8?B?5YaF6IGU5Zu+54mH5L+h?=
        X-Priority: 3
        X-Mailer: Coremail Webmail Server Version 2024.1-cmXT6 build
         20240625(a75f206e) Copyright (c) 2002-2024 www.mailtech.cn
         mispb-4edfefde-e422-4ddc-8a36-c3f99eb8cd32-icoremail.net
        Content-Type: multipart/related;
            boundary="----=_Part_1167_309087681.1724749138198"
        MIME-Version: 1.0
        Message-ID: <16139537.83.191930f4916.Coremail.hyzheng@coremail.cn>
        X-Coremail-Locale: zh_CN

        ------=_Part_1167_309087681.1724749138198
        Content-Type: multipart/alternative;
            boundary="----=_Part_1168_1304900595.1724749138198"

        ------=_Part_1168_1304900595.1724749138198
        Content-Type: text/plain; charset=UTF-8
        Content-Transfer-Encoding: base64

        5YaF6IGU5Zu+54mH
        ------=_Part_1168_1304900595.1724749138198
        Content-Type: text/html; charset=UTF-8
        Content-Transfer-Encoding: base64

        PHN0eWxlIGNsYXNzPSJrZS1zdHlsZSI+CltsaXN0LXN0eWxlLXR5cGVdIHtwYWRkaW5nLWxlZnQ6
        MjBweDtsaXN0LXN0eWxlLXBvc2l0aW9uOmluc2lkZX0KW2xpc3Qtc3R5bGUtdHlwZV0gbGkge21h
        cmdpbjowfQpbbGlzdC1zdHlsZS10eXBlXSBsaTpiZWZvcmUsIHNwYW4ua2UtbGlzdC1pdGVtLW1h
        dHRlciB7Zm9udC1mYW1pbHk6InNhbnMgc2VyaWYiLHRhaG9tYSx2ZXJkYW5hLGhlbHZldGljYX0K
        W2xpc3Qtc3R5bGUtdHlwZV0gbGkgcCxbbGlzdC1zdHlsZS10eXBlXSBsaSBoMSxbbGlzdC1zdHls
        ZS10eXBlXSBsaSBoMixbbGlzdC1zdHlsZS10eXBlXSBsaSBoMyxbbGlzdC1zdHlsZS10eXBlXSBs
        aSBoNCxbbGlzdC1zdHlsZS10eXBlXSBsaSBoNSxbbGlzdC1zdHlsZS10eXBlXSBsaSBkaXYsW2xp
        c3Qtc3R5bGUtdHlwZV0gbGkgYmxvY2txdW90ZXtkaXNwbGF5OmlubGluZTt3b3JkLWJyZWFrOmJy
        ZWFrLWFsbH0KW2xpc3Qtc3R5bGUtdHlwZV0gbGkgdGFibGUge2Rpc3BsYXk6aW5saW5lLWJsb2Nr
        O3ZlcnRpY2FsLWFsaWduOnRvcH0KcHttYXJnaW46MH0KdGQge3dvcmQtYnJlYWs6IGJyZWFrLXdv
        cmR9Ci5kZWZhdWx0LWZvbnQtMTcyNDc0OTExMDEzOHsKZm9udC1zaXplOjE0cHg7Cn0KPC9zdHls
        ZT48ZGl2IGNsYXNzPSJkZWZhdWx0LWZvbnQtMTcyNDc0OTExMDEzOCIgZGlyPSJsdHIiPjxpbWcg
        c3JjPSJjaWQ6MzVkZjIyNzEkMiQxOTE5MzBmNDkxNSRDb3JlbWFpbCRoeXpoZW5nJGNvcmVtYWls
        LmNuIiBhbHQ9IiI+5YaF6IGU5Zu+54mHPC9kaXY+
        ------=_Part_1168_1304900595.1724749138198--

        ------=_Part_1167_309087681.1724749138198
        Content-Type: image/png;
            name="u=838505001,1009740821&fm=3028&app=3028&f=PNG&fmt=auto&q=100&size=f254_80.png"
        Content-Transfer-Encoding: base64
        Content-Disposition: inline;
         filename="u=838505001,1009740821&fm=3028&app=3028&f=PNG&fmt=auto&q=100&size=f254_80.png"
        Content-ID: <35df2271$2$191930f4915$Coremail$hyzheng$coremail.cn>

        UklGRqQVAABXRUJQVlA4WAoAAAAQAAAA/QAATwAAQUxQSE4HAAAB8Ibt/yKn/f89B3cmuCWZ4K6H
        k2VeW9f3IwDvikmtag+Roo4AAA==
        ------=_Part_1167_309087681.1724749138198--
        """
        let mainPart = EmlParsePart.parse(mime: eml)
        XCTAssertTrue(mainPart.isRelatedPart)
        var subParts = mainPart.parts
        XCTAssertTrue(subParts.count == 2)
        let alterPart = subParts[0]
        let inImgPart = subParts[1]
        XCTAssertTrue(alterPart.isAlternativePart)
        XCTAssertTrue(inImgPart.isInlinePart)
        subParts = alterPart.parts
        XCTAssertTrue(subParts.count == 2)
        let txtPart = subParts[0]
        let htmlPart = subParts[1]
        XCTAssertEqual(txtPart.decodeBody, "内联图片")
        let contentID = inImgPart.contentID
        XCTAssertEqual(contentID, "35df2271$2$191930f4915$Coremail$hyzheng$coremail.cn")
        if let cid = contentID {
            XCTAssertTrue(htmlPart.decodeBody?.contains(cid) == true)
            XCTAssertTrue(htmlPart.decodeBody?.contains("src=\"cid:\(cid)\"") == true)
        }
    }
    
    func testTwoFilesEml() {
        let eml = """
        Received: from a$smime.cn ( [192.168.202.137] ) by ajax-webmail-tpl-centos7
         (Coremail) ; Thu, 17 Oct 2024 09:49:37 +0800 (GMT+08:00)
        X-Originating-IP: [192.168.202.137]
        Date: Thu, 17 Oct 2024 09:49:37 +0800 (GMT+08:00)
        X-CM-HeaderCharset: UTF-8
        From: 11 <a@smime.cn>
        To: 11 <a@smime.cn>
        Subject: im
        X-Priority: 3
        X-Mailer: Coremail Webmail Server Version 2024.1-cmXT6 build
         20240522(f9ac29d3) Copyright (c) 2002-2024 www.mailtech.cn
         mispb-8dfce572-2f24-404d-b59d-0dd2e304114c-icoremail.cn
        Content-Type: multipart/mixed;
            boundary="----=_Part_20_420733209.1729129777075"
        MIME-Version: 1.0
        Message-ID: <2b4cf564.8.192982a87b4.Coremail.a@smime.cn>
        X-Coremail-Locale: zh_CN

        ------=_Part_20_420733209.1729129777075
        Content-Type: multipart/alternative;
            boundary="----=_Part_22_1874385000.1729129777075"

        ------=_Part_22_1874385000.1729129777075
        Content-Type: text/plain; charset=UTF-8
        Content-Transfer-Encoding: base64


        ------=_Part_22_1874385000.1729129777075
        Content-Type: text/html; charset=UTF-8
        Content-Transfer-Encoding: base64

        PHN0eWxlIGNsYXNzPSJrZS1zdHlsZSI+CltsaXN0LXN0eWxlLXR5cGVdIHtwYWRkaW5nLWxlZnQ6
        MjBweDtsaXN0LXN0eWxlLXBvc2l0aW9uOmluc2lkZX0KW2xpc3Qtc3R5bGUtdHlwZV0gbGkge21h
        cmdpbjowfQpbbGlzdC1zdHlsZS10eXBlXSBsaTpiZWZvcmUsIHNwYW4ua2UtbGlzdC1pdGVtLW1h
        dHRlciB7Zm9udC1mYW1pbHk6InNhbnMgc2VyaWYiLHRhaG9tYSx2ZXJkYW5hLGhlbHZldGljYX0K
        W2xpc3Qtc3R5bGUtdHlwZV0gbGkgcCxbbGlzdC1zdHlsZS10eXBlXSBsaSBoMSxbbGlzdC1zdHls
        ZS10eXBlXSBsaSBoMixbbGlzdC1zdHlsZS10eXBlXSBsaSBoMyxbbGlzdC1zdHlsZS10eXBlXSBs
        aSBoNCxbbGlzdC1zdHlsZS10eXBlXSBsaSBoNSxbbGlzdC1zdHlsZS10eXBlXSBsaSBkaXYsW2xp
        c3Qtc3R5bGUtdHlwZV0gbGkgYmxvY2txdW90ZXtkaXNwbGF5OmlubGluZTt3b3JkLWJyZWFrOmJy
        ZWFrLWFsbH0KW2xpc3Qtc3R5bGUtdHlwZV0gbGkgdGFibGUge2Rpc3BsYXk6aW5saW5lLWJsb2Nr
        O3ZlcnRpY2FsLWFsaWduOnRvcH0KcHttYXJnaW46MH0KdGQge3dvcmQtYnJlYWs6IGJyZWFrLXdv
        cmR9Ci5kZWZhdWx0LWZvbnQtMTcyOTEyOTc1NTczNnsKZm9udC1zaXplOjE0cHg7Cn0KPC9zdHls
        ZT48ZGl2IGNsYXNzPSJkZWZhdWx0LWZvbnQtMTcyOTEyOTc1NTczNiIgZGlyPSJsdHIiPjwvZGl2
        Pg==
        ------=_Part_22_1874385000.1729129777075--

        ------=_Part_20_420733209.1729129777075
        Content-Type: image/jpeg; name=im.jpeg
        Content-Transfer-Encoding: base64
        Content-Disposition: attachment; filename="im.jpeg"

        UklGRhoEAABXRUJQVlA4IA4EAAAQMwCdASqQAZABPm02m0mkIyKhIJcYEIANiWlu4XaxG9vO/Aco
        HJqLifbNnv3kNmA5IGLRxszH40CnDJUgAAAAAAAAAAA=
        ------=_Part_20_420733209.1729129777075
        Content-Type: image/png; name=baidu.png
        Content-Transfer-Encoding: base64
        Content-Disposition: attachment; filename="baidu.png"

        UklGRqQVAABXRUJQVlA4WAoAAAAQAAAA/QAATwAAQUxQSE4HAAAB8Ibt/yKn/f89B3cmuCWZ4K6H
        k2VeW9f3IwDvikmtag+Roo4AAA==
        ------=_Part_20_420733209.1729129777075--
        """
        let mainPart = EmlParsePart.parse(mime: eml)
        XCTAssertTrue(mainPart.isMixedPart)
        let fileParts = mainPart.fileParts
        XCTAssertTrue(fileParts.count == 2)
        let file1 = fileParts[0]
        XCTAssertEqual(file1.fileName, "im.jpeg")
        let file2 = fileParts[1]
        XCTAssertEqual(file2.fileName, "baidu.png")
    }

    func testAlternativeWarpRelated() {
        let eml = """
        Content-Type: multipart/mixed; boundary="66d52306_d65847_2e8"

        --66d52306_d65847_2e8
        Content-Type: multipart/alternative; boundary="66d52306_116d903e_2e8"
        --66d52306_116d903e_2e8
        Content-Type: text/plain; charset="utf-8"
        Content-Transfer-Encoding: quoted-printable
        Content-Disposition: inline

        =E5=8F=91=E8=87=AACoremail
        > ----- Original Message -----
        > =46rom: =E7=94=A8=E6=88=B7A <aaa=406010.com>
        > To: =E7=94=A8=E6=88=B7A <aaa=406010.com>
        > Sent: Tue, 27 Aug 2024 16:55:07 +0800 (GMT+08:00)
        > Subject: =E5=86=85=E8=81=94=E5=9B=BE=E7=89=87=E4=BF=A1
        >
        >
        > =E5=86=85=E5=AE=B9=E5=86=85=E5=AE=B9
        >
        >
        >
        >
        >
        --66d52306_116d903e_2e8
        Content-Type: multipart/related; boundary="66d52306_7280beef_2e8"
        --66d52306_7280beef_2e8
        Content-Type: text/html; charset="utf-8"
        Content-Transfer-Encoding: quoted-printable
        Content-Disposition: inline

        <br><br><br>=E5=8F=91=E8=87=AACoremail<br><hr><blockquote class=3D=22cm=5F=
        quote=5Fmsg=22>----- Original Message -----<br><b>=46rom</b>: =E7=94=A8=E6=
        =88=B7A &lt;aaa=406010.com&gt;<br><b>To</b>: =E7=94=A8=E6=88=B7A &lt;aaa=40=
        6010.com&gt;<br><b>Sent</b>: Tue, 27 Aug 2024 16:55:07 +0800 (GMT+08:00)<=
        br><b>Subject</b>: =E5=86=85=E8=81=94=E5=9B=BE=E7=89=87=E4=BF=A1<br><br><=
        style class=3D=22ke-style=22>=5Blist-style-type=5D =7Bpadding-left:20px;l=
        ist-style-position:inside=7D=5Blist-style-type=5D li =7Bmargin:0=7D=5Blis=
        t-style-type=5D li:before, span.ke-list-item-matter =7Bfont-family:=22san=
        s serif=22,tahoma,verdana,helvetica=7D=5Blist-style-type=5D li p,=5Blist-=
        style-type=5D li h1,=5Blist-style-type=5D li h2,=5Blist-style-type=5D li =
        h3,=5Blist-style-type=5D li h4,=5Blist-style-type=5D li h5,=5Blist-style-=
        type=5D li div,=5Blist-style-type=5D li blockquote=7Bdisplay:inline;word-=
        break:break-all=7D=5Blist-style-type=5D li table =7Bdisplay:inline-block;=
        vertical-align:top=7Dp=7Bmargin:0=7Dtd =7Bword-break: break-word=7D.defau=
        lt-font-1724748787972=7Bfont-size:14px;=7D</style><div class=3D=22default=
        -font-1724748787972=22 dir=3D=22ltr=22><p>=E5=86=85=E5=AE=B9=E5=86=85=E5=AE=
        =B9</p><p><img src=3D=22cid:3CE9B295-7D=46C-40=460-BA16-963CCE1C9C3C=22 a=
        lt=3D=22=22></p></div></blockquote>
        --66d52306_7280beef_2e8

        Content-Type: image/png
        Content-Transfer-Encoding: base64
        Content-ID: <3CE9B295-7DFC-40F0-BA16-963CCE1C9C3C>
        Content-Disposition: attachment;
         filename="=?utf-8?Q?u=5F838505001=2C1009740821&fm=5F3028&app=5F3028&f=5FPNG&fmt=5Fauto&q=5F100&size=5Ff254=5F80.png?="

        UklGRqQVAABXRUJQVlA4WAoAAAAQAAAA/QAATwAAQUxQSE4HAAAB8Ibt/yKn/f89B3cmuCWZ4K6H
        k2VeW9f3IwDvikmtag+Roo4AAA==
        --66d52306_7280beef_2e8--

        --66d52306_116d903e_2e8--

        --66d52306_d65847_2e8

        Content-Type: image/png
        Content-Transfer-Encoding: base64
        Content-Disposition: attachment;
         filename="=?utf-8?Q?u=5F838505001=2C1009740821&fm=5F3028&app=5F3028&f=5FPNG&fmt=5Fauto&q=5F100&size=5Ff254=5F80.png?="

        UklGRqQVAABXRUJQVlA4WAoAAAAQAAAA/QAATwAAQUxQSE4HAAAB8Ibt/yKn/f89B3cmuCWZ4K6H
        k2VeW9f3IwDvikmtag+Roo4AAA==

        --66d52306_d65847_2e8--
        """
        let mainPart = EmlParsePart.parse(mime: eml)
        XCTAssertTrue(mainPart.isMixedPart)
        let subParts = mainPart.parts
        XCTAssertTrue(subParts.count == 2)
        let filePart = subParts[1]
        XCTAssertTrue(filePart.isAttachmentPart)
        let alterPart = subParts[0]
        XCTAssertTrue(alterPart.isAlternativePart)
        let inlineFileParts = mainPart.inlineFileParts
        XCTAssertTrue(inlineFileParts.count == 1)
        XCTAssertEqual(inlineFileParts[0].fileName, "u_838505001,1009740821&fm_3028&app_3028&f_PNG&fmt_auto&q_100&size_f254_80.png")
        XCTAssertEqual(inlineFileParts[0].contentID, "3CE9B295-7DFC-40F0-BA16-963CCE1C9C3C")
    }
    
    func testGetHtml() {
        var eml = "Content-Type: multipart/alternative; \r\n\tboundary=\"042DFBD7FF7E4014BAB37444FE6647D7\"\r\n\r\n--042DFBD7FF7E4014BAB37444FE6647D7\r\nContent-Type: text/html; charset=UTF-8\r\n\r\nD\r\n            \r\n        \r\n--042DFBD7FF7E4014BAB37444FE6647D7--"
        var mainPart = EmlParsePart.parse(mime: eml)
        XCTAssertEqual(mainPart.html, "D")
    }
    
    // 无引号Boundary
    func testNoQuotationBoundary() {
        let eml = """
        Content-Type: multipart/signed;
            boundary=Apple-Mail-014ABC5D-FA8A-4CC9-9D37-A76C3808BE14;
            protocol="application/pkcs7-signature";
            micalg=sha-256
        Content-Transfer-Encoding: 7bit

        --Apple-Mail-014ABC5D-FA8A-4CC9-9D37-A76C3808BE14
        Content-Type: text/plain;
            charset=utf-8
        Content-Transfer-Encoding: base64

        cHVzaG1haWzlj5Hkv6HvvIznrb7lkI3inpXliqDlr4Y=

        --Apple-Mail-014ABC5D-FA8A-4CC9-9D37-A76C3808BE14
        Content-Type: application/pkcs7-signature;
            name=smime.p7s
        Content-Disposition: attachment;
            filename=smime.p7s
        Content-Transfer-Encoding: base64
        MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCB5Aw
        ZzPUUNXj9x6GXHw6JTj1ZSxLNIhdBiSEmBVPmiwTO5BpbX6KbcDDFFIAAAAAAAA=
        --Apple-Mail-014ABC5D-FA8A-4CC9-9D37-A76C3808BE14--
        """
        let mainPart = EmlParsePart.parse(mime: eml)
        XCTAssertEqual(mainPart.partID, "Apple-Mail-014ABC5D-FA8A-4CC9-9D37-A76C3808BE14")
        let subParts = mainPart.parts
        XCTAssertTrue(subParts.count == 2)
    }
    
    func testSmimeType() {
        var eml = """
        Content-Type: application/pkcs7-mime; smime-type=enveloped-data;
            name="smime.p7m"
        Content-Disposition: attachment; filename="smime.p7m"
        Content-Transfer-Encoding: base64
        MIME-Version: 1.0
        
        MIAGCSqGSIb3DQEHA6CAMIACAQAxggYwMIIBiAIBADBwMFkxEzARBgoJkiaJk/IsZAEZFgNjb20x
        tTgLII9mO4Q7CW9dBbSvpxcdm9FVWowM+4LD76QPD9wsjXzLAAAAAAAAAAAAAA==
        """
        var mainPart = EmlParsePart.parse(mime: eml)
        XCTAssertEqual(mainPart.smimeType, "enveloped-data")
        XCTAssertEqual(mainPart.contentType, "application/pkcs7-mime")
        
        eml = """
        Content-Type: application/pkcs7-mime; smime-type="sign-data";
            name="smime.p7m"
        Content-Disposition: attachment; filename="smime.p7m"
        Content-Transfer-Encoding: base64
        MIME-Version: 1.0
        
        MIAGCSqGSIb3DQEHA6CAMIACAQAxggYwMIIBiAIBADBwMFkxEzARBgoJkiaJk/IsZAEZFgNjb20x
        tTgLII9mO4Q7CW9dBbSvpxcdm9FVWowM+4LD76QPD9wsjXzLAAAAAAAAAAAAAA==
        """
        mainPart = EmlParsePart.parse(mime: eml)
        XCTAssertEqual(mainPart.smimeType, "sign-data")
        XCTAssertEqual(mainPart.contentType, "application/pkcs7-mime")
    }
    
    func testGetHtmlFromOnlyPlainText() {
        let eml = "Content-Type: text/plain;\r\n\tcharset=utf-8\r\nContent-Transfer-Encoding: base64\r\n\r\ncHVzaG1haWzlj5Hkv6HvvIznrb7lkI3inpXliqDlr4Y=\r\n"
        let mainPart = EmlParsePart.parse(mime: eml)
        XCTAssertEqual(mainPart.renderBody, "pushmail发信，签名➕加密")
    }
    
    func testGB2312() {
        let eml = "Content-Type: multipart/alternative;\r\n\tboundary=\"----=_NextPart_001_0015_01DB6829.EA29FE10\"\r\n\r\n\r\n------=_NextPart_001_0015_01DB6829.EA29FE10\r\nContent-Type: text/plain;\r\n\tcharset=\"gb2312\"\r\nContent-Transfer-Encoding: quoted-printable\r\n\r\noutlook=B7=A2=D0=C5=A3=AC=D6=BB=C7=A9=C3=FB\r\n\r\n\r\n------=_NextPart_001_0015_01DB6829.EA29FE10\r\nContent-Type: text/html;\r\n\tcharset=\"gb2312\"\r\nContent-Transfer-Encoding: quoted-printable\r\n\r\n<html xmlns:v=3D\"urn:schemas-microsoft-com:vml\" =\r\nxmlns:o=3D\"urn:schemas-microsoft-com:office:office\" =\r\nxmlns:w=3D\"urn:schemas-microsoft-com:office:word\" =\r\nxmlns:m=3D\"http://schemas.microsoft.com/office/2004/12/omml\" =\r\nxmlns=3D\"http://www.w3.org/TR/REC-html40\"><head><meta =\r\nhttp-equiv=3DContent-Type content=3D\"text/html; charset=3Dgb2312\"><meta =\r\nname=3DGenerator content=3D\"Microsoft Word 15 (filtered =\r\nmedium)\"><style><!--\r\n/* Font Definitions */\r\n@font-face\r\n\t{font-family:\"Cambria Math\";\r\n\tpanose-1:2 4 5 3 5 4 6 3 2 4;}\r\n@font-face\r\n\t{font-family:=B5=C8=CF=DF;\r\n\tpanose-1:2 1 6 0 3 1 1 1 1 1;}\r\n@font-face\r\n\t{font-family:\"\\@=B5=C8=CF=DF\";\r\n\tpanose-1:2 1 6 0 3 1 1 1 1 1;}\r\n/* Style Definitions */\r\np.MsoNormal, li.MsoNormal, div.MsoNormal\r\n\t{margin:0cm;\r\n\tmargin-bottom:.0001pt;\r\n\ttext-align:justify;\r\n\ttext-justify:inter-ideograph;\r\n\tfont-size:10.5pt;\r\n\tfont-family:=B5=C8=CF=DF;}\r\na:link, span.MsoHyperlink\r\n\t{mso-style-priority:99;\r\n\tcolor:#0563C1;\r\n\ttext-decoration:underline;}\r\na:visited, span.MsoHyperlinkFollowed\r\n\t{mso-style-priority:99;\r\n\tcolor:#954F72;\r\n\ttext-decoration:underline;}\r\nspan.EmailStyle17\r\n\t{mso-style-type:personal-compose;\r\n\tfont-family:=B5=C8=CF=DF;\r\n\tcolor:windowtext;}\r\n.MsoChpDefault\r\n\t{mso-style-type:export-only;\r\n\tfont-family:=B5=C8=CF=DF;}\r\n/* Page Definitions */\r\n@page WordSection1\r\n\t{size:612.0pt 792.0pt;\r\n\tmargin:72.0pt 90.0pt 72.0pt 90.0pt;}\r\ndiv.WordSection1\r\n\t{page:WordSection1;}\r\n--></style><!--[if gte mso 9]><xml>\r\n<o:shapedefaults v:ext=3D\"edit\" spidmax=3D\"1026\" />\r\n</xml><![endif]--><!--[if gte mso 9]><xml>\r\n<o:shapelayout v:ext=3D\"edit\">\r\n<o:idmap v:ext=3D\"edit\" data=3D\"1\" />\r\n</o:shapelayout></xml><![endif]--></head><body lang=3DZH-CN =\r\nlink=3D\"#0563C1\" vlink=3D\"#954F72\" =\r\nstyle=3D\'text-justify-trim:punctuation\'><div class=3DWordSection1><p =\r\nclass=3DMsoNormal><span lang=3DEN-US =\r\nstyle=3D\'font-size:42.0pt\'>outlook</span><span =\r\nstyle=3D\'font-size:42.0pt\'>=B7=A2=D0=C5=A3=AC=D6=BB=C7=A9=C3=FB<span =\r\nlang=3DEN-US><o:p></o:p></span></span></p></div></body></html>\r\n------=_NextPart_001_0015_01DB6829.EA29FE10--\r\n"
        let mainPart = EmlParsePart.parse(mime: eml)
        let subParts = mainPart.parts
        XCTAssertTrue(subParts.count == 2)
        let plainPart = subParts[0]
        XCTAssertTrue(plainPart.isPlainPart)
        XCTAssertEqual(plainPart.decodeBody, "outlook发信，只签名")
        let htmlPart = subParts[1]
        XCTAssertEqual(htmlPart.html, "<html xmlns:v=\"urn:schemas-microsoft-com:vml\" xmlns:o=\"urn:schemas-microsoft-com:office:office\" xmlns:w=\"urn:schemas-microsoft-com:office:word\" xmlns:m=\"http://schemas.microsoft.com/office/2004/12/omml\" xmlns=\"http://www.w3.org/TR/REC-html40\"><head><meta http-equiv=Content-Type content=\"text/html; charset=utf8\"><meta name=Generator content=\"Microsoft Word 15 (filtered medium)\"><style><!--/* Font Definitions */@font-face\t{font-family:\"Cambria Math\";\tpanose-1:2 4 5 3 5 4 6 3 2 4;}@font-face\t{font-family:等线;\tpanose-1:2 1 6 0 3 1 1 1 1 1;}@font-face\t{font-family:\"\\@等线\";\tpanose-1:2 1 6 0 3 1 1 1 1 1;}/* Style Definitions */p.MsoNormal, li.MsoNormal, div.MsoNormal\t{margin:0cm;\tmargin-bottom:.0001pt;\ttext-align:justify;\ttext-justify:inter-ideograph;\tfont-size:10.5pt;\tfont-family:等线;}a:link, span.MsoHyperlink\t{mso-style-priority:99;\tcolor:#0563C1;\ttext-decoration:underline;}a:visited, span.MsoHyperlinkFollowed\t{mso-style-priority:99;\tcolor:#954F72;\ttext-decoration:underline;}span.EmailStyle17\t{mso-style-type:personal-compose;\tfont-family:等线;\tcolor:windowtext;}.MsoChpDefault\t{mso-style-type:export-only;\tfont-family:等线;}/* Page Definitions */@page WordSection1\t{size:612.0pt 792.0pt;\tmargin:72.0pt 90.0pt 72.0pt 90.0pt;}div.WordSection1\t{page:WordSection1;}--></style><!--[if gte mso 9]><xml><o:shapedefaults v:ext=\"edit\" spidmax=\"1026\" /></xml><![endif]--><!--[if gte mso 9]><xml><o:shapelayout v:ext=\"edit\"><o:idmap v:ext=\"edit\" data=\"1\" /></o:shapelayout></xml><![endif]--></head><body lang=ZH-CN link=\"#0563C1\" vlink=\"#954F72\" style=\'text-justify-trim:punctuation\'><div class=WordSection1><p class=MsoNormal><span lang=EN-US style=\'font-size:42.0pt\'>outlook</span><span style=\'font-size:42.0pt\'>发信，只签名<span lang=3DEN-US><o:p></o:p></span></span></p></div></body></html>")
    }
}
