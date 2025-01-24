//
//  String_SubString.swift
//  EmlKit
//
//  Created by zhenghongyi on 2024/10/10.
//

import Foundation

public enum MIMEDecodeType {
    case base64
    case quotedPrintable
    
    var shortStr: String {
        switch self {
        case .base64:
            return "B"
        case .quotedPrintable:
            return "Q"
        }
    }
}

public enum BreakKeyType: String {
    case n = "\n"
    case r = "\r"
    case rn = "\r\n"
}

// 在MIME协议中，每一行的长度不能超过76个字符，这个限制包括了CRLF（Carriage Return Line Feed）即回车换行的两个字符，即最多只能用75个可打印字符
let MIMELineMaxCount: Int = 76

extension String.Encoding {
    static let gb_18030_2000 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue)))
    
    static func getEncoding(charset: String = "uft8") -> String.Encoding {
        if charset.lowercased() == "gb2312" {
            return .gb_18030_2000
        }
        return .utf8
    }
}

extension String {
    // Swift的String.count和OC的NSString.length获取出来有差别的
    var length: Int {
        return (self as NSString).length
    }
    
    func nssubString(range: NSRange) -> String? {
        if range.location == NSNotFound || range.location < 0 ||
            range.location + range.length > length || range.length < 0 {
            return nil
        }
        return (self as NSString).substring(with: range)
    }
    
    func nsrange(of str: String, options: NSString.CompareOptions = []) -> NSRange {
        return (self as NSString).range(of: str, options: options)
    }
    
    func nsreplaceSubrange(_ range: NSRange, with str: String) -> String {
        return (self as NSString).replacingCharacters(in: range, with: str)
    }
    
    // MIME中的编码方式，格式为"=?a?b?xxx?="，其中a代表原始内容编码，b代表当前内容编码，xxx为当前编码后的内容
    // b常见的值为QuotedPrintable和Base64，通常是以首字母来代替
    // 例如"=?UTF-8?Q?IMG=5F0017.PNG?="，原始编码是utf-8，当前编码是QuotedPrintable，IMG=5F0017.PNG为当前编码内容
    // 例如"=?gb2312?B?TUINRdCt0unLtcP308q8/g==?="，原始编码是gb2312，当前编码是Base64，TUINRdCt0unLtcP308q8/g==为当前编码内容
    var mimeDecode: String {
        guard let reg = try? NSRegularExpression(pattern: "=\\?.*?\\?.*?\\?(.*?)\\?=") else {
            return self
        }
        let matches = reg.matches(in: self, range: NSRange(location: 0, length: count))
        if matches.count > 0 {
            var text = self
            for m in matches.reversed() {
                let range = m.range
                if var item = nssubString(range: range) {
                    let lowercase = item.lowercased()
                    item = item.nsreplaceSubrange(lowercase.nsrange(of: "=?"), with: "")
                    item = item.nsreplaceSubrange(item.nsrange(of: "?=", options: .backwards), with: "")
                    var components = item.components(separatedBy: "?")
                    if components.count >= 3 {
                        let originEncodeType = components.remove(at: 0)
                        let nowEncodeType = components.remove(at: 0)
                        item = components.joined(separator: "?")
                        
                        if nowEncodeType.lowercased() == MIMEDecodeType.quotedPrintable.shortStr.lowercased() {
                            if let qpDecode = item.qpDecode(encoding: Encoding.getEncoding(charset: originEncodeType)) {
                                item = qpDecode
                            }
                        } else if nowEncodeType.lowercased() == MIMEDecodeType.base64.shortStr.lowercased() {
                            if let data = Data(base64Encoded: item), let utf8Str = String(data: data, encoding: Encoding.getEncoding(charset: originEncodeType)) {
                                item = utf8Str
                            }
                        }
                    }
                    text = text.nsreplaceSubrange(range, with: item)
                }
            }
            return text
        }
        return self
    }
    
