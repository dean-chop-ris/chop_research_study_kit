//
//  ChopWorkflowActionOptions.swift
//  LongitudinalStudy1
//
//  Created by Ritter, Dean on 9/13/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation

struct ChopWorkflowActionOptions {
    
    init() {
        
    }
    
    init(initOptions: ChopWorkflowActionOptions) {
        self.optionsDictionary = initOptions.optionsDictionary
    }
    
    func hasOptionType(_ optionType: String) -> Bool {
        
        return optionsDictionary.keys.contains(optionType)
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
