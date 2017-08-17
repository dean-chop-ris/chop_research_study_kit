//
//  RedcapSurveyItemGenerationOptions.swift
//  LongitudinalStudy1
//
//  Created by Ritter, Dean on 8/15/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation


struct RedcapSurveyItemGenerationOptions {
    
    init() {
        
    }
    
    init(initOptions: RedcapSurveyItemGenerationOptions) {
        self.optionsDictionary = initOptions.optionsDictionary
    }

    var isRecordId: Bool {
        get {
            if let val = optionsDictionary["is_record_id"] {
                return Bool(val)!
            }
            return false
        }
        
        set {
            addOption(optionType: "is_record_id", optionValue: (String(newValue)))
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
