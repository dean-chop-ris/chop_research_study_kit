//
//  ChopResearchStudyModuleOptions.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 6/1/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation

enum LoginMode: String {
    case Registration = "Registration"
    case Verification = "Verification"
    case Login = "Login"
    case None = "None"
}

struct ChopResearchStudyModuleOptions {
    
    var loginMode: LoginMode {
        get {
            if let val = optionsDictionary["Login_Mode"] {
                return LoginMode(rawValue: val)!
            }
            return LoginMode.None
        }
        
        set {
            addOption(optionType: "Login_Mode", optionValue: (newValue.rawValue))
        }
    }
    
    mutating func addOption(optionType: String, optionValue: String) {
        optionsDictionary[optionType] = optionValue
    }
    
    private var optionsDictionary = Dictionary<String,String>()
}
