//
//  ChopSurveyIntroductionStep.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 5/12/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

struct ChopSurveyIntroductionStep {

    init(withStepID stepID: String,
         withTitle title: String,
         withText text: String) {
        
        let instructionStep = ORKInstructionStep(identifier: stepID)
        
        instructionStep.title = title
        instructionStep.text = text
        
        rkStep = instructionStep
    }
    
    fileprivate var rkStep: ORKStep
}

extension ChopSurveyIntroductionStep: ChopRKTaskStep {
    // MARK: ChopRKTaskStep
    func populateRKStepArray(stepArray: inout [ORKStep]) {
        stepArray += [rkStep]
    }
}

extension ChopSurveyIntroductionStep: ChopResearchStudyModuleStep {
    // MARK: ChopResearchStudyModuleStep
    var stepId: String { get { return rkStep.identifier } }
    
}
