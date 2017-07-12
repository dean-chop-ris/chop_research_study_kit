//
//  ChopResearchStudyRegistrationStep.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 6/1/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

struct ChopResearchStudyRegistrationStep {

    // Step ID
    static let SID_RegistrationStep: String = "RegistrationStep"

    // Parameter ID's
    static let PID_EMAIL = "email"
    static let PID_PASSWORD = "password"

    init() {
        rkRegistrationStep = ORKRegistrationStep(
            identifier: ChopResearchStudyRegistrationStep.SID_RegistrationStep,
            title: "Registration",
            text: "Please register")
    }
    

    fileprivate var rkRegistrationStep: ORKRegistrationStep
    fileprivate var registration = UserRegistration()
    fileprivate var base = ChopRKTaskStepBase()
}

extension ChopResearchStudyRegistrationStep: ChopRKTaskStep {
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
        stepArray += [rkRegistrationStep]
    }
}

extension ChopResearchStudyRegistrationStep: ChopResearchStudyModuleStep {
    // MARK: ChopResearchStudyModuleStep
    
    var stepId: String { get { return rkRegistrationStep.identifier } }
    
}

extension ChopResearchStudyRegistrationStep: HasModuleStepDataToCapture {
    // MARK: HasModuleStepDataToCapture
    
    mutating func captureResult(fromORKTaskResult orkTaskResult: ORKTaskResult) {
        
        let orkStepResult = orkTaskResult.stepResult(forStepIdentifier: self.stepId)
        let rkResultsArray = ChopRKTextQuestionResultArray(with: orkStepResult?.results)

        registration.capture(from: rkResultsArray)
    }
}

extension ChopResearchStudyRegistrationStep: GeneratesWebRequestData {
    // MARK: GeneratesWebRequestData
    public var webId: String {
        get { return "" }
        set {  }
    }
    
    func populateWebRequestPostDictionary(dictionary: inout Dictionary<String, String>) {
        
        dictionary[ChopResearchStudyRegistrationStep.PID_EMAIL] = registration.email
        dictionary[ChopResearchStudyRegistrationStep.PID_PASSWORD] = registration.password
    }
    
}
