//
//  EmlBuildPart.swift
//  EmlKit
//
//  Created by zhenghongyi on 2024/11/21.
//

import UIKit

public protocol EmlBuildPartProtocol {
    func build() -> String?
}

extension String: EmlBuildPartProtocol {
    public func build() -> String? {
        return self
    }
}

public class EmlBuildPart: NSObject, EmlBuildPartProtocol {
    
    public var contentType: String?
    
//    public var contentEncoding: String?
//    
//    public var contentDisposition: String?
    
    public var fileName: String? {
        didSet {
            if let fileName = fileName {
                let encodedName = fileName.mimeEncode()
                if let encodeType = encodedName.encodeType {
                    encodeFileName = encodedName.encoded[0].addMIMETag(type: encodeType)
                } else {
                    encodeFileName = fileName
                }
            } else {
                encodeFileName = fileName
            }
        }
    }
    
    public var contentID: String?
    
    public var body: String?
    
    public var breakKey: String?
    
    public var encodeType: MIMEDecodeType?
    
    private var encodeFileName: String?
    
    public func build() -> String? {
        guard let contentType = contentType, let body = body else {
            return nil
        }
        let breakKey = self.breakKey ?? BreakKeyType.n.rawValue
        var eml: String = "Content-Type: \(contentType); "
        
        if let fileName = encodeFileName {
            eml += breakKey + "\t" + "name=\"\(fileName)\";"
        } else {
            eml += "charset=UTF-8"
        }
        
        let emlBody: String
        if encodeFileName == nil {
            let encodedResult = body.mimeEncode(type: encodeType, enableMutliLines: true)
            if let encodeType = encodedResult.encodeType {
                eml += breakKey
                switch encodeType {
                case .base64:
                    eml += "Content-Transfer-Encoding: base64"
                case .quotedPrintable:
                    eml += "Content-Transfer-Encoding: quoted-printable"
                }
            }
            emlBody = encodedResult.encoded.joined(separator: breakKey)
        } else {
            eml += breakKey + "Content-Transfer-Encoding: base64"
            emlBody = body.toBase64Format(breakKey: breakKey)
        }
        
        if let fileName = encodeFileName {
            eml += breakKey
            
            if let contentID = contentID {
                eml += "Content-Disposition: inline; " + breakKey + "\t"
                eml += "filename=\"\(fileName)\"" + breakKey
                eml += "Content-ID: <\(contentID)>"
            } else {
                eml += "Content-Disposition: attachment; " + breakKey + "\t"
                eml += "filename=\"\(fileName)\""
            }
        }
        
        eml += breakKey + breakKey
        eml += emlBody
        
        return eml
    }
}
