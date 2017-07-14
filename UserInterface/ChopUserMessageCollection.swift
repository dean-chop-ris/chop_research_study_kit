//
//  ChopUserMessageCollection.swift
//  Test_Workflow_1
//
//  Created by Ritter, Dean on 7/14/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation

struct ChopUserMessageCollection {
    
    mutating func add(webRequestResponse: String, title: String, message: String) {
        
        items += [ChopUserMessageItem(webRequestResponse: webRequestResponse, title: title, message: message)]
    }
    
    func getUserText(webRequestResponse: String, title: inout String, message: inout String ) -> Bool {
    
        for item in items {
            if webRequestResponse == item.webRequestResponse {
                title = item.title
                message = item.message
                return true
            }
        }
        return false
    }
    
    var items = [ChopUserMessageItem]()
}


struct ChopUserMessageItem {
    
    
    var webRequestResponse: String
    var title: String
    var message: String
}
