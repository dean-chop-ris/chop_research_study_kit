//
//  RedcapSelectChoiceParser.swift
//  LongitudinalStudy1
//
//  Created by Ritter, Dean on 8/21/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation

struct RedcapSelectChoiceParser {

    func parseSelectChoices(choicesAsStr: String) -> ChopItemSelectChoiceCollection {
        
        var selectChoices = ChopItemSelectChoiceCollection()
        let choicesArray = choicesAsStr.components(separatedBy: "|")
        
        for choiceStr in choicesArray {
            
            var selectChoice = ChopItemSelectChoice()
            
            if choiceStr.contains(",") {
                selectChoice.hasValue = true
                
                let choiceElementsArray = choiceStr.components(separatedBy: ",")
                selectChoice.value = Int(choiceElementsArray[0].trim())!
                selectChoice.description = choiceElementsArray[1].trim()
            } else {
                selectChoice.description = choiceStr
            }
            
            selectChoices.add(item: selectChoice)
        }
        return selectChoices
    }
}
