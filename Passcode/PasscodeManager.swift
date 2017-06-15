//
//  PasscodeManager.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 6/15/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

struct PasscodeManager {

    
    public private(set) var rkPasscodeTask : ChopRKTask!

    
    mutating func implement(options: ChopResearchStudyModuleOptions) -> Bool {
        
        // reset step collection
        moduleSteps = ChopModuleStepCollection()
        
        switch options.passcodeMode {
        case PasscodeMode.Creation:
            impl = ChopPasscodeCreation(withOptions: options)
        case PasscodeMode.Enforcement:
            impl = ChopPasscodeEnforcement(withOptions: options)
        case PasscodeMode.Edit:
            impl = ChopPasscodeEdit(withOptions: options)
        default:
            print("ERROR: case not included: " + options.passcodeMode.rawValue)
            return false
        }
        
        impl?.loadSteps(into: &moduleSteps)
        
        rkPasscodeTask = ChopRKTask(identifier: "Passcode",
                                    stepsToInit: moduleSteps)
        return true
    }

    /* mutating */ func createModuleViewController(delegate: ChopResearchStudy) -> UIViewController {
        
        return /* self.moduleVC = */ (impl?.createModuleViewController(
            delegate: delegate,
            rkTaskToRun: self.rkPasscodeTask))!
        
        //return self.moduleVC!
    }
    
    mutating func onFinish(withResult taskResult: ORKTaskResult) {
        
        moduleSteps.captureResults(withResult: taskResult)
        
        impl?.onFinish(withResult: taskResult)
    }

    fileprivate var impl: ChopPasscodeModuleImplementation?
    fileprivate var moduleSteps = ChopModuleStepCollection()
}
