//
//  EmlBuildPartTests.swift
//  EmlKitTests
//
//  Created by zhenghongyi on 2024/11/21.
//

import XCTest

final class EmlBuildPartTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFilePart() {
        let part = EmlBuildPart()
        part.contentType = "application/rtf"
        part.fileName = "Xcode15解决思路.rtf"
        part.body = """
        e1xydGYxXGFuc2lcYW5zaWNwZzkzNlxjb2NvYXJ0ZjI3NTcKXGNvY29hdGV4dHNjYWxpbmcwXGNv
        Y29hcGxhdGZvcm0we1xmb250dGJsXGYwXGZzd2lzc1xmY2hhcnNldDAgSGVsdmV0aWNhO1xmMVxm
        """
        XCTAssertEqual(part.build(), "Content-Type: application/rtf; \n\tname=\"=?UTF-8?Q?Xcode15=E8=A7=A3=E5=86=B3=E6=80=9D=E8=B7=AF.rtf?=\"\nContent-Transfer-Encoding: base64\nContent-Disposition: attachment; \n\tfilename=\"=?UTF-8?Q?Xcode15=E8=A7=A3=E5=86=B3=E6=80=9D=E8=B7=AF.rtf?=\"\n\ne1xydGYxXGFuc2lcYW5zaWNwZzkzNlxjb2NvYXJ0ZjI3NTcKXGNvY29hdGV4dHNjYWxpbmcwXGNv\nY29hcGxhdGZvcm0we1xmb250dGJsXGYwXGZzd2lzc1xmY2hhcnNldDAgSGVsdmV0aWNhO1xmMVxm")
    }

    func testInlineImgPart() {
        let part = EmlBuildPart()
        part.contentType = "image/png"
        part.fileName = "baidulogo.png"
        part.contentID = "70203924$1$191930bc413$Coremail$aaa$6010.com>"
        part.body = """
        UklGRqQVAABXRUJQVlA4WAoAAAAQAAAA/QAATwAAQUxQSE4HAAAB8Ibt/yKn/f89B3cmuCWZ4K6H
        B3d3t2xwr3v6zlJ3d1vq7i1ODHfXyNDYgTULfeOB1/PGvPy12b0bERMAJW9VpwZIredUgMi38r0H
        """
        XCTAssertEqual(part.build(), "Content-Type: image/png; \n\tname=\"baidulogo.png\"\nContent-Transfer-Encoding: base64\nContent-Disposition: inline; \n\tfilename=\"baidulogo.png\"\nContent-ID: <70203924$1$191930bc413$Coremail$aaa$6010.com>>\n\nUklGRqQVAABXRUJQVlA4WAoAAAAQAAAA/QAATwAAQUxQSE4HAAAB8Ibt/yKn/f89B3cmuCWZ4K6H\nB3d3t2xwr3v6zlJ3d1vq7i1ODHfXyNDYgTULfeOB1/PGvPy12b0bERMAJW9VpwZIredUgMi38r0H")
    }
    
    func testLongContentPart() {
        let part = EmlBuildPart()
        part.contentType = "image/png"
        part.fileName = "baidulogo.png"
        part.contentID = "70203924$1$191930bc413$Coremail$aaa$6010.com>"
        part.body = """
        /9j/4AAQSkZJRgABAQAASABIAAD/4QCMRXhpZgAATU0AKgAAAAgABQESAAMAAAABAAEAAAEaAAUAAAABAAAASgEbAAUAAAABAAAAUgEoAAMAAAABAAIAAIdpAAQAAAABAAAAWgAAAAAAAABIAAAAAQAAAEgAAAABAAOgAQADAAAAAQABAACgAgAEAAAAAQAAAZCgAwAEAAAAAQAAAZAAAAAA/+0AOFBob3Rvc2hvcCAzLjAAOEJJTQQEAAAAAAAAOEJJTQQlAAAAAAAQ1B2M2Y8AsgTpgAmY7PhCfv/AABEIAZABkAMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJC
        """
        XCTAssertEqual(part.build(), "Content-Type: image/png; \n\tname=\"baidulogo.png\";\nContent-Transfer-Encoding: base64\nContent-Disposition: inline; \n\tfilename=\"baidulogo.png\"\nContent-ID: <70203924$1$191930bc413$Coremail$aaa$6010.com>>\n\n/9j/4AAQSkZJRgABAQAASABIAAD/4QCMRXhpZgAATU0AKgAAAAgABQESAAMAAAAB\nAAEAAAEaAAUAAAABAAAASgEbAAUAAAABAAAAUgEoAAMAAAABAAIAAIdpAAQAAAAB\nAAAAWgAAAAAAAABIAAAAAQAAAEgAAAABAAOgAQADAAAAAQABAACgAgAEAAAAAQAA\nAZCgAwAEAAAAAQAAAZAAAAAA/+0AOFBob3Rvc2hvcCAzLjAAOEJJTQQEAAAAAAAA\nOEJJTQQlAAAAAAAQ1B2M2Y8AsgTpgAmY7PhCfv/AABEIAZABkAMBIgACEQEDEQH/\nxAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJC")
    }
}
