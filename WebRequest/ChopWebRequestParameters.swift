//
//  ChopWebRequestParameters.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 6/12/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation


struct ChopWebRequestParameters {
    
    public private(set) var postDictionary = Dictionary<String, String>()

    mutating func load(key: String, value: String) {
        
        postDictionary[key] = value
    }

    mutating func load(moduleSteps: ChopModuleStepCollection) {
    
        for step in moduleSteps {
            if step is GeneratesWebRequestData {
                let dataStep = step as! GeneratesWebRequestData
                
                dataStep.populateWebRequestPostDictionary(dictionary: &postDictionary);
            }
        }
    }
    
}
