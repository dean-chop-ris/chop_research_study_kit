//
//  ChopPasscodeStep.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 6/22/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

struct ChopPasscodeStep {
    
    static let SID_PasscodeStep: String = "PasscodeStep"
    
    init() {
        rkPasscodeStep = ORKPasscodeStep(
            identifier: ChopPasscodeStep.SID_PasscodeStep)
    }
    
    
    fileprivate var rkPasscodeStep: ORKPasscodeStep
    fileprivate var base = ChopRKTaskStepBase()
}

extension ChopPasscodeStep: ChopRKTaskStep {
    
    var passcodeProtected: Bool {
        get {
            return self.base.passcodeProtected
        }
        set {
            self.base.passcodeProtected = newValue
        }
    }

    // MARK: ChopRKTaskStep
    
    func populateRKStepArray(stepArray: inout [ORKStep]) {
        stepArray += [rkPasscodeStep]
    }
}

extension ChopPasscodeStep: ChopResearchStudyModuleStep {
    // MARK: ChopResearchStudyModuleStep
    
    var stepId: String { get { return rkPasscodeStep.identifier } }
    
}

extension ChopPasscodeStep: HasModuleStepDataToCapture {
    // MARK: HasModuleStepDataToCapture
    
    mutating func captureResult(fromORKTaskResult orkTaskResult: ORKTaskResult) {

        // Upon completion of passcode creation, the passcode is saved in the device's keychain, so no result capture is needed.
    }
}
