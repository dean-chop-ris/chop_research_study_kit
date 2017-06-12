//
//  RedcapImportDataFormatter.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 5/19/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation

struct RedcapImportDataFormatter {
    
    init(forClient formatterClient: GeneratesWebRequestData) {
        
        self.client = formatterClient
    }
    
    func formatDateForSubmission(dateToFormat: Date) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "YYYY-MM-dd"
        
        return formatter.string(from: dateToFormat)
    }

    fileprivate var client: GeneratesWebRequestData
}

extension RedcapImportDataFormatter: FormatsDataForWebRequest {
    // MARK: FormatsDataForWebRequest
    func populateWebRequestPostDictionary(
        dictionary: inout Dictionary<String, String>,
        forChoices choices: [Int],
        withChosenIndeces values: [Int]) {
 
        var answerForChoice: Int
        
        for choice in choices {
            if values.contains(choice) {
                answerForChoice = 1
            } else {
                answerForChoice = 0
            }

            let redcapChoiceNumber = convertChoiceNumberToRedcapChoiceNumber(number: choice)
            let choiceWebId = client.webId + "___" + redcapChoiceNumber.description
            
            dictionary[choiceWebId] = answerForChoice.description
        }
        
        
    }
    
    func populateWebRequestPostDictionary(
        dictionary: inout Dictionary<String, String>,
        forChoices choices: [Int],
        withChosenIndex chosenIndex: Int) {
        
        if client is ChopMultipleChoiceQuestion {
            let mcqClient = client as! ChopMultipleChoiceQuestion
            
            if mcqClient.isMultipleAnswer {
                populateWebRequestPostDictionary(
                    dictionary: &dictionary,
                    forChoices: choices,
                    withChosenIndeces: [chosenIndex])
            }
        }
        
        let answerForChoice = choices[chosenIndex]
        let redcapChoiceNumber = convertChoiceNumberToRedcapChoiceNumber(number: answerForChoice)
        
        dictionary[client.webId] = redcapChoiceNumber.description
    }

    private func convertChoiceNumberToRedcapChoiceNumber(number numberToConvert: Int) -> Int {
        // Answers are array index (zero-based)
        // But REDCap records answers with a 1-based value
        // So here we add 1
        return numberToConvert + 1
    }
}
