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

        rkConsentReviewStep = reviewConsentStep
    }
    
    fileprivate var rkConsentReviewStep: ORKConsentReviewStep
    fileprivate var result = ChopResearchStudyConsent()
    fileprivate var base = ChopRKTaskStepBase()
}

extension ChopRKConsentReviewStep: ChopRKTaskStep {
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
        stepArray += [rkConsentReviewStep]
    }
}

extension ChopRKConsentReviewStep: ChopResearchStudyModuleStep {
    // MARK: ChopResearchStudyModuleStep
    var stepId: String { get { return rkConsentReviewStep.identifier } }
    
}

extension ChopRKConsentReviewStep: HasModuleStepDataToCapture {
    //MARK: HasModuleStepDataToCapture
    mutating func captureResult(fromORKTaskResult taskResult: ORKTaskResult) {
        
        if let stepResult = taskResult.stepResult(forStepIdentifier: stepId),
           let signatureResult = stepResult.results?.first as? ORKConsentSignatureResult {
            
            result.load(resultToLoad: signatureResult)
        }
    }
    
}
