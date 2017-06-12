//
//  FormatsDataForWebRequest.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 5/19/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation


protocol FormatsDataForWebRequest {
 
    func populateWebRequestPostDictionary(
        dictionary: inout Dictionary<String, String>,
        forChoices: [Int],
        withChosenIndeces: [Int])

    func populateWebRequestPostDictionary(
        dictionary: inout Dictionary<String, String>,
        forChoices: [Int],
        withChosenIndex: Int)

}
