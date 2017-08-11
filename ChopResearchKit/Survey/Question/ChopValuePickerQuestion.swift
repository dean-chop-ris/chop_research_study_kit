//
//  ChopValuePickerQuestion.swift
//
//  Created by Ritter, Dean on 8/7/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

struct ChopValuePickerQuestion {
    
    init(withStepID stepID: String,
         withWebId webId: String,
         withQuestion question: String,
         withAnswers answers: [String]) {

        
        var choiceNumber = 0
        
        for answer in answers {
            choices.append(ORKTextChoice(text: answer,
                                         value: choiceNumber as NSCoding & NSCopying & NSObjectProtocol))
            choiceNumber += 1
        }

        
        let answerFormat: ORKValuePickerAnswerFormat = ORKValuePickerAnswerFormat(textChoices: choices)
        
        rkStep = ORKQuestionStep(identifier: stepID,
                                 title: question,
                                 answer: answerFormat)
        base.web_Id = webId
    }

    fileprivate var choices = [ORKTextChoice]() // All the possible choices for the user to choose from
    fileprivate var rkStep: ORKStep
    fileprivate var answer: Int = -1 // The choice that the user actually chose
    fileprivate var base = ChopRKTaskStepBase()
}

extension ChopValuePickerQuestion: HasModuleStepDataToCapture {
    // MARK: HasModuleStepDataToCapture
    mutating func captureResult(fromORKTaskResult orkTaskResult: ORKTaskResult) {

        let orkStepResult = orkTaskResult.stepResult(forStepIdentifier: rkStep.identifier)
        let resultArray = ChopRKResultArray(with: orkStepResult?.results)
        
        answer = resultArray.extractSingleChoiceQuestionResult()
    }
}


extension ChopValuePickerQuestion: ChopRKTaskStep {
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


extension ChopValuePickerQuestion: ChopResearchStudyModuleStep {
    // MARK: ChopResearchStudyModuleStep
    var stepId: String { get { return rkStep.identifier } }
    
}


extension ChopValuePickerQuestion: GeneratesWebRequestData {
    // MARK: GeneratesWebRequestData
    public var webId: String {
        get { return base.web_Id }
        set { base.web_Id = newValue }
    }
    
    func populateWebRequestPostDictionary(dictionary: inout Dictionary<String, String>) {
        var choicesAsInts = [Int]()
        
        for choice in choices {
            choicesAsInts += [(choice.value as! Int)]
        }
        
        let formatter = RedcapImportDataFormatter(forClient: self)
        
        formatter.populateWebRequestPostDictionary(
            dictionary: &dictionary,
            forChoices: choicesAsInts,
            withChosenIndex: 0)
    }
}






















