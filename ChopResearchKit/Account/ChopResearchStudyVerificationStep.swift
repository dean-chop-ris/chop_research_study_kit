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
    
    init() {
        rkVerificationStep = ORKVerificationStep(identifier: "VerificationStep", text: "Please verify", verificationViewControllerClass: ChopVerificationStepViewController.self)
    }
    
    fileprivate var rkVerificationStep: ORKVerificationStep
    //fileprivate var registrationInfo = Dictionary<String, String>()
}

extension ChopResearchStudyVerificationStep: ChopRKTaskStep {
    // MARK: ChopRKTaskStep
    
    func populateRKStepArray(stepArray: inout [ORKStep]) {
        stepArray += [rkVerificationStep]
    }
}

extension ChopResearchStudyVerificationStep: ChopResearchStudyModuleStep {
    // MARK: ChopResearchStudyModuleStep
    
    var stepId: String { get { return rkVerificationStep.identifier } }
    
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
