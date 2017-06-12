//
//  ChopMultipleChoiceQuestion.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 5/12/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

struct ChopMultipleChoiceQuestion {
   
    public var isMultipleAnswer: Bool { get { return _isMultipleAnswer } }
    public var answers: [Int] { get { return _answers } }
    
    init(withStepID stepID: String,
         withWebId webId: String,
         withQuestion question: String,
         allowsMultipleAnswers isMultAnswers: Bool,
         withAnswers answers: [String]) {
        var choiceNumber = 0
        
        for answer in answers {
            choices.append(ORKTextChoice(text: answer,
                                         value: choiceNumber as NSCoding & NSCopying & NSObjectProtocol))
            choiceNumber += 1
        }
        
        let answerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(
            with: (isMultAnswers) ? .multipleChoice : .singleChoice,
            textChoices: choices)
        rkStep = ORKQuestionStep(identifier: stepID,
                                 title: question,
                                 answer: answerFormat)
        _webId = webId
        self._isMultipleAnswer = isMultAnswers
        // The formatter needs to be initialized with self, but
        // at this point self is not yet initialized
    }

    fileprivate var rkStep: ORKStep
    fileprivate var validation: ValidationInfo = ValidationInfo()
    fileprivate var _webId: String
    fileprivate var choices = [ORKTextChoice]() // All the possible choices for the user to choose from
    fileprivate var _answers = [Int]() // The choices that the user actually chose
    private var _isMultipleAnswer: Bool
}

extension ChopMultipleChoiceQuestion: HasModuleStepDataToCapture {
    // MARK: HasModuleStepDataToCapture
    mutating func captureResult(fromORKTaskResult orkTaskResult: ORKTaskResult) {

        let orkStepResult = orkTaskResult.stepResult(forStepIdentifier: rkStep.identifier)
        let questionResult = orkStepResult?.results /* ORKChoiceQuestionResult [] */
        let result = questionResult?[0]
        let result1 = result as! ORKChoiceQuestionResult
        
        var answer = 0
        guard let count = result1.choiceAnswers?.count else { return }
        for index in 0...(count - 1) {
            answer = result1.choiceAnswers?[index] as! Int!
            
            _answers += [answer]
        }
    }

}

extension ChopMultipleChoiceQuestion: ChopRKTaskStep {
    // MARK: ChopRKTaskStep
    func populateRKStepArray(stepArray: inout [ORKStep]) {
        stepArray += [rkStep]
    }
}

extension ChopMultipleChoiceQuestion: ChopResearchStudyModuleStep {
    // MARK: ChopResearchStudyModuleStep
    var stepId: String { get { return rkStep.identifier } }
    
}

extension ChopMultipleChoiceQuestion: AbleToBeValidated {
    // MARK: : AbleToBeValidated
    var isAnswerValid: Bool { get { return true } }
    var errorMessage: String { get { return validation.errMsg } }
    var bypassValidation: Bool {
        get { return validation.bypass_Validation }
        set { validation.bypass_Validation = newValue }
    }
    
    func isValid(givenResult result: ORKTaskResult, errorMessageToReturn: inout String) -> Bool { return true }
}

extension ChopMultipleChoiceQuestion: GeneratesWebRequestData {
    // MARK: GeneratesWebRequestData
    public var webId: String {
        get { return _webId }
        set { _webId = newValue }
    }
    
    func populateWebRequestPostDictionary(dictionary: inout Dictionary<String, String>) {
        var choicesAsInts = [Int]()
        
        for choice in choices {
            choicesAsInts += [(choice.value as! Int)]
        }

        let formatter = RedcapImportDataFormatter(forClient: self)

        if isMultipleAnswer {
            formatter.populateWebRequestPostDictionary(
                    dictionary: &dictionary,
                    forChoices: choicesAsInts,
                    withChosenIndeces: answers)
        } else {
            formatter.populateWebRequestPostDictionary(
                    dictionary: &dictionary,
                    forChoices: choicesAsInts,
                    withChosenIndex: 0)
        }
    }
}
