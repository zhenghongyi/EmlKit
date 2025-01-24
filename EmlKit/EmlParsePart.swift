//
//  EmlPart.swift
//  EmlKit
//
//  Created by zhenghongyi on 2024/10/10.
//

import UIKit

public class EmlParsePart: NSObject {
    
    public private(set) var content: String?
    
    public private(set) var contentType: String?
    public private(set) var partID: String?
    public private(set) var contentEncoding: String?
    public private(set) var contentDisposition: String?
    public private(set) var fileName: String?
    public private(set) var contentID: String?
    public private(set) var smimeType: String?
    public private(set) var charset: String?
    
    // 换行符
    public private(set) var breakKey: String?
    
    private let contentTypeKey: String = "Content-Type:"
    private let boundaryKey = "boundary="
    private let contentEncodingKey = "Content-Transfer-Encoding:"
    private let contentDispositionKey = "Content-Disposition:"
    private let fileNameKey = "filename="
    private let contentIDKey = "Content-ID:"
    private let smimeTypeKey = "smime-type="
    private let charsetKey = "charset="
    
    public static func parse(mime: String) -> EmlParsePart {
        let part = EmlParsePart()
        part.content = mime
        part.parse()
        return part
    }
    
    private func parse() {
        guard let content = content else {
            return
        }
        // unix系统下换行是\n，window系统下换行是\r\n，mac系统下换行是\r
        let rangeReturnRN = (content as NSString).range(of: BreakKeyType.rn.rawValue)
        let rangeReturnN = (content as NSString).range(of: BreakKeyType.n.rawValue)
        let rangeReturnR = (content as NSString).range(of: BreakKeyType.r.rawValue)
        if rangeReturnRN.location != NSNotFound {
            if rangeReturnN.location < rangeReturnRN.location {
                breakKey = BreakKeyType.n.rawValue
            } else if rangeReturnR.location < rangeReturnRN.location {
                breakKey = BreakKeyType.r.rawValue
            } else {
                breakKey = BreakKeyType.rn.rawValue
            }
        } else {
            let nLocation = rangeReturnN.location == NSNotFound ? Int.max : rangeReturnN.location
            let rLocation = rangeReturnR.location == NSNotFound ? Int.max : rangeReturnR.location
            if nLocation < rLocation {
                breakKey = BreakKeyType.n.rawValue
            } else if rLocation < nLocation {
                breakKey = BreakKeyType.r.rawValue
            }
        }
        guard let breakKey = breakKey else {
            return
        }
        
        let lines: [String] = content.components(separatedBy: breakKey)
        var index: Int = 0
        while index < lines.count {
            let item = lines[index]
            if item.isEmpty {// 加上上一行的换行符与这一行的，就是两个换行符，则是header结束
                break
            }
            if contentType == nil && item.hasPrefix(contentTypeKey) {
                contentType = getContentType(item: item)
                continue
            }
            else if contentType != nil && item.contains(boundaryKey) && partID == nil {
                partID = getPartId(item: item)
            }
            else if contentEncoding == nil && item.hasPrefix(contentEncodingKey) {
                let text = item.nssubString(range: NSRange(
                    location: contentEncodingKey.count,
                    length: item.count - contentEncodingKey.count
                ))
                contentEncoding = text?.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            else if contentDisposition == nil && item.hasPrefix(contentDispositionKey) {
                contentDisposition = getContentDisposition(item: item)
                continue
            }
            else if fileName == nil && item.contains(fileNameKey) && contentDisposition != nil {
                fileName = getFileName(item: item)
            }
            else if contentID == nil && item.contains(contentIDKey) {
                contentID = getContentID(item: item)
            }
            else if smimeType == nil && item.contains(smimeTypeKey) {
                smimeType = getSmimeType(item: item)
            }
            else if charset == nil && item.contains(charsetKey) {
                charset = getCharSet(item: item) ?? "utf8"
            }
            index = index + 1
        }
    }
    
    public var parts: [EmlParsePart] {
        var parts: [EmlParsePart] = []
        if let partID = partID, let content = content {
            let boundary = "--\(partID)"
            guard let reg = try? NSRegularExpression(pattern: boundary) else {
                return parts
            }
            let matches = reg.matches(in: content, range: NSRange(location: 0, length: content.length))
            for i in 0..<matches.count {
                if i == matches.count - 1 {
                    break
                }
                let start = matches[i].range
                let end = matches[i + 1].range
                if let subContent = content.nssubString(range: NSRange(
                    location: start.location + boundary.count,
                    length: end.location - boundary.count - start.location
                )) {
                    let part = EmlParsePart.parse(mime: subContent.trimmingCharacters(in: .whitespacesAndNewlines))
                    parts.append(part)
                }
            }
        }
        return parts
    }
    
    // MARK: - Body
    public var body: String? {
        guard let content = content else {
            return nil
        }
        if let partID = partID {
            let start = content.nsrange(of: "--\(partID)")
            let end = content.nsrange(of: "--\(partID)--")
            if start.location == NSNotFound || end.location == NSNotFound || end.location < start.location {
                return nil
            }
            return content.nssubString(range: NSRange(location: start.location, length: end.location + end.length - start.location))
        } else {
            if let breakKey = breakKey {
                let start = content.nsrange(of: "\(breakKey)\(breakKey)")
                if start.location == NSNotFound {
                    return nil
                }
                let result = content.nssubString(range: NSRange(location: start.location, length: content.length - start.location))
                return result?.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        return nil
    }
    
    public var decodeBody: String? {
        guard var body = body else {
            return nil
        }
        if isBase64Encoding {
            if let breakKey = breakKey {
                body = body.replacingOccurrences(of: breakKey, with: "")
            }
            if let base64Data = Data(base64Encoded: body), let decodeStr = String(data: base64Data, encoding: .utf8) {
                return decodeStr
            }
        }
        else if isQPEncoding {
            let breakKeyType: BreakKeyType
            if let breakKey = breakKey, let bKey = BreakKeyType(rawValue: breakKey) {
                breakKeyType = bKey
            } else {
                breakKeyType = .n
            }
            return body.qpDecode(breakKey: breakKeyType, encoding: String.Encoding.getEncoding(charset: charset ?? ""))
        }
        return body
    }
    
    /// 获取html部分
    public var html: String? {
        if isHtmlPart {
            let decodeHtml = decodeBody
            // 其他字符集待后续反馈支持
            if let decoded = decodeHtml, charset == "gb2312" {
                return changeHtmlCharset(html: decoded)
            }
            return decodeHtml
        }
        let subParts = parts
        for part in subParts {
            if let html = part.html {
                return html
            }
        }
        return nil
    }
    /// 获取text部分
    public var text: String? {
        if isPlainPart {
            return decodeBody
        }
        let subParts = parts
        for part in subParts {
            if let html = part.text {
                return html
            }
        }
        return nil
    }
    /// 用于渲染的正文
    public var renderBody: String? {
        return html ?? text
    }
    
    // MARK: - Header
    public private(set) lazy var header: [String: String] = {
        guard let content = content, let breakKey = breakKey else {
            return [:]
        }
        let range = content.nsrange(of: "\(breakKey)\(breakKey)")
        guard let headerStr = content.nssubString(range: NSRange(location: 0, length: range.location)) else {
            return [:]
        }
        // 正则匹配：第一个单词必须以大写字母开头，后带多个英文字母或“-”，再带“:”
        let reg: String = "[A-Z][-|a-z|A-Z]+:.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reg)
        
        var header: [String: String] = [:]
        var key: String = ""
        var value: String = ""
        
        let lines = headerStr.components(separatedBy: breakKey)
        for index in 0..<lines.count {
            if predicate.evaluate(with: lines[index]) {
                var components = lines[index].components(separatedBy: ":")
                key = components.remove(at: 0)
                value = components.joined(separator: ": ")
            } else {
                value = value + breakKey + lines[index]
            }
            value = value.trimmingCharacters(in: .whitespaces)
            if let existValue = header[key] {
                header[key] = existValue + breakKey + value
            } else {
                header[key] = value
            }
        }
        
        return header
    }()
    
    public var from: String? {
        guard let fromStr = header["From"] else {
            return nil
        }
        return fromStr.mimeDecode
    }
    public var to: String? {
        guard let toStr = header["To"] else {
            return nil
        }
        return toStr.mimeDecode
    }
    public var cc: String? {
        guard let ccStr = header["Cc"] else {
            return nil
        }
        return ccStr.mimeDecode
    }
    public var bcc: String? {
        guard let bccStr = header["Bcc"] else {
            return nil
        }
        return bccStr.mimeDecode
    }
    public var subject: String? {
        guard let subjectStr = header["Subject"] else {
            return nil
        }
        return subjectStr.mimeDecode
    }
    public var date: String? {
        guard let dateStr = header["Date"] else {
            return nil
        }
        return dateStr
    }
    
    // MARK: - Attachment
    public var fileParts: [EmlParsePart] {
        if isMixedPart {
            let subParts = parts
            return subParts.filter({ $0.isAttachmentPart })
        }
        return []
    }
    
    public var inlineFileParts: [EmlParsePart] {
        if isRelatedPart {
            let subParts = parts
            return subParts.filter({ $0.isAttachmentPart })
        }
        let subParts = parts
        var parts: [EmlParsePart] = []
        for part in subParts {
            let inlineFiles = part.inlineFileParts
            parts.append(contentsOf: inlineFiles)
        }
        return parts
    }
    
    // 提取ContentType
    private func getContentType(item: String) -> String? {
        guard let reg = try? NSRegularExpression(pattern: "Content-Type:.*?(;|$)", options: .caseInsensitive) else {
            return nil
        }
        let text = item.trimmingCharacters(in: .whitespacesAndNewlines)
        let matches = reg.matches(in: text, range: NSRange(location: 0, length: text.count))
        if matches.count > 0 {
            if let matchStr = text.nssubString(range: matches[0].range) {
                let key = contentTypeKey
                let beginRange: NSRange = (matchStr as NSString).range(of: key)
                let result = matchStr.nssubString(range: NSRange(
                    location: beginRange.location + key.count,
                    length: matchStr.count - beginRange.location - key.count)
                )
                return purifyValue(item: result)
            }
        }
        return nil
    }
    // 提取PartID
    private func getPartId(item: String) -> String? {
        guard let reg = try? NSRegularExpression(pattern: "boundary=.*?(;|$)", options: .caseInsensitive) else {
            return nil
        }
        let text = item.trimmingCharacters(in: .whitespacesAndNewlines)
        let matches = reg.matches(in: text, range: NSRange(location: 0, length: text.count))
        if matches.count > 0 {
            if let matchStr = text.nssubString(range: matches[0].range) {
                let key = boundaryKey
                let beginRange: NSRange = (matchStr as NSString).range(of: key)
                let result = matchStr.nssubString(range: NSRange(
                    location: beginRange.location + key.count,
                    length: matchStr.count - beginRange.location - key.count)
                )
                return purifyValue(item: result)
            }
        }
        return nil
    }
    // 提取ContentDisposition
    private func getContentDisposition(item: String) -> String? {
        guard let reg = try? NSRegularExpression(pattern: "Content-Disposition:.*?(;|$)", options: .caseInsensitive) else {
            return nil
        }
        let text = item.trimmingCharacters(in: .whitespacesAndNewlines)
        let matches = reg.matches(in: text, range: NSRange(location: 0, length: text.count))
        if matches.count > 0 {
            if let matchStr = text.nssubString(range: matches[0].range) {
                let key = contentDispositionKey
                let beginRange: NSRange = (matchStr as NSString).range(of: key)
                let result = matchStr.nssubString(range: NSRange(
                    location: beginRange.location + key.count,
                    length: matchStr.count - beginRange.location - key.count)
                )
                return purifyValue(item: result)
            }
        }
        return nil
    }
    // 提取FileName
    private func getFileName(item: String) -> String? {
        guard let reg = try? NSRegularExpression(pattern: "filename=\".*?\"", options: .caseInsensitive) else {
            return nil
        }
        let text = item.trimmingCharacters(in: .whitespacesAndNewlines)
        let matches = reg.matches(in: text, range: NSRange(location: 0, length: text.count))
        if matches.count > 0 {
            if let matchStr = text.nssubString(range: matches[0].range) {
                let key = fileNameKey
                let beginRange: NSRange = (matchStr as NSString).range(of: key)
                let result = matchStr.nssubString(range: NSRange(
                    location: beginRange.location + key.count,
                    length: matchStr.count - beginRange.location - key.count)
                )
                let name = purifyValue(item: result)
                return name?.mimeDecode
            }
        }
        return nil
    }
    // 提取ContentID
    private func getContentID(item: String) -> String? {
        guard item.hasPrefix(contentIDKey) else {
            return nil
        }
        var result = item.replacingOccurrences(of: contentIDKey, with: "")
        result = result.trimmingCharacters(in: .whitespacesAndNewlines)
        if result.hasPrefix("<") && result.hasSuffix(">") {
            result = result.nssubString(range: NSRange(location: 1, length: result.length - 2)) ?? result
        }
        return result
    }
    // 提取smime-type
    private func getSmimeType(item: String) -> String? {
        guard let reg = try? NSRegularExpression(pattern: "smime-type=(.*?)(;|$)", options: .caseInsensitive) else {
            return nil
        }
        let text = item.trimmingCharacters(in: .whitespacesAndNewlines)
        let matches = reg.matches(in: text, range: NSRange(location: 0, length: text.count))
        if matches.count > 0 {
            if let matchStr = text.nssubString(range: matches[0].range) {
                let key = smimeTypeKey
                let beginRange: NSRange = (matchStr as NSString).range(of: key)
                let result = matchStr.nssubString(range: NSRange(
                    location: beginRange.location + key.count,
                    length: matchStr.count - beginRange.location - key.count)
                )
                return purifyValue(item: result)
            }
        }
        return nil
    }
    private func getCharSet(item: String) -> String? {
        guard let reg = try? NSRegularExpression(pattern: "charset=(.*?)(;|$)", options: .caseInsensitive) else {
            return nil
        }
        let text = item.trimmingCharacters(in: .whitespacesAndNewlines)
        let matches = reg.matches(in: text, range: NSRange(location: 0, length: text.count))
        if matches.count > 0 {
            if let matchStr = text.nssubString(range: matches[0].range) {
                let key = charsetKey
                let beginRange: NSRange = (matchStr as NSString).range(of: key)
                let result = matchStr.nssubString(range: NSRange(
                    location: beginRange.location + key.count,
                    length: matchStr.count - beginRange.location - key.count)
                )
                return purifyValue(item: result)
            }
        }
        return nil
    }
    
    // 对值进行提纯，去除末尾分号，前后引号等
    private func purifyValue(item: String?) -> String? {
        guard let item = item else {
            return nil
        }
        var result = item
        if result.hasSuffix(";") {
            result = result.nssubString(range: NSRange(location: 0, length: result.length - 1)) ?? result
        }
        if result.hasPrefix("\"") && result.hasPrefix("\"") {
            result = result.nssubString(range: NSRange(location: 1, length: result.length - 2)) ?? result
        }
        return result.trimmingCharacters(in: .whitespaces)
    }
    
    // decodeBody已对编码进行转换，需要再对html中的字符集设置声明为utf8
    private func changeHtmlCharset(html: String) -> String {
        guard let metaReg = try? NSRegularExpression(pattern: "<meta.*?charset=.*?>", options: .caseInsensitive),
                let charsetReg = try? NSRegularExpression(pattern: "charset=.*?(\"|;)", options: .caseInsensitive) else {
            return html
        }
        let metaMatches = metaReg.matches(in: html, range: NSRange(location: 0, length: html.count))
        guard metaMatches.count > 0 else {
            return html
        }
        if let meta_src = html.nssubString(range: metaMatches[0].range) {
            let matches = charsetReg.matches(in: meta_src, range: NSRange(location: 0, length: meta_src.utf16.count))
            if matches.count > 0, let charset_src = meta_src.nssubString(range: matches[0].range) {
                var charset_dst: String = "charset=utf8"
                if charset_src.hasSuffix(";") {
                    charset_dst += ";"
                } else if charset_src.hasSuffix("\"") {
                    charset_dst += "\""
                }
                let meta_dst = meta_src.nsreplaceSubrange(matches[0].range, with: charset_dst)
                return html.nsreplaceSubrange(metaMatches[0].range, with: meta_dst)
            }
        }
        return html
    }
    
    // MARK: - Content Type
    public var isMixedPart: Bool {
        return contentType == "multipart/mixed"
    }
    public var isAlternativePart: Bool {
        return contentType == "multipart/alternative"
    }
    public var isRelatedPart: Bool {
        return contentType == "multipart/related"
    }
    public var isHtmlPart: Bool {
        return contentType == "text/html"
    }
    public var isPlainPart: Bool {
        return contentType == "text/plain"
    }
    // MARK: - Content Disposition
    public var isAttachmentPart: Bool {
        return contentDisposition == "attachment" || fileName != nil
    }
    public var isInlinePart: Bool {
        return contentDisposition == "inline"
    }
    // MARK: - Content Encoding
    public var isBase64Encoding: Bool {
        return contentEncoding == "base64"
    }
    public var isQPEncoding: Bool {
        return contentEncoding == "quoted-printable"
    }
}
