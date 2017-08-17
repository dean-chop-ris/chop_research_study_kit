//
//  RedcapStudyManager.swift
//  LongitudinalStudy1
//
//  Created by Ritter, Dean on 8/11/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import UIKit

struct RedcapStudyManager {
    
    var isLoaded: Bool {
        get { return items.isEmpty == false }
    }

    public private(set) var redcapToken: String

    init(token: String) {
        
        redcapToken = token
    }
    
    func createLoaderViewController(delegate: ChopResearchStudy) -> UIViewController {
        
        let loaderViewController = RedcapSurveyLoaderViewController()
            
        loaderViewController.requestor = self
            
        return loaderViewController
    }
    
    mutating func load(options: Int, onCompletion: @escaping LoadRequestResponse) {
        
        // send web request to get survey info
        let request = ChopWebRequest(withSource: self)
        let broker = ChopWebRequestBroker()
        
        broker.send(request: request, onCompletion: { (response, error) in
            
                onCompletion(response, error)
            }
        )
    }
    
    func createRedcapSurveyManager(instrumentName: String) -> RedcapSurveyManager {
     
        var mgr = RedcapSurveyManager(
            token: redcapToken,
            redcapInstrumentName: instrumentName)
        
        mgr.load(redcapItems: items)
        
        return mgr
    }

    mutating func extract(fromResponse response: ChopWebRequestResponse) {
        
        items.loadFromJSON(data: response.data)
    }
    
    fileprivate var items = RedcapSurveyItemCollection()
}


extension RedcapStudyManager: ChopWebRequestSource {
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
            
            params.load(key: "token", value: redcapToken)
            params.load(key: "content", value: "metadata")
            params.load(key: "format", value: "json")
            params.load(key: "returnFormat", value: "json")
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

extension RedcapStudyManager: RedcapItemsProvider {
    // MARK: RedcapItemsProvider
    
    var redcapItems: RedcapSurveyItemCollection {
        
        return items
    }
    
}
