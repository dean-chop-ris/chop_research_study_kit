//
//  ChopRankingQuestion.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 5/12/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

struct ChopRankingQuestion: ChopSurveyQuestion {

    init(withStepID stepID: String,
         withQuestion question: String,
         withItems items_To_Rank: [ChopRankingItem]) {
        
        var formItem: ORKFormItem = ORKFormItem()
        var index = 0
        var formItems = [ORKFormItem]()
        
        for rankingItem in items_To_Rank {
            formItem = ORKFormItem(identifier: rankingItem.item_Id,
                                   text: NSLocalizedString(rankingItem.displayString, comment: ""),
                                   answerFormat: ORKAnswerFormat.integerAnswerFormat(withUnit: nil))
            formItem.placeholder = "Tap to enter rank"
            
            formItems += [formItem]
            
            index += 1
        }
        
        orkFormStep = ORKFormStep(identifier: stepID, title: "", text: question)
        
        orkFormStep.formItems = formItems
        self.itemsToRank = items_To_Rank
    }

    fileprivate var orkFormStep: ORKFormStep
    fileprivate var itemsToRank = [ChopRankingItem]()
    fileprivate var validation: ValidationInfo = ValidationInfo()
}


extension ChopRankingQuestion: ChopRKTaskStep {
    // MARK: : ChopRKTaskStep
    func populateRKStepArray(stepArray: inout [ORKStep]) {
        stepArray += [orkFormStep]
    }
}

extension ChopRankingQuestion: HasModuleStepDataToCapture {
    // MARK: HasModuleStepDataToCapture

    mutating func captureResult(fromORKTaskResult orkTaskResult: ORKTaskResult) {
        
        var answersToValidate = [Int?]()
        
        captureResult(fromORKTaskResult: orkTaskResult, andPutInto: &answersToValidate)
        
        updateRankingItemsWithAnswers(withAnswers: answersToValidate)
    }

    fileprivate func captureResult(fromORKTaskResult orkTaskResult: ORKTaskResult, andPutInto destArray: inout [Int?]) {
        
        let orkFormStepResult = orkTaskResult.stepResult(forStepIdentifier: orkFormStep.identifier)
        let formStepResults = orkFormStepResult?.results
        
        destArray.removeAll()
        for orkNumericQuestionResult in formStepResults! {
            let numQuesResult = (orkNumericQuestionResult as! ORKNumericQuestionResult)
            
            destArray += [numQuesResult.numericAnswer?.intValue]
        }
    }
    
    private mutating func updateRankingItemsWithAnswers(withAnswers answers: [Int?]) {
        
        var index = 0
        var newItemsToRank = [ChopRankingItem]()
        
        for item in itemsToRank {
            var newItemToRank = item
            if (answers[index] != nil) {
                newItemToRank.rank = answers[index]!
            }
            newItemsToRank += [newItemToRank]
            
            index += 1
        }
        itemsToRank = newItemsToRank
    }
    
}

extension ChopRankingQuestion: ChopResearchStudyModuleStep {
    // MARK: ChopResearchStudyModuleStep
    var stepId: String { get { return orkFormStep.identifier } }
}

extension ChopRankingQuestion: AbleToBeValidated {
    // MARK: : AbleToBeValidated
    var isAnswerValid: Bool {
        get
        {
            var errMsg: String = ""
            
            return areAnswersValid(dataToValidate: self.itemsToRank,
                                   errorMsg: &errMsg) }
    }
    
    var errorMessage: String { get { return validation.errMsg } }
    
    var bypassValidation: Bool {
        get { return validation.bypass_Validation }
        set { validation.bypass_Validation = newValue }
    }
    
    func isValid(givenResult result: ORKTaskResult, errorMessageToReturn: inout String) -> Bool
    {
        var answersToValidate = [Int?]()
        
        errorMessageToReturn = ""
        captureResult(fromORKTaskResult: result, andPutInto: &answersToValidate)
        
        return areAnswersValid(dataToValidate: answersToValidate,
                               errorMsg: &errorMessageToReturn)
    }
    

    private func areAnswersValid(dataToValidate arrayToValidate: [ChopRankingItem?], errorMsg: inout String) -> Bool {

        var ans = [Int]()
    
        for item in itemsToRank {
            ans += [item.rank]
        }
        
        return areAnswersValid(dataToValidate: ans, errorMsg: &errorMsg)
    }

    private func areAnswersValid(dataToValidate arrayToValidate: [Int?], errorMsg: inout String) -> Bool {
        
        if arrayToValidate.count != orkFormStep.formItems?.count {
            return false
        } else {
            for rank in 1...arrayToValidate.count {
                if arrayToValidate.first(where: { $0 == rank } ) == nil {
                    errorMsg = "There is a rank missing: \(rank)"
                    return false
                }
            }
        }
        return true
    }
    

}

extension ChopRankingQuestion: GeneratesWebRequestData {
    // MARK: GeneratesWebRequestData
    
    // Is this a cause for concern?
    public var webId: String {
        get { return "" }
        set {  }
    }
    
    func populateWebRequestPostDictionary(dictionary: inout Dictionary<String, String>) {
    }
}

