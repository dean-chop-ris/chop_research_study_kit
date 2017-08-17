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

enum PasscodeMode: String {
    case Creation = "PasscodeCreation"
    case Enforcement = "PasscodeEnforcement"
    case Edit = "EditPasscode"
    case None = "None"
}

struct ChopResearchStudyModuleOptions {
    
    init() {
        
    }
    
    init(initOptions: ChopResearchStudyModuleOptions) {
        self.optionsDictionary = initOptions.optionsDictionary
    }
    
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

    var includePasscode: Bool {
        get {
            if let val = optionsDictionary["Include_Passcode"] {
                return Bool(val)!
            }
            return false
        }
        
        set {
            addOption(optionType: "Include_Passcode", optionValue: (String(newValue)))
        }
    }

    var passcodeMode: PasscodeMode {
        get {
            if let val = optionsDictionary["Passcode_Mode"] {
                return PasscodeMode(rawValue: val)!
            }
            return PasscodeMode.None
        }
        
        set {
            addOption(optionType: "Passcode_Mode", optionValue: (newValue.rawValue))
        }
    }

    func option(optionType: String) -> String {
        
        if let val = optionsDictionary[optionType] {
            return val
        }
        return ""
    }

    mutating func addOption(optionType: String, optionValue: String) {
        optionsDictionary[optionType] = optionValue
    }
    
    private var optionsDictionary = Dictionary<String,String>()
}
