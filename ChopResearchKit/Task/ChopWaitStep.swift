//
//  ChopWaitStep.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 6/9/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

enum WaitReasonEnum {
    case Unspecified
    case PasscodeVerification
}

struct ChopWaitStep {

    var reason = WaitReasonEnum.Unspecified
    
    init(withStepID stepID: String,
         withTitle title: String,
         withText text: String) {
        
        rkWaitStep = ORKWaitStep(identifier: stepID)
        
        rkWaitStep.title = title
        rkWaitStep.text = text
    }
    
    fileprivate var rkWaitStep: ORKWaitStep
    fileprivate var base = ChopRKTaskStepBase()
}

extension ChopWaitStep: ChopRKTaskStep {
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
        stepArray += [rkWaitStep]
    }
}


extension ChopWaitStep: ChopResearchStudyModuleStep {
    // MARK: ChopResearchStudyModuleStep
    var stepId: String { get { return rkWaitStep.identifier } }
    
}
