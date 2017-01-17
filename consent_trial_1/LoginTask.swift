//
//  LoginTask.swift
//  consent_trial_1
//
//  Created by LIU ZEXI on 1/13/17.
//  Copyright © 2017 LIU ZEXI. All rights reserved.
//

import Foundation
import ResearchKit

public var LoginTask: ORKTask {
    
    class LoginViewController : ORKLoginStepViewController {
        override func forgotPasswordButtonTapped() {
            let alertTitle = "Forgot password?"
            let alertMessage = "Button tapped"
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
        override func goForward() {
            
            super.goForward()
            
        }
    }
    
    /*
     A login step provides a form step that is populated with email and password fields,
     and a button for `Forgot password?`.
     */
    let loginTitle = "Login"
    let exampleDetailText = "kekekke"
    let loginStep = ORKLoginStep(identifier: "LoginStep", title: loginTitle, text: exampleDetailText, loginViewControllerClass: LoginViewController.self)
    
    
    /*
     A wait step allows you to validate the data from the user login against your server before proceeding.
     */
    let waitTitle = "Logging in"
    let waitText = "Please wait while we validate your credentials"
    let waitStep = ORKWaitStep(identifier: "LoginWaitStep")
    waitStep.title = waitTitle
    waitStep.text = waitText
    
    return ORKOrderedTask(identifier: "LoginTask", steps: [loginStep, waitStep])
                                                           //,waitStep])
}
