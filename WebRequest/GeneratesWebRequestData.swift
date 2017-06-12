//
//  GeneratesStudyData.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 5/12/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation

protocol GeneratesWebRequestData {
    
    var webId: String { get }
    func populateWebRequestPostDictionary(dictionary: inout Dictionary<String, String>)
}

