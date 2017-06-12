//
//  UserLogin.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 6/8/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation

struct UserLogin {

    var email: String {
        
        get { return loginInfo[UserLogin.KEY_Email]! }
    }
    
    var password: String {
        
        get { return loginInfo[UserLogin.KEY_Password]! }
    }

    mutating func capture(from results: ChopRKTextQuestionResultArray) {
        
        results.extract(into: &loginInfo)
    }

    private static let KEY_Password = "ORKLoginFormItemPassword"
    private static let KEY_Email = "ORKLoginFormItemEmail"

    fileprivate var loginInfo = Dictionary<String, String>()
}
