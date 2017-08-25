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
        
        return coreAttributes[key] as! String
    }
    
    func attributeAsInt(key: String) -> Int {

        /*
        let attrAsStr = coreAttributes[key] as! String
        
        if attrAsStr.isEmpty {
            return Int.min
        }
        
        return Int(attrAsStr)!
        */
        return coreAttributes[key] as! Int
    }
}
