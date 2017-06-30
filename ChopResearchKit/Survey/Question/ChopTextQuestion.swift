//
//  ChopTextQuestion.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 5/12/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

struct ChopTextQuestion {
    
    var answer: String
    
    init(withStepID stepID: String,
         withWebId webIdentifier: String,
         withTitle title: String) {
        
        let answerFormat = ORKTextAnswerFormat(maximumLength: 20)
        
        answerFormat.multipleLines = true
        
        rkStep = ORKQuestionStep(identifier: stepID, title: title, answer: answerFormat)
        
        answer = ""
        self.web_Id = webIdentifier
    }
    
    fileprivate var rkStep: ORKStep
    fileprivate var validation: ValidationInfo = ValidationInfo()
    fileprivate var web_Id: String = ""
    fileprivate var base = ChopRKTaskStepBase()
}


extension ChopTextQuestion: ChopRKTaskStep {
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

extension ChopTextQuestion: ChopResearchStudyModuleStep {
    // MARK: ChopResearchStudyModuleStep
    var stepId: String { get { return rkStep.identifier } }
}

extension ChopTextQuestion: AbleToBeValidated {
    // MARK: : AbleToBeValidated
    var isAnswerValid: Bool { get { return true } }
    var errorMessage: String { get { return validation.errMsg } }
    var bypassValidation: Bool {
        get { return validation.bypass_Validation }
        set { validation.bypass_Validation = newValue }
    }
    
    func isValid(givenResult result: ORKTaskResult, errorMessageToReturn: inout String) -> Bool { return true }
}

extension ChopTextQuestion: HasModuleStepDataToCapture {
    // MARK: HasModuleStepDataToCapture
    
    mutating func captureResult(fromORKTaskResult orkTaskResult: ORKTaskResult) {
        
        let orkStepResult = orkTaskResult.stepResult(forStepIdentifier: self.stepId)
        let orkTextQuestionResultArray = orkStepResult?.results
        if (orkTextQuestionResultArray != nil) {
            
            let result1 = orkTextQuestionResultArray?[0]
            let result1Str = result1 as! ORKTextQuestionResult
            answer = result1Str.textAnswer! as String
        }
    }
    
}

extension ChopTextQuestion: GeneratesWebRequestData {
    // MARK: GeneratesWebRequestData
    public var webId: String {
        get { return web_Id }
        set { web_Id = newValue }
    }
    
    func populateWebRequestPostDictionary(dictionary: inout Dictionary<String, String>) {
        
        if webId.lengthOfBytes(using: String.Encoding.ascii) == 0 {
            return
        }
        dictionary[webId] = answer
    }
}

