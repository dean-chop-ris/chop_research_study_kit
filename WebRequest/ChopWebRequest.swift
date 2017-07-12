//
//  ChopWebRequest.swift
//  CHOP_RK
//
//  Created by Ritter, Dean on 5/11/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation


protocol ChopWebRequestSource {

    var destinationUrl: String { get }

    var headerParamsDictionary: Dictionary<String, String> { get } // A dictionary of JSON keys/values
    var payloadParamsDictionary: Dictionary<String, String> { get } // A dictionary of JSON keys/values
    
}

struct ChopWebRequest {
    
    init(withSource submissionSource: ChopWebRequestSource) {
        self.source = submissionSource
    }
    
    fileprivate var source: ChopWebRequestSource
}

extension ChopWebRequest: WebRequestSendable {
    // MARK: WebRequestSendable
    var destinationUrl: String
    {
        get
        {
            //return "https://redcap.chop.edu/api/"
            return source.destinationUrl
        }
    }

    func populateWebRequestParamsDictionary(dictionary: inout Dictionary<String, String>) {
        
        for kvp in source.headerParamsDictionary {
            
            dictionary[kvp.key] = kvp.value
        }
        
        
        dictionary["data"] = payload
    }
    
    var payload: String
    {
        get
        {
            let postDictionary = source.payloadParamsDictionary
            var jsonDataAsStr = ""
            
            let postArray = [postDictionary]
            
            do {
                guard let jsonData =  try JSONSerialization.data(
                    withJSONObject: postArray,
                    options: JSONSerialization.WritingOptions.prettyPrinted) as Data?
                    else {
                        print("error trying to convert data to JSON")
                        return ""
                }
                jsonDataAsStr = String(data: jsonData, encoding: String.Encoding.utf8)!
            } catch  {
                print("error trying to convert data to JSON")
                return ""
            }
            return jsonDataAsStr
        }
    }
}




