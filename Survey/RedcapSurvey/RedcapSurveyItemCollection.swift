//
//  RedcapSurveyItemCollection.swift
//  Test_RedcapSurvey_1
//
//  Created by Ritter, Dean on 7/20/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation

struct RedcapSurveyItemCollection {
    
    var isEmpty: Bool {
        get { return items.count == 0 }
    }
    
    mutating func loadFromJSON(data: Dictionary<String, String>) {
        
    }
    
    private var items = [RedcapSurveyItem]()
}
