//
//  ChopRKTextQuestionResultArray.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 6/8/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

struct ChopRKResultArray {
    
    init(with results: [ORKResult]?) {
        rkResults = results
    }
    
    func extractTextQuestionResults(into destObject: inout Dictionary<String, String>) {
        
        for questionResult in rkResults! {
            
            let textQuestionResult = questionResult as! ORKTextQuestionResult
            
            destObject[textQuestionResult.identifier] = textQuestionResult.textAnswer!
        }
    }

    func extractSingleChoiceQuestionResult() -> Int {
        
        let answers = extractMultipleChoiceQuestionResults()
        
        return (answers.count > 0) ? answers[0] : -1
    }
    
    func extractMultipleChoiceQuestionResults() -> [Int] {
        
        var answers = [Int]()
        
        let result = rkResults?[0]
        let rkChoiceQuestionResult = result as! ORKChoiceQuestionResult
        
        var answer = 0
        guard let count = rkChoiceQuestionResult.choiceAnswers?.count else {
            return answers
        }
        
        for index in 0...(count - 1) {
            answer = rkChoiceQuestionResult.choiceAnswers?[index] as! Int!
            
            answers += [answer]
        }
        
        return answers
    }

    private var rkResults: [ORKResult]?
}

