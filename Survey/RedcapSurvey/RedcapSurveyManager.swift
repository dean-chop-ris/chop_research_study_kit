//
//  RedcapSurveyManager.swift
//  Test_RedcapSurvey_1
//
//  Created by Ritter, Dean on 7/20/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation


struct RedcapSurveyManager {

    var isLoaded: Bool {
        get { return items.isEmpty == false }
    }

    public private(set) var rkSurveyTask : ChopRKTask!
    
    mutating func extract(fromResponse response: ChopWebRequestResponse) {
        
        //items.loadFromJSON(data: response.data)
        
        
        
    }

    private var items = RedcapSurveyItemCollection()
}


extension RedcapSurveyManager: ChopWebRequestSource {
    // MARK: ChopWebRequestSource
    
    var destinationUrl: String
    {
        get
        {
            return "https://redcap.chop.edu/api/"
        }
    }
    
    var headerParamsDictionary: Dictionary<String, String> {
        
        get {
            var params = ChopWebRequestParameters()
            
            params.load(key: "token", value: "6888B142F5AC0578AB6F605E549E1C44")
            params.load(key: "content", value: "metadata")
            params.load(key: "format", value: "json")
            params.load(key: "returnFormat", value: "json")
            
//            params.load(key: "action", value: "import")
//            params.load(key: "type", value: "flat")
//            params.load(key: "overwriteBehavior", value: "overwrite")
            
            return params.postDictionary
        }
    }
    
    var payloadParamsDictionary: Dictionary<String, String> {  // A dictionary of JSON keys/values
        
        
        get {
            let params = ChopWebRequestParameters()
            
            return params.postDictionary
        }
    }

}
