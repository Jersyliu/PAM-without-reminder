//
//  ViewController.swift
//  consent_trial_1
//
//  Created by LIU ZEXI on 1/13/17.
//  Copyright © 2017 LIU ZEXI. All rights reserved.
//

import UIKit
import ResearchKit
import sdlrkx
import ResearchSuiteTaskBuilder
import OMHClient
import OhmageOMHSDK

let kActivityIdentifiers = "activity_identifiers"
let kMedicationIdentifiers = "medication_identifiers"


class ViewController: UIViewController {
    
    var taskResultFinishedCompletionHandler: ((ORKResult) -> Void)?
    var taskBuilder: RSTBTaskBuilder!
    var lastestError: Error?
    var shouldShowPAM = true
    var didSkipLogin = false
    
    @IBAction func takePAMAgain(_ sender: Any) {
        PAM()
    }
    
    @IBAction func logOut(_ sender: Any) {
        signOut()
        loginAndConsent()
    }
    
    @IBAction func remainder(_ sender: Any) {
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stepGeneratorServices: [RSTBStepGenerator] = [
            RSTBInstructionStepGenerator(),
            PAMStepGenerator(),
            LOGINStepGenerator(),
            VISUALCONSENTStepGenerator(),
            CONSENTREVIEWStepGenerator(),
            RSTBSingleChoiceStepGenerator()
        ]
        
        let answerFormatGeneratorServices: [RSTBAnswerFormatGenerator] = [
            RSTBSingleChoiceStepGenerator()
        ]
        
        let elementGeneratorServices: [RSTBElementGenerator] = [
            RSTBElementListGenerator(),
            RSTBElementFileGenerator(),
            RSTBElementSelectorGenerator()
        ]
        
        self.taskBuilder = RSTBTaskBuilder(
            stateHelper: nil,
            elementGeneratorServices: elementGeneratorServices,
            stepGeneratorServices: stepGeneratorServices,
            answerFormatGeneratorServices: answerFormatGeneratorServices)
        
        self.shouldShowPAM = true
        self.didSkipLogin = false
    }
    
    func isLoggedInOrSkippedLogIn() -> Bool {
        return self.didSkipLogin || OhmageManager.sharedInstance.ohmageManager.isSignedIn
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if !self.isLoggedInOrSkippedLogIn() {
            self.loginAndConsent()
        }
        else if self.shouldShowPAM {
            self.shouldShowPAM = false
            self.PAM()
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginAndConsent() {
        guard let loginSteps = self.taskBuilder.steps(forElementFilename: "LOGINTask") else { return }
        guard let consentSteps = self.taskBuilder.steps(forElementFilename: "CONSENTTask") else { return }
        let LOGINANDCONSENTTask = ORKOrderedTask(identifier: "CONSENTTask", steps: loginSteps+consentSteps)
        let taskViewController = ORKTaskViewController(task: LOGINANDCONSENTTask, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }
    
    func PAM() {
        guard let steps = self.taskBuilder.steps(forElementFilename: "PAMTask2") else { return }
        
        let PAMTask = ORKOrderedTask(identifier: "PAMTask", steps: steps)
        let taskViewController = ORKTaskViewController(task: PAMTask, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }
    
    func signOut() {
        self.shouldShowPAM = true
        self.didSkipLogin = false
        let log = "Signing out"
        LogManager.sharedInstance.log(log)
        
        OhmageManager.sharedInstance.ohmageManager.signOut { (error) in
            self.lastestError = error
            DispatchQueue.main.async {}
        }
    }
    
    func PAMResultHandler(taskResult: ORKTaskResult) {
        guard let pamStepResult = taskResult.stepResult(forStepIdentifier: "PAM"),
            let firstResult = pamStepResult.firstResult as? ORKChoiceQuestionResult,
        let choices = firstResult.choiceAnswers,
        let pamChoice = choices.first as? [String: Any]
        else {
            return
        }
        print(pamChoice)
        print(pamChoice["affect_arousal"] ?? 0)
        let dataPoint = PAMDataPoint(dict: pamChoice)
        let log = "Adding datapoint: \(dataPoint.toDict().debugDescription)"
        LogManager.sharedInstance.log(log)
        
        OhmageManager.sharedInstance.ohmageManager.addDatapoint(datapoint: dataPoint, completion: { (error) in
            self.lastestError = error
            DispatchQueue.main.async {}
        })
        
    }
    
    func consentFlowResultHandler(taskResult: ORKTaskResult) {
        
        if let loginStepResult = taskResult.stepResult(forStepIdentifier: "LoginStep"),
            let loginResult = loginStepResult.result(forIdentifier: CTFLoginStepViewController.LoggedInResultIdentifier) as? ORKBooleanQuestionResult,
            let didLogIn: NSNumber = loginResult.booleanAnswer {
            
            if didLogIn.boolValue {
                if let stepResult = taskResult.stepResult(forStepIdentifier: "ConsentReviewStep"),let signatureResult = stepResult.results?.first as? ORKConsentSignatureResult {
                    let document = ConsentDocument.copy() as! ORKConsentDocument
                    signatureResult.apply(to: document)
                    
                    document.makePDF(completionHandler: { (data, error) -> Void in
                        var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).first
                        print(docURL ?? "pp")
                        docURL = docURL?.appendingPathComponent( "myFileName.pdf")
                        //write your file to the disk.
                        do {
                            try data?.write(to: docURL!)
                        }
                        catch {
                            print("Error")
                        }
                        //now you can see that pdf in your applications directory
                        let consent = ConsentSample(consentURL: docURL!)
                        OhmageOMHManager.shared.addDatapoint(datapoint: consent, completion: { (error) in
                            
                            debugPrint(error ?? "No error")
                            
                        })
                        
                        print(docURL!)
                    })
                }
            }
            else {
                self.didSkipLogin = true
            }
        }
    }
}

extension ViewController : ORKTaskViewControllerDelegate {
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        //Handle results with taskViewController.result
        //print(taskViewController.result)
        let taskResult = taskViewController.result
        guard reason == ORKTaskViewControllerFinishReason.completed
        else {
            switch taskResult.identifier {
            case "PAMTask":
                taskViewController.dismiss(animated: true, completion: nil)
            case "CONSENTTask":
                signOut()
                taskViewController.dismiss(animated: true, completion: nil)
            default:
                taskViewController.dismiss(animated: true, completion: nil)
            }
            return
        }
        
        print(taskResult.identifier)
        
        switch taskResult.identifier {
        case "PAMTask":
            PAMResultHandler(taskResult: taskResult)
        case "CONSENTTask":
            consentFlowResultHandler(taskResult: taskResult)
        default:
            taskViewController.dismiss(animated: true, completion: nil)
            return
        }
        taskViewController.dismiss(animated: true, completion: nil)
    }
}
