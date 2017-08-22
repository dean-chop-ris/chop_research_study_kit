//
//  ChopMatrixQuestion.swift
//  LongitudinalStudy1
//
//  Created by Ritter, Dean on 8/21/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

struct ChopMatrixQuestion {
    // A Matrix question is a group of questions that contain the same answer set, asked together. They appear in conventional questionaires as a matrix.
    
    // For example: Show your schedule for the week:
    //          Monday  Tuesday Wednesday   Thursday    Friday
    // Eat      Y/N     Y/N     Y/N         Y/N         Y/N
    // Gym      Y/N     Y/N     Y/N         Y/N         Y/N
    // Drink    Y/N     Y/N     Y/N         Y/N         Y/N
    //
    init(withStepID stepID: String,
         withWebId webId: String,
         withQuestion question: String,
         allowsMultipleAnswers isMultAnswers: Bool,
         withItems rows: [ChopMatrixQuestionRow],
         withQuestionChoices questionChoices: ChopItemSelectChoiceCollection) {

        choices = questionChoices
        base.web_Id = webId

        var formItem: ORKFormItem = ORKFormItem()
        var formItems = [ORKFormItem]()
        let rowAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(
            with:  isMultAnswers
                ? ORKChoiceAnswerStyle.multipleChoice
                : ORKChoiceAnswerStyle.singleChoice,
            textChoices: choices.rkTextChoices)

        for row in rows {
            
            formItem = ORKFormItem(identifier: row.item_Id,
                                   text: row.displayString,
                                   answerFormat: rowAnswerFormat)
            formItems += [formItem]
        }
        
        orkFormStep = ORKFormStep(identifier: stepID, title: "", text: question)
        orkFormStep.formItems = formItems
    }
    
    fileprivate var orkFormStep: ORKFormStep
    fileprivate var matrixItems = ChopItemSelectChoiceCollection()
    
    fileprivate var choices: ChopItemSelectChoiceCollection // All the possible choices for the user to choose from
    fileprivate var answers = [Int]() // The choices that the user actually chose
    fileprivate var base = ChopRKTaskStepBase()
}

extension ChopMatrixQuestion: ChopResearchStudyModuleStep {
    // MARK: ChopResearchStudyModuleStep
    var stepId: String { get { return orkFormStep.identifier } }
}

extension ChopMatrixQuestion: ChopRKTaskStep {
    // MARK: : ChopRKTaskStep
    var passcodeProtected: Bool {
        get {
            return self.base.passcodeProtected
        }
        set {
            self.base.passcodeProtected = newValue
        }
    }
    
    func populateRKStepArray(stepArray: inout [ORKStep]) {
        stepArray += [orkFormStep]
    }
}

extension ChopMatrixQuestion: HasModuleStepDataToCapture {
    // MARK: HasModuleStepDataToCapture
    
    mutating func captureResult(fromORKTaskResult orkTaskResult: ORKTaskResult) {

        let orkFormStepResult = orkTaskResult.stepResult(forStepIdentifier: orkFormStep.identifier)
        let formStepResults = orkFormStepResult?.results
        
        answers.removeAll()
        for orkNumericQuestionResult in formStepResults! {
            let numQuesResult = (orkNumericQuestionResult as! ORKNumericQuestionResult)
            
            answers.append((numQuesResult.numericAnswer?.intValue)!)
        }

    }
}

extension ChopMatrixQuestion: GeneratesWebRequestData {
    // MARK: GeneratesWebRequestData
    
    // Is this a cause for concern?
    public var webId: String {
        get { return "" }
        set {  }
    }
    
    func populateWebRequestPostDictionary(dictionary: inout Dictionary<String, String>) {
    }
}

