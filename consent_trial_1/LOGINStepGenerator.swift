//
//  LOGINStepGenerator.swift
//  consent_trial_1
//
//  Created by LIU ZEXI on 1/17/17.
//  Copyright © 2017 LIU ZEXI. All rights reserved.
//

import ResearchSuiteTaskBuilder
import ResearchKit
import Gloss
import sdlrkx
import OhmageOMHSDK

open class LOGINStepGenerator: RSTBBaseStepGenerator {
    public init(){}
    
    let _supportedTypes = [
        "LOGIN"
    ]
    
    public var supportedTypes: [String]! {
        return self._supportedTypes
    }
    
    open func generateStep(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKStep? {
        
        guard let customStepDescriptor = helper.getCustomStepDescriptor(forJsonObject: jsonObject) else {
            return nil
        }
        
        let step = CTFOhmageLoginStep(identifier: customStepDescriptor.identifier)
        
        return step
    }
    
    open func processStepResult(type: String, jsonObject: JsonObject, result: ORKStepResult, helper:RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }
}
