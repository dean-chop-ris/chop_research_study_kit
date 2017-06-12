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

    static let SID_RegistrationStep: String = "RegistrationStep"

    init() {
        rkRegistrationStep = ORKRegistrationStep(
            identifier: ChopResearchStudyRegistrationStep.SID_RegistrationStep,
            title: "Registration",
            text: "Please register")
    }
    

    fileprivate var rkRegistrationStep: ORKRegistrationStep
    //fileprivate var registrationInfo = Dictionary<String, String>()
    fileprivate var registration = UserRegistration()
}

extension ChopResearchStudyRegistrationStep: ChopRKTaskStep {
    // MARK: ChopRKTaskStep
    
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
