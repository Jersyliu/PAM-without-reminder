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

let kActivityIdentifiers = "activity_identifiers"
let kMedicationIdentifiers = "medication_identifiers"


class ViewController: UIViewController {
    
    var taskResultFinishedCompletionHandler: ((ORKResult) -> Void)?
    var taskBuilder: RSTBTaskBuilder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stepGeneratorServices: [RSTBStepGenerator] = [
            RSTBInstructionStepGenerator(),
            PAMStepGenerator(),
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
        
        // Do any additional setup after loading the view, typically from a nib.
        self.taskBuilder = RSTBTaskBuilder(
            stateHelper: nil,
            elementGeneratorServices: elementGeneratorServices,
            stepGeneratorServices: stepGeneratorServices,
            answerFormatGeneratorServices: answerFormatGeneratorServices)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func loginTapped(_ sender: Any) {
        let taskViewController = ORKTaskViewController(task: LoginTask, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }
    
    @IBAction func regisTapped(_ sender: Any) {
        let taskViewController = ORKTaskViewController(task: RegisTask, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }
    
    @IBAction func consentTapped(_ sender: Any) {
        let taskViewController = ORKTaskViewController(task: ConsentTask, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }

    @IBAction func surveyTapped(_ sender: Any) {
        let taskViewController = ORKTaskViewController(task: SurveyTask, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }
    @IBAction func PAM(_ sender: Any) {
        guard let steps = self.taskBuilder.steps(forElementFilename: "PAMTask") else { return }
        
        let PAMTask = ORKOrderedTask(identifier: "PAM identifier", steps: steps)
        let taskViewController = ORKTaskViewController(task: PAMTask, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }

}

extension ViewController : ORKTaskViewControllerDelegate {
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        //Handle results with taskViewController.result
        print(taskViewController.result)
        
        let taskResult = taskViewController.result // this should be a ORKTaskResult
        let results = taskResult.results as! [ORKStepResult]//[ORKStepResult]
        
        for thisStepResult in results { // [ORKStepResults]
            let stepResults = thisStepResult.results as! [ORKQuestionResult]
            for item in stepResults {
                if let p = item.answer {
                    print(p)
                }
                else {
                    print("None")
                }
            }
        }
        taskViewController.dismiss(animated: true, completion: nil)
    }
}

class loginViewController: UIViewController, ORKTaskViewControllerDelegate {
    
    @IBAction func loginTapped(_ sender: Any) {
        let taskViewController = ORKTaskViewController(task: LoginTask, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }

    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        //Handle results with taskViewController.result
        print("haha")
        
        let taskResult = taskViewController.result // this should be a ORKTaskResult
        let results = taskResult.results as! [ORKStepResult]//[ORKStepResult]
        
        for thisStepResult in results { // [ORKStepResults]
            let stepResults = thisStepResult.results as! [ORKQuestionResult]
            for item in stepResults {
                if let p = item.answer {
                    print(p)
                }
                else {
                    print("None")
                }
            }
        }
        taskViewController.dismiss(animated: true, completion: nil)
    }

}
