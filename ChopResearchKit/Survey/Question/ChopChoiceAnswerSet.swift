//
//  ChopChoiceAnswerSet.swift
//  CHOP_RK
//
//  Created by Ritter, Dean on 4/19/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation

struct ChopChoiceAnswerSet : HasChoiceAnswerSet {
    
    let answers: [String]
    
    init(answers: [String]) {
        self.answers = answers
    }
    
    func indexOfChoice(choice: String) -> Int {
        var index = 0
        
        for answer in answers {
            if answer == choice {
                return index
            }
            else {
                index += 1
            }
        }
        return -1
    }
}

protocol HasChoiceAnswerSet {
    
    var answers: [String] { get }
    
}
