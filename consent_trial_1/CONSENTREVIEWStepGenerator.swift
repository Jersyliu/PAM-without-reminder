//
//  CONSENTREVIEWStepGenerator.swift
//  consent_trial_1
//
//  Created by LIU ZEXI on 1/17/17.
//  Copyright © 2017 LIU ZEXI. All rights reserved.
//

import ResearchSuiteTaskBuilder
import ResearchKit
import Gloss
import sdlrkx

open class CONSENTREVIEWStepGenerator: RSTBBaseStepGenerator {
    public init(){}
    
    let _supportedTypes = [
        "CONSENTREVIEW"
    ]
    
    public var supportedTypes: [String]! {
        return self._supportedTypes
    }
    
    open func generateStep(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKStep? {
        
        guard let customStepDescriptor = helper.getCustomStepDescriptor(forJsonObject: jsonObject) else {
            return nil
        }
        let consentDocument = ConsentDocument
        let signature = consentDocument.signatures!.first!
        let step = ORKConsentReviewStep(identifier: customStepDescriptor.identifier, signature: signature, in: consentDocument)
        return step
    }
    
    open func processStepResult(type: String,
                                jsonObject: JsonObject,
                                result: ORKStepResult,
                                helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }
}
