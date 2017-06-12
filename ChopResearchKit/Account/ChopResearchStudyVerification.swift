//
//  ChopResearchStudyVerification.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 6/5/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

struct ChopResearchStudyVerification {
    
    init(withOptions optionsInit: ChopResearchStudyModuleOptions) {
        verificationOptions = optionsInit
    }
    
    fileprivate var verificationOptions: ChopResearchStudyModuleOptions

}

extension ChopResearchStudyVerification: ChopResearchStudyAccountLoginImplementation {
    // MARK: ChopResearchStudyAccountLoginImplementation
  
    var options : ChopResearchStudyModuleOptions! { get { return self.verificationOptions } }

    func loadSteps(into moduleStepContainer: inout ChopModuleStepCollection) {
        
        let verificationStep = ChopResearchStudyVerificationStep()
        
        if moduleStepContainer.add(element: verificationStep) == false {
            return
        }
    }
    
    func createModuleViewController(delegate: ChopResearchStudy, rkTaskToRun: ORKTask) -> UIViewController {
        
        let taskViewController = ChopRKTaskViewController(
            type: ChopResearchStudyModuleTypeEnum.Login,
            task: rkTaskToRun,
            taskRun: nil)
        
        taskViewController.delegate = delegate
        
        return taskViewController
    }

    mutating func onFinish(withResult taskResult: ORKTaskResult) {
        
    }
}

class ChopVerificationStepViewController: ORKVerificationStepViewController {
    
    override func resendEmailButtonTapped() {
        
        // perform resend email
        
        let alert = ChopUIAlert(forViewController: self, withTitle: "Email Sent", andMessage: "Verification email has been re-sent.")
        
        alert.show()
    }
}
