//
//  ChopRKTextQuestionResultArray.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 6/8/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

struct ChopRKTextQuestionResultArray {
    
    init(with results: [ORKResult]?) {
        rkResults = results
    }
    
    func extract(into destObject: inout Dictionary<String, String>) {
        
        for questionResult in rkResults! {
            
            let textQuestionResult = questionResult as! ORKTextQuestionResult
            
            destObject[textQuestionResult.identifier] = textQuestionResult.textAnswer!
        }
    }

    
    var rkResults: [ORKResult]?
}

