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
    
    // Parameter ID's
    static let PID_EMAIL = "email"
    static let PID_PASSWORD = "password"

    // Step ID's
    static let SID_LOGIN = "LoginStep"
    
    
    init() {
        rkLoginStep = ORKLoginStep(identifier: ChopResearchStudyLoginStep.SID_LOGIN,
                                   title: "Login", text: "Please log in",
                                   loginViewControllerClass: ChopLoginStepViewController.self)
    }
    
    fileprivate var rkLoginStep: ORKLoginStep
    fileprivate var login = UserLogin()
    fileprivate var base = ChopRKTaskStepBase()
}

extension ChopResearchStudyLoginStep: ChopRKTaskStep {
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
        let rkResultsArray = ChopRKResultArray(with: orkStepResult?.results)
        
        login.capture(from: rkResultsArray)
    }
}

extension ChopResearchStudyLoginStep: GeneratesWebRequestData {
    // MARK: GeneratesWebRequestData
    public var webId: String {
        get { return "" }
        set {  }
    }
    
    func populateWebRequestPostDictionary(dictionary: inout Dictionary<String, String>) {
        
        dictionary[ChopResearchStudyLoginStep.PID_EMAIL] = login.email
        dictionary[ChopResearchStudyLoginStep.PID_PASSWORD] = login.password
    }
    
}

/*
extension ChopResearchStudyLoginStep: HoldsALoginEmail {
    
    public var loginEmail: String {
        
        return login.email
    }
}
*/

class ChopLoginStepViewController: ORKLoginStepViewController {
    
    override func forgotPasswordButtonTapped() {
        
        // perform resend email
        
        let alert = ChopUIAlert(forViewController: self, withTitle: "Forgot Password", andMessage: "Forgot Password functionality here.")
        
        alert.show()
    }
}
