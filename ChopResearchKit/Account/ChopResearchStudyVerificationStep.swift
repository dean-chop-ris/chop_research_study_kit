//
//  ChopResearchStudyVerificationStep.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 6/7/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

struct ChopResearchStudyVerificationStep {
 
    static let PID_EMAIL = "email"

    init() {
        rkVerificationStep = ORKVerificationStep(identifier: "VerificationStep", text: "Please verify", verificationViewControllerClass: ChopVerificationStepViewController.self)
    }
    
    fileprivate var rkVerificationStep: ORKVerificationStep
    fileprivate var base = ChopRKTaskStepBase()
}

extension ChopResearchStudyVerificationStep: ChopRKTaskStep {
    // MARK: ChopRKTaskStep
    
    
    var passcodeProtected: Bool {
        get {
            return self.base.passcodeProtected
        }
        set {
            self.base.passcodeProtected = newValue
        }
    }
    
    func populateRKStepArray(stepArray: inout [ORKStep]) {
        stepArray += [rkVerificationStep]
    }
}

extension ChopResearchStudyVerificationStep: ChopResearchStudyModuleStep {
    // MARK: ChopResearchStudyModuleStep
    
    var stepId: String { get { return rkVerificationStep.identifier } }
    
}

extension ChopResearchStudyVerificationStep: GeneratesWebRequestData {
    // MARK: GeneratesWebRequestData
    public var webId: String {
        get { return "" }
        set {  }
    }
    
    func populateWebRequestPostDictionary(dictionary: inout Dictionary<String, String>) {
        
        dictionary[ChopResearchStudyVerificationStep.PID_EMAIL] = "user@chop.com"
    }
    
}

extension ChopResearchStudyVerificationStep: HasModuleStepDataToCapture {
    // MARK: HasModuleStepDataToCapture
    
    mutating func captureResult(fromORKTaskResult orkTaskResult: ORKTaskResult) {
        
//        let orkStepResult = orkTaskResult.stepResult(forStepIdentifier: self.stepId)
//        
//        let orkResultArray = orkStepResult?.results
//        
//        if (orkResultArray != nil) {
//            
//            for questionResult in orkResultArray! {
//                let textQuestionResult = questionResult as! ORKTextQuestionResult
//                
//                registrationInfo[textQuestionResult.identifier] = textQuestionResult.textAnswer
//            }
//        }
    }
}


