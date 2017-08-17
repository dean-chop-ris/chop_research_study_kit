//
//  ChopEmailQuestion.swift
//  LongitudinalStudy1
//
//  Created by Ritter, Dean on 8/16/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

struct ChopEmailQuestion {
    
    var answer: String {
        
        return _answer
    }
    
    init(withStepID stepID: String,
         withWebId webIdentifier: String,
         withTitle title: String) {
        
        let answerFormat = ORKEmailAnswerFormat()
        
        rkStep = ORKQuestionStep(identifier: stepID, title: title, answer: answerFormat)
        
        base.web_Id = webIdentifier
    }
    
    fileprivate var _answer = ""
    fileprivate var rkStep: ORKStep
    fileprivate var base = ChopRKTaskStepBase()
}

extension ChopEmailQuestion: ChopRKTaskStep {
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
        stepArray += [rkStep]
    }
}

extension ChopEmailQuestion: ChopResearchStudyModuleStep {
    // MARK: ChopResearchStudyModuleStep
    var stepId: String { get { return rkStep.identifier } }
}

extension ChopEmailQuestion: AbleToBeValidated {
    // MARK: : AbleToBeValidated
    var errorMessage: String { get { return base.validation.errMsg } }
    var bypassValidation: Bool {
        get { return base.validation.bypass_Validation }
        set { base.validation.bypass_Validation = newValue }
    }
}

extension ChopEmailQuestion: HasModuleStepDataToCapture {
    // MARK: HasModuleStepDataToCapture
    
    mutating func captureResult(fromORKTaskResult orkTaskResult: ORKTaskResult) {
        
        let orkStepResult = orkTaskResult.stepResult(forStepIdentifier: self.stepId)
        let orkTextQuestionResultArray = orkStepResult?.results
        if (orkTextQuestionResultArray != nil) {
            
            let firstResult = orkTextQuestionResultArray?[0]
            let rkTextResult = firstResult as! ORKTextQuestionResult
            
            _answer = rkTextResult.textAnswer! as String
        }
    }
    
}

extension ChopEmailQuestion: GeneratesWebRequestData {
    // MARK: GeneratesWebRequestData
    public var webId: String {
        get { return base.web_Id }
        set { base.web_Id = newValue }
    }
    
    func populateWebRequestPostDictionary(dictionary: inout Dictionary<String, String>) {
        
        if webId.isEmpty {
            return
        }
        dictionary[webId] = answer
    }
}
