//
//  ChopRKVisualConsentStep.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 5/25/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

struct ChopRKVisualConsentStep {
    
    init(withDocument consentDocument: ChopRKConsentDocument) {
        
        let visualConsentStep = ORKVisualConsentStep(identifier: "VisualConsentStep", document: consentDocument)

        rkStep = visualConsentStep
    }
    
    fileprivate var rkStep: ORKStep
    fileprivate var base = ChopRKTaskStepBase()
}

extension ChopRKVisualConsentStep: ChopRKTaskStep {
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
        stepArray += [rkStep]
    }
}

extension ChopRKVisualConsentStep: ChopResearchStudyModuleStep {
    // MARK: ChopResearchStudyModuleStep
    var stepId: String { get { return rkStep.identifier } }
    
}
