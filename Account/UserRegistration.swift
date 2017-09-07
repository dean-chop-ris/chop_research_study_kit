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
        
        return getInfo(key: UserRegistration.KEY_Email)
    }

    var password: String {
        
        return getInfo(key: UserRegistration.KEY_Password)
    }

    mutating func capture(from results: ChopRKResultArray) {
        
        results.extractTextQuestionResults(into: &registrationInfo)
    }
    
    private func getInfo(key: String) -> String {
    
        if registrationInfo.keys.contains(key) {
            return registrationInfo[key]!
        }
        return ""
    }
    
    private static let KEY_Password = "ORKRegistrationFormItemPassword"
    private static let KEY_Email = "ORKRegistrationFormItemEmail"
    
    fileprivate var registrationInfo = Dictionary<String, String>()
}

