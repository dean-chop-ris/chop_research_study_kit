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
}

extension ChopRKVisualConsentStep: ChopRKTaskStep {
    // MARK: ChopRKTaskStep
    func populateRKStepArray(stepArray: inout [ORKStep]) {
        stepArray += [rkStep]
    }
}

extension ChopRKVisualConsentStep: ChopResearchStudyModuleStep {
    // MARK: ChopResearchStudyModuleStep
    var stepId: String { get { return rkStep.identifier } }
    
}
