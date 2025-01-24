//
//  EmlBuilder.swift
//  EmlKit
//
//  Created by zhenghongyi on 2024/9/3.
//

import UIKit

public typealias EmlUser = (name: String?, email: String)

public class EmlBuilder: NSObject {
    public var from: EmlUser?
    public var to: [EmlUser] = []
    public var cc: [EmlUser] = []
    public var bcc: [EmlUser] = []
    public var subject: String?
    
    public enum Text {
        case html(content: String)
        case plain(content: String)
        case alternative(content: String)
    }
    public var text: Text?
    public var textEncodeType: MIMEDecodeType?
    
    public var files: [EmlBuildPart] = []
    public var inlineFiles: [EmlBuildPart] = []
    
    public var breakKey: BreakKeyType = .rn
    
    public var extraHeader: [String: String] = [:]
    
    public func buildEml() -> String {
        var eml: String = ""
        
        let sendDateStr = {
            let dateFormatter = DateFormatter()
            //EEE, dd MMM yyyy HH:mm:ss Z
            dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            let dateString = dateFormatter.string(from: Date())
            
            let timezoneOffset = TimeZone.current.secondsFromGMT()
            let hours = timezoneOffset / 3600
            let minutes = abs(timezoneOffset / 60) % 60
            let gmtString = String(format: "(GMT%+02d:%02d)", hours, minutes)

            let completeDateString = "\(dateString) +\(String(format: "%02d%02d", hours, minutes)) \(gmtString)"
            
            return completeDateString
        }()
        eml += "Date: \(sendDateStr)" + breakKey.rawValue
        
        eml += "Message-ID: <\(generatePartID())_\(Date().timeIntervalSince1970)>" + breakKey.rawValue
        
        func emlUsersStr(users: [EmlUser]) -> String {
            let users = users.map { (name: String?, email: String) in
                var user: String = ""
                if let name = name {
                    let encodeResult = name.mimeEncode()
                    user += encodeResult.encoded.joined().addMIMETag(type: encodeResult.encodeType) + " <\(email)>"
                } else {
                    user += email
                }
                return user
            }
            return users.joined(separator: ",\(breakKey.rawValue)\t")
        }
        
        if let from = from {
            eml += "From: " + emlUsersStr(users: [from]) + breakKey.rawValue
        }
        if to.count > 0 {
            eml += "To: " + emlUsersStr(users: to) + breakKey.rawValue
        }
        if cc.count > 0 {
            eml += "Cc: " + emlUsersStr(users: cc) + breakKey.rawValue
        }
        if bcc.count > 0 {
            eml += "Bcc: " + emlUsersStr(users: bcc) + breakKey.rawValue
        }
        if let subject = subject {
            let encodedResult = subject.mimeEncode(enableMutliLines: true)
            let subjectItems: [String] = encodedResult.encoded.map({ $0.addMIMETag(type: encodedResult.encodeType) })
            eml += "Subject: " + subjectItems.joined(separator: "\(breakKey.rawValue)\t") + breakKey.rawValue
        }
        eml += "MIME-Version: 1.0" + breakKey.rawValue
        for (key, value) in extraHeader {
            eml += "\(key): \(value)" + breakKey.rawValue
        }
        
        var plainPart: EmlBuildPart?
        var htmlPart: EmlBuildPart?
        var alternative: String?
        
        if let text = text {
            var plain: String?
            var html: String?
            
            switch text {
            case .html(let content):
                html = content
            case .plain(let content):
                plain = content
                html = "<div>\(content)</div>"
            case .alternative(let content):
                alternative = content
            }
            
            if let plain = plain {
                let part = EmlBuildPart()
                part.contentType = "text/plain"
                part.body = plain
                part.breakKey = breakKey.rawValue
                part.encodeType = textEncodeType
                plainPart = part
            }
            if let html = html {
                let part = EmlBuildPart()
                part.contentType = "text/html"
                part.body = html
                part.breakKey = breakKey.rawValue
                part.encodeType = textEncodeType
                htmlPart = part
            }
        }
        
        if plainPart != nil || htmlPart != nil {
            eml += combine(plain: plainPart, html: htmlPart, inlines: inlineFiles, files: files)
        } else {
            eml += combine(alternative: alternative, inlines: inlineFiles, files: files)
        }
        
        return eml
    }
    
    func generatePartID() -> String {
        let uuid = UUID().uuidString
        return uuid.replacingOccurrences(of: "-", with: "")
    }
    
    func combine(plain: EmlBuildPart?, html: EmlBuildPart?, inlines: [EmlBuildPart], files: [EmlBuildPart]) -> String {
        var eml: String = ""
        
        let plainEml: String? = plain?.build()
        let htmlEml: String? = html?.build()
        if plainEml != nil || htmlEml != nil {
            let textPartID = generatePartID()
            eml = "Content-Type: multipart/alternative; \(breakKey.rawValue)\tboundary=\"\(textPartID)\""
            eml += breakKey.rawValue + breakKey.rawValue
            if let plainEml = plainEml {
                eml += "--\(textPartID)" + breakKey.rawValue
                eml += plainEml
                eml += breakKey.rawValue
            }
            if let htmlEml = htmlEml {
                eml += "--\(textPartID)" + breakKey.rawValue
                eml += htmlEml
                eml += breakKey.rawValue
            }
            eml += "--\(textPartID)--"
            
            return combine(alternative: eml, inlines: inlines, files: files)
        }
        return combine(alternative: nil, inlines: inlines, files: files)
    }
    
    func combine(alternative: EmlBuildPartProtocol?, inlines: [EmlBuildPartProtocol], files: [EmlBuildPartProtocol]) -> String {
        var eml: String = ""
        if let alternative = alternative?.build() {
            eml = alternative
        }
        if inlines.count > 0 {
            let relatedPartID = generatePartID()
            var inlinesEml: String = ""
            for part in inlines {
                if let partEml = part.build() {
                    inlinesEml += "--\(relatedPartID)" + breakKey.rawValue + partEml + breakKey.rawValue
                }
            }
            inlinesEml += "--\(relatedPartID)--"
            eml = "Content-Type: multipart/related; \(breakKey.rawValue)\tboundary=\"\(relatedPartID)\"" + breakKey.rawValue + breakKey.rawValue + "--\(relatedPartID)" + breakKey.rawValue + eml + breakKey.rawValue + breakKey.rawValue + inlinesEml
        }
        if files.count > 0 {
            if eml.isEmpty == true && files.count == 1 {
                eml = files[0].build() ?? ""
            } else {
                let mixedPartID = generatePartID()
                var fileEml: String = ""
                for part in files {
                    if let partEml = part.build() {
                        fileEml += "--\(mixedPartID)" + breakKey.rawValue + partEml + breakKey.rawValue
                    }
                }
                fileEml += "--\(mixedPartID)--"
                
                if eml.isEmpty {
                    eml = "Content-Type: multipart/mixed; \(breakKey.rawValue)\tboundary=\"\(mixedPartID)\"" + breakKey.rawValue + breakKey.rawValue + fileEml
                } else {
                    eml = "Content-Type: multipart/mixed; \(breakKey.rawValue)\tboundary=\"\(mixedPartID)\"" + breakKey.rawValue + breakKey.rawValue + "--\(mixedPartID)" + breakKey.rawValue + eml + breakKey.rawValue + breakKey.rawValue + fileEml
                }
            }
        }
        
        return eml
    }
}
