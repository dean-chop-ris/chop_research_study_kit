//
//  AbleToBeValidated.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 5/12/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

protocol AbleToBeValidated {
    
    var isAnswerValid: Bool { get }
    var errorMessage: String { get }
    var bypassValidation: Bool { get set }
    
    func isValid(givenResult result: ORKTaskResult, errorMessageToReturn: inout String) -> Bool
}

struct ValidationInfo {
    var errMsg: String
    var bypass_Validation: Bool

    init() {
        errMsg = ""
        bypass_Validation = false
    }
}
