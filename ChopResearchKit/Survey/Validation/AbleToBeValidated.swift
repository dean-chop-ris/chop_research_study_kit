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

    // Local Validation: Validation done within this data structure.
    // This does not include validation done internally by ResearchKit
    
    // Indicates if there is actually local validation on this step
    // Must be true for local validation to occur
    var validationActive: Bool { get }

    // Indicates if local validation is to be ignored
    var bypassValidation: Bool { get set }
    
    func isValid(givenResult result: ORKTaskResult, errorMessageToReturn: inout String) -> Bool
}

extension AbleToBeValidated {
    
    var isAnswerValid: Bool { get { return true } }
    var errorMessage: String { get { return "" } }

    var validationActive: Bool { return false }
    var bypassValidation: Bool { get { return true } set {} }
    
    func isValid(givenResult result: ORKTaskResult, errorMessageToReturn: inout String) -> Bool {
        return true
    }
}


struct ValidationInfo {
    var errMsg = ""
    var bypass_Validation = false
}
