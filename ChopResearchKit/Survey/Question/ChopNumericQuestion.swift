//
//  ChopNumericQuestion.swift
//  LongitudinalStudy1
//
//  Created by Ritter, Dean on 8/16/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

struct ChopNumericQuestion {
    
    var answer: Int {
        
        return _answer
    }

    init(withStepID stepIdentifier: String,
         withWebId webIdentifier: String,
         withTitle questionTitle: String,
         min: Int = Int.min,
         max: Int = Int.max) {
        
        base.web_Id = webIdentifier
        
        let answerFormat = ORKNumericAnswerFormat(style: ORKNumericAnswerStyle.integer)
        
        answerFormat.minimum = min as NSNumber
        answerFormat.maximum = max as NSNumber
        
        rkStep = ORKQuestionStep(identifier: stepIdentifier,
                                 title: questionTitle,
                                 answer: answerFormat)
    }


    fileprivate var _answer = 0
    fileprivate var rkStep: ORKQuestionStep
    fileprivate var base = ChopRKTaskStepBase()
}


extension ChopNumericQuestion: ChopRKTaskStep {
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

extension ChopNumericQuestion: ChopResearchStudyModuleStep {
    // MARK: ChopResearchStudyModuleStep
    var stepId: String { get { return rkStep.identifier } }
}

extension ChopNumericQuestion: AbleToBeValidated {
    // MARK: : AbleToBeValidated
    var errorMessage: String { get { return base.validation.errMsg } }
    var bypassValidation: Bool {
        get { return base.validation.bypass_Validation }
        set { base.validation.bypass_Validation = newValue }
    }
}

extension ChopNumericQuestion: HasModuleStepDataToCapture {
    // MARK: HasModuleStepDataToCapture
    
    mutating func captureResult(fromORKTaskResult orkTaskResult: ORKTaskResult) {

        captureResult(fromORKTaskResult: orkTaskResult, andPutInto: &_answer)
    }
    
    fileprivate func captureResult(fromORKTaskResult orkTaskResult: ORKTaskResult, andPutInto destNumber: inout Int ) {
        
        let orkStepResult = orkTaskResult.stepResult(forStepIdentifier: self.stepId)
        let orkTextQuestionResultArray = orkStepResult?.results
        if (orkTextQuestionResultArray != nil) {
            
            let firstResult = orkTextQuestionResultArray?[0]
            let rkNumberResult = firstResult as! ORKNumericQuestionResult
            let numericAnswer = rkNumberResult.numericAnswer as! Int
            
            destNumber = numericAnswer
        }
    }
    
}

extension ChopNumericQuestion: GeneratesWebRequestData {
    // MARK: GeneratesWebRequestData
    public var webId: String {
        get { return base.web_Id }
        set { base.web_Id = newValue }
    }
    
    func populateWebRequestPostDictionary(dictionary: inout Dictionary<String, String>) {
        
        if webId.isEmpty {
            return
        }
        dictionary[webId] = "\(answer)"
    }
}
