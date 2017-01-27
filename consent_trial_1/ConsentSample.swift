//
//  ConsentSample.swift
//  consent_trial_1
//
//  Created by LIU ZEXI on 1/24/17.
//  Copyright © 2017 LIU ZEXI. All rights reserved.
//


import OMHClient

public final class ConsentSample: OMHMediaDataPointBase {
    
    
    public init(consentURL: URL) {
        
        super.init()
        let uuid = UUID().uuidString
        
        let attachment = OMHMediaAttachment(fileName: uuid, fileURL: consentURL, mimeType: "application/pdf")
        self.addAttachment(attachment: attachment)
        
    }
    
    required public init() {
        fatalError("init() has not been implemented")
    }
    
    static var supportsSecureCoding: Bool {
        return true
    }
    
    override public var schema: OMHSchema {
        return OMHSchema(
            name: "example-consent",
            version: "1.1",
            namespace: "cornell")
    }
    
    override public var body: [String: Any] {
        return ["consent": "consent"]
    }
}