    /**
     QuotedPrintable编码方式，将任何8位的字节值可编码为3个字符：一个等号"="后跟随两个十六进制数字(0–9或A–F)表示该字节的数值；
     解码只需反向这个过程，识别“=”后面的两位是否可转为16进制，是的话，再将“=”转为“%”，即为URL编码方式，URL编码可通过stringByRemovingPercentEncoding来解码
     */
    func qpDecode(breakKey: BreakKeyType = .n, encoding: String.Encoding = .utf8) -> String? {
        guard let reg = try? NSRegularExpression(pattern: "=") else {
            return nil
        }
        var result = self
        let matches = reg.matches(in: result, range: NSRange(location: 0, length: count))
        if matches.count > 0 {
            for item in matches.reversed() {
                let range = item.range
                if range.location + 2 < result.count,
                    let temp = result.nssubString(range: NSRange(location: range.location + 1, length: 2)),
                    UInt(temp, radix: 16) != nil {
                    result = result.nsreplaceSubrange(range, with: "%")
                }
                else if range.location + breakKey.rawValue.length < result.count,
                        let temp = result.nssubString(range: NSRange(location: range.location + 1, length: breakKey.rawValue.length)),
                        temp == breakKey.rawValue {
                    result = result.nsreplaceSubrange(NSRange(location: range.location, length: breakKey.rawValue.length + 1), with: "")
                }
            }
            result = result.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if encoding == .utf8 {
            return (result as NSString).removingPercentEncoding
        } else {
            return result.removingPercentEncoding(using: encoding)
        }
    }
    
    // 支持gb2312字符集，参考：https://www.saoniuhuo.com/question/detail-2256829.html
    func removingPercentEncoding(using encoding: String.Encoding) -> String? {
        return String(data: bytesByRemovingPercentEncoding(using: encoding), encoding: encoding)
    }
    
    func bytesByRemovingPercentEncoding(using encoding: String.Encoding) -> Data {
        struct My {
            static let regex = try! NSRegularExpression(pattern: "(%[0-9A-F]{2})|(.)", options: .caseInsensitive)
        }
        var bytes = Data()
        let nsSelf = self as NSString
        for match in My.regex.matches(in: self, range: NSRange(0..<self.utf16.count)) {
            if match.range(at: 1).location != NSNotFound {
                let hexString = nsSelf.substring(with: NSMakeRange(match.range(at: 1).location + 1, 2))
                bytes.append(UInt8(hexString, radix: 16)!)
            } else {
                let singleChar = nsSelf.substring(with: match.range(at: 2))
                bytes.append(singleChar.data(using: encoding) ?? "?".data(using: .ascii)!)
            }
        }
        return bytes
    }
    
    /**
     QuotedPrintable编码，将非ASCII编码和“=”以外的字符，转换为16进制
     */
    func qpEncode(breakKey: BreakKeyType = .n) -> String {
        let allowedCharacters = NSCharacterSet.alphanumerics
        var result: String = ""
        for i in 0..<length {
            let char = self[self.index(self.startIndex, offsetBy: i)]
            var item: String
            if char == "=" || String.isASCIICharacter(char) {
                item = String(char)
            } else {
                if let urlEncoded = String(char).addingPercentEncoding(withAllowedCharacters: allowedCharacters) {
                    item = urlEncoded.replacingOccurrences(of: "%", with: "=")
                } else {
                    item = String(char)
                }
            }
            let temp = result + item
            if temp.length % MIMELineMaxCount >= 0 && temp.length % MIMELineMaxCount <= item.length && result.length > 0 {
                result += "=\(breakKey.rawValue)\(item)"
            } else {
                result = temp
            }
        }
        return result
    }
    
    /// 进行MIME编码，暂时只支持base64编码和quotedprintable编码
    ///
    /// - Parameters:
    ///   - type: 指定编码类型，如果不指定，则自动根据字符串情况判断，默认不指定
    ///   - enableMutliLines: 是否允许多行，默认false，只允许一行
    ///   - breakKey: 换行符，默认是\n换行
    ///   - addTag: 是否添加tag，默认true
    /// - Returns: 编码后结果
    ///
    /// 不指定情况下，需要将原文进行扫描，统计非ASCII字符的数量，非ASCII字符多则采用base64编码，否则采用qp编码，如果在原文比较大的情况下，处理会比较慢
    func mimeEncode(type: MIMEDecodeType? = nil, enableMutliLines: Bool = false) -> (encoded: [String], encodeType: MIMEDecodeType?) {
        let chooseType: MIMEDecodeType
        if let type = type {
            chooseType = type
        } else {
            let asciiCount = asciiCount
            let otherCount = length - asciiCount
            if asciiCount > otherCount {
                chooseType = .quotedPrintable
            } else {
                chooseType = .base64
            }
        }
        
        var encoded: [String] = []
        if chooseType == .base64 {
            if let data = self.data(using: .utf8) {
                let base64 = data.base64EncodedString()
                if enableMutliLines {
                    var i = 0
                    while i + 64 < base64.count {
                        let temp = (base64 as NSString).substring(with: NSRange(location: i, length: 64))
                        encoded.append(temp)
                        i += 64
                    }
                    if base64.count > i {
                        let temp = (base64 as NSString).substring(with: NSRange(location: i, length: base64.count - i))
                        encoded.append(temp)
                    }
                } else {
                    encoded.append(base64)
                }
                return (encoded, .base64)
            }
        } else {
            let breakKey: BreakKeyType = BreakKeyType.n
            let qpEncoded = qpEncode(breakKey: breakKey)
            if qpEncoded.replacingOccurrences(of: "=\(breakKey.rawValue)", with: "") != self {// quotedprintable编码结果与原文没差异，则不使用编码
                if enableMutliLines {
                    encoded = qpEncoded.components(separatedBy: "=\(breakKey.rawValue)")
                } else {
                    encoded = [qpEncoded]
                }
                return (encoded, .quotedPrintable)
            }
        }
        return ([self], nil)
    }
    
    func addMIMETag(type: MIMEDecodeType?) -> String {
        if let type = type {
            switch type {
            case .base64:
                return "=?UTF-8?B?\(self)?="
            case .quotedPrintable:
                return "=?UTF-8?Q?\(self)?="
            }
        } else {
            return self
        }
    }
    
    var asciiCount: Int {
        var asciiCount = 0
        for character in self {
            if String.isASCIICharacter(character) {
                asciiCount += 1
            }
        }
        return asciiCount
    }
    
    static func isASCIICharacter(_ character: Character) -> Bool {
        let unicodeScalar = UnicodeScalar(String(character))
        return unicodeScalar != nil && unicodeScalar!.value >= 0 && unicodeScalar!.value <= 127
    }
    
    func toBase64Format(breakKey: String = BreakKeyType.n.rawValue) -> String {
        if self.contains(breakKey) {
            return self
        }
        var i = 0
        var result: [String] = []
        while i + 64 < self.count {
            let temp = (self as NSString).substring(with: NSRange(location: i, length: 64))
            result.append(temp)
            i += 64
        }
        if self.count > i {
            let temp = (self as NSString).substring(with: NSRange(location: i, length: self.count - i))
            result.append(temp)
        }
        return result.joined(separator: breakKey)
    }
}
