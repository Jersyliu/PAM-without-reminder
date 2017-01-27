//
//  PAMDataPoint.swift
//  consent_trial_1
//
//  Created by LIU ZEXI on 1/18/17.
//  Copyright © 2017 LIU ZEXI. All rights reserved.
//

import OMHClient

public class PAMDataPoint: OMHDataPointBase {
    
    var affectValence: Int!
    var affectArousal: Int!
    var positiveAffect: Int!
    var negativeAffect: Int!
    var mood: String!
    
    init(dict: [String: Any]) {
        super.init()
        self.acquisitionSourceName = "example"
        self.acquisitionModality = .SelfReported
        
        self.affectArousal = dict["affect_arousal"] as! Int!
        self.affectValence = dict["affect_valence"] as! Int!
        self.positiveAffect = dict["positive_affect"] as! Int!
        self.negativeAffect = dict["negative_affect"] as! Int!
        self.mood = dict["mood"] as! String!
    }
    
    required public init() {
        fatalError("init() has not been implemented")
    }
    
    static var supportsSecureCoding: Bool {
        return true
    }
    
    override public var schema: OMHSchema {
        return OMHSchema(
            name: "photographic-affect-meter-scores",
            version: "1.0",
            namespace: "cornell")
    }
    
    override public var body: [String: Any] {
        
        return [
            "affect_valence": self.affectValence,
            "affect_arousal": self.affectArousal,
            "positive_affect": self.positiveAffect,
            "negative_affect": self.negativeAffect,
            "mood": self.mood,
            "effective_time_frame": [
                "date_time": self.stringFromDate(self.creationDateTime)
            ]
            
        ]
    }
}

