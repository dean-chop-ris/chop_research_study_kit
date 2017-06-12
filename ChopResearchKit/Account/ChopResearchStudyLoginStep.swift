//
//  ChopResearchStudyLoginStep.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 6/7/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

struct ChopResearchStudyLoginStep {
    
    init() {
        rkLoginStep = ORKLoginStep(identifier: "LoginStep",
                                   title: "Login", text: "Please log in",
                                   loginViewControllerClass: ChopLoginStepViewController.self)
    }
    
    fileprivate var rkLoginStep: ORKLoginStep
    fileprivate var login = UserLogin()
}

extension ChopResearchStudyLoginStep: ChopRKTaskStep {
    // MARK: ChopRKTaskStep
    
    func populateRKStepArray(stepArray: inout [ORKStep]) {
        stepArray += [rkLoginStep]
    }
}


extension ChopResearchStudyLoginStep: ChopResearchStudyModuleStep {
    // MARK: ChopResearchStudyModuleStep
    
    var stepId: String { get { return rkLoginStep.identifier } }
    
}

extension ChopResearchStudyLoginStep: HasModuleStepDataToCapture {
    // MARK: HasModuleStepDataToCapture
    
    mutating func captureResult(fromORKTaskResult orkTaskResult: ORKTaskResult) {
        
        let orkStepResult = orkTaskResult.stepResult(forStepIdentifier: self.stepId)
        let rkResultsArray = ChopRKTextQuestionResultArray(with: orkStepResult?.results)
        
        login.capture(from: rkResultsArray)
    }
}



class ChopLoginStepViewController: ORKLoginStepViewController {
    
    override func forgotPasswordButtonTapped() {
        
        // perform resend email
        
        let alert = ChopUIAlert(forViewController: self, withTitle: "Forgot Password", andMessage: "Forgot Password functionality here.")
        
        alert.show()
    }
}
