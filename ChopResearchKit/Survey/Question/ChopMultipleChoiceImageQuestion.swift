//
//  ChopMultipleChoiceImageQuestion.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 5/15/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

struct ChopMultipleChoiceImageQuestion {

    init(withStepID stepID: String,
         withQuestion question: String,
         allowsMultipleAnswers isMultAnswers: Bool,
         withAnswers answers: [(name: String, UIImage, Int)]) {
        
        let imageChoices : [ORKImageChoice] = answers.map {
            return ORKImageChoice(normalImage: $0.1, selectedImage: nil, text: $0.0, value: $0.0 as NSCoding & NSCopying & NSObjectProtocol)
        }
        let answerFormat : ORKImageChoiceAnswerFormat =
            ORKImageChoiceAnswerFormat.choiceAnswerFormat(with: imageChoices)
            
        rkStep = ORKQuestionStep(identifier: stepID, title: question, answer: answerFormat)
        
        _webId = ""
    }

    fileprivate var rkStep: ORKQuestionStep
    fileprivate var validation: ValidationInfo = ValidationInfo()
    fileprivate var _webId: String
    fileprivate var answer: Int = -1
    fileprivate var base = ChopRKTaskStepBase()
}

extension ChopMultipleChoiceImageQuestion: ChopRKTaskStep {
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

extension ChopMultipleChoiceImageQuestion: HasModuleStepDataToCapture {
    // MARK: HasModuleStepDataToCapture
    
    mutating func captureResult(fromORKTaskResult orkTaskResult: ORKTaskResult) {
        
        let orkStepResult = orkTaskResult.stepResult(forStepIdentifier: self.stepId)
        let resultArray = ChopRKResultArray(with: orkStepResult?.results)
        
        answer = resultArray.extractSingleChoiceQuestionResult()
    }
}

extension ChopMultipleChoiceImageQuestion: ChopResearchStudyModuleStep {
    // MARK: ChopResearchStudyModuleStep
    var stepId: String { get { return rkStep.identifier } }
}

extension ChopMultipleChoiceImageQuestion: AbleToBeValidated {
    // MARK: : AbleToBeValidated
    var isAnswerValid: Bool { get { return true } }
    var errorMessage: String { get { return validation.errMsg } }
    var bypassValidation: Bool {
        get { return validation.bypass_Validation }
        set { validation.bypass_Validation = newValue }
    }
    
    func isValid(givenResult result: ORKTaskResult, errorMessageToReturn: inout String) -> Bool { return true }
}

extension ChopMultipleChoiceImageQuestion: GeneratesWebRequestData {
    // MARK: GeneratesWebRequestData
    public var webId: String {
        get { return _webId }
        set { _webId = newValue }
    }
    
    func populateWebRequestPostDictionary(dictionary: inout Dictionary<String, String>) {
    }
}

