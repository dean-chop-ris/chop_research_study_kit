//
//  ChopMatrixQuestionRow.swift
//  LongitudinalStudy1
//
//  Created by Ritter, Dean on 8/21/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

struct ChopMatrixQuestionRow {
    var item_Id: String
    var displayString: String
    
    init(withWebId webId: String, withItemId itemId: String, withDisplayString displayStr: String) {
        
        base.web_Id = webId
        self.item_Id = itemId
        self.displayString = displayStr

    }

    fileprivate var base = ChopRKTaskStepBase()
    fileprivate var choices = [ORKTextChoice]() // All the possible choices for the user to choose from
    fileprivate var _answers = [Int]() // The choices that the user actually chose
    private var _isMultipleAnswer = false
}
