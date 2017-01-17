//
//  RegisTask.swift
//  consent_trial_1
//
//  Created by LIU ZEXI on 1/13/17.
//  Copyright © 2017 LIU ZEXI. All rights reserved.
//

import Foundation
import ResearchKit
/*
public var RegisTask: ORKOrderedTask {
    var steps = [ORKStep]()
    
    let registrationTitle = "Registration"
    let exampleDetailText = "ahahah"
    let passcodeValidationRegex = "^(?=.*\\d).{4,8}$"
    let passcodeInvalidMessage = NSLocalizedString("A valid password must be 4 and 8 digits long and include at least one numeric character.", comment: "")
    let registrationOptions: ORKRegistrationStepOption = [.includeGivenName, .includeFamilyName, .includeGender, .includeDOB]
    let registrationStep = ORKRegistrationStep(identifier: "registrationStep",
                                               title: registrationTitle,
                                               text: exampleDetailText,
                                               passcodeValidationRegex: passcodeValidationRegex,passcodeInvalidMessage: passcodeInvalidMessage, options: registrationOptions)
    steps += [registrationStep]
    return ORKOrderedTask(identifier: "RegisTask", steps: steps)

}
*/
public var RegisTask: ORKTask {
    /*
     A registration step provides a form step that is populated with email and password fields.
     If you wish to include any of the additional fields, then you can specify it through the `options` parameter.
     */
    let exampleDetailText = "haha"
    let registrationTitle = NSLocalizedString("Registration", comment: "")
    let passcodeValidationRegex = "^(?=.*\\d).{4,8}$"
    let passcodeInvalidMessage = NSLocalizedString("A valid password must be 4 and 8 digits long and include at least one numeric character.", comment: "")
    let registrationOptions: ORKRegistrationStepOption = [.includeGivenName, .includeFamilyName, .includeGender, .includeDOB]
    let registrationStep = ORKRegistrationStep(identifier: "registrationStep", title: registrationTitle, text: exampleDetailText, passcodeValidationRegex: passcodeValidationRegex, passcodeInvalidMessage: passcodeInvalidMessage, options: registrationOptions)
    
    /*
     A wait step allows you to upload the data from the user registration onto your server before presenting the verification step.
     */
    let waitTitle = NSLocalizedString("Creating account", comment: "")
    let waitText = NSLocalizedString("Please wait while we upload your data", comment: "")
    let waitStep = ORKWaitStep(identifier: "wiatStep")
    waitStep.title = waitTitle
    waitStep.text = waitText
    
    /*
     A verification step view controller subclass is required in order to use the verification step.
     The subclass provides the view controller button and UI behavior by overriding the following methods.
     */
    class VerificationViewController : ORKVerificationStepViewController {
        override func resendEmailButtonTapped() {
            let alertTitle = NSLocalizedString("Resend Verification Email", comment: "")
            let alertMessage = NSLocalizedString("Button tapped", comment: "")
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    let verificationStep = ORKVerificationStep(identifier: "verificationStep", text: exampleDetailText, verificationViewControllerClass: VerificationViewController.self)
    
    return ORKOrderedTask(identifier: "RegisTask", steps: [
        registrationStep,
        //waitStep,
        verificationStep
        ])
}
