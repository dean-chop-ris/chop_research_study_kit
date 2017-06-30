//
//  ChopSurveyCompletionStep.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 5/12/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

struct ChopSurveyCompletionStep {
    
    init(withStepID stepID: String,
         withTitle title: String,
         withText text: String) {
        
        let step = ORKCompletionStep(identifier: stepID)
        
        step.title = title
        step.text = text
        
        rkStep = step
    }
    
    func isValid(givenResult result: ORKTaskResult) -> Bool { return true }

    fileprivate var rkStep: ORKStep
    fileprivate var base = ChopRKTaskStepBase()
}

extension ChopSurveyCompletionStep: ChopRKTaskStep {
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
        stepArray += [rkStep]
    }
}

extension ChopSurveyCompletionStep: ChopResearchStudyModuleStep {
    // MARK: ChopResearchStudyModuleStep
    var stepId: String { get { return rkStep.identifier } }
    
}
