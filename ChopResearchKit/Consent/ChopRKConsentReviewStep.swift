//
//  ChopRKConsentReviewStep.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 5/25/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

struct ChopRKConsentReviewStep {
    
    init(withConsentDocument consentDocument: ChopRKConsentDocument) {
        let signature = consentDocument.signatures!.first!
        let reviewConsentStep = ORKConsentReviewStep(identifier: "ConsentReviewStep", signature: signature, in: consentDocument)
        
        reviewConsentStep.text = "Review Consent!"
        reviewConsentStep.reasonForConsent = "Consent to join study"

        rkStep = reviewConsentStep
    }
    
    fileprivate var rkStep: ORKStep
}
extension ChopRKConsentReviewStep: ChopRKTaskStep {
    // MARK: ChopRKTaskStep
    func populateRKStepArray(stepArray: inout [ORKStep]) {
        stepArray += [rkStep]
    }
}

extension ChopRKConsentReviewStep: ChopResearchStudyModuleStep {
    // MARK: ChopResearchStudyModuleStep
    var stepId: String { get { return rkStep.identifier } }
    
}
