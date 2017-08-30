//
//  RedcapItemBase.swift
//  LongitudinalStudy1
//
//  Created by Ritter, Dean on 8/24/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation

struct RedcapItemBase {

    var coreAttributes = Dictionary<String, Any>()

    func attributeAsString(key: String) -> String {
        
        if coreAttributes.keys.contains(key) == false {
            return ""
        }
        
        return coreAttributes[key] as! String
    }
    
    func attributeAsInt(key: String) -> Int {

        if let valAsInt = coreAttributes[key] as? Int {
            return valAsInt
        }
        
        return Int.min
    }
}
