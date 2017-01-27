//
//  OhmageManager.swift
//  consent_trial_1
//
//  Created by LIU ZEXI on 1/18/17.
//  Copyright © 2017 LIU ZEXI. All rights reserved.
//

import OhmageOMHSDK

class OhmageManager: NSObject {
    
    static let sharedInstance = OhmageManager()
    var ohmageManager: OhmageOMHManager!
    
    private override init() {
        
        let omhClientDetails = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "OMHClient", ofType: "plist")!)
        
        guard let baseURL = omhClientDetails?["OMHBaseURL"] as? String,
            let clientID = omhClientDetails?["OMHClientID"] as? String,
            let clientSecret = omhClientDetails?["OMHClientSecret"] as? String else {
                return
        }
        
        if OhmageOMHManager.config(baseURL: baseURL, clientID: clientID, clientSecret: clientSecret, queueStorageDirectory: "ohmageSDK", store: OhmageStore(), logger: LogManager.sharedInstance) {
            self.ohmageManager = OhmageOMHManager.shared
        }
        
    }
    
}

class OhmageStore: OhmageOMHSDKCredentialStore {
    public func set(value: NSSecureCoding?, key: String) {
        UserDefaults().set(value, forKey: key)
    }
    
    public func get(key: String) -> NSSecureCoding? {
        let val = UserDefaults().object(forKey: key) as? NSSecureCoding
        return val
    }
}
