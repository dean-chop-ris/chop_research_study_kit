//
//  UserRegistration.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 6/8/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation

struct UserRegistration {

    var email: String {
        
        get { return registrationInfo[UserRegistration.KEY_Email]! }
    }

    var password: String {
        
        get { return registrationInfo[UserRegistration.KEY_Password]! }
    }

    mutating func capture(from results: ChopRKResultArray) {
        
        results.extractTextQuestionResults(into: &registrationInfo)
    }
    
    private static let KEY_Password = "ORKRegistrationFormItemPassword"
    private static let KEY_Email = "ORKRegistrationFormItemEmail"
    
    fileprivate var registrationInfo = Dictionary<String, String>()
}

