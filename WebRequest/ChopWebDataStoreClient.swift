//
//  ChopWebDataStoreProvider.swift
//  CHOP_RK
//
//  Created by Ritter, Dean on 5/11/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation

protocol ChopWebDataStoreClient {
    
    func populateWebRequestParamsDictionary(dictionary: inout Dictionary<String, String>)
    
}
