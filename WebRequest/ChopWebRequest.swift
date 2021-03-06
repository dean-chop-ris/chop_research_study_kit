//
//  ChopWebRequest.swift
//  CHOP_RK
//
//  Created by Ritter, Dean on 5/11/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation

struct ChopWebRequest {
    
    var destinationUrl: String
    {
        get
        {
            return source.destinationUrl
        }
    }
    
    var requestType: String
    {/*
        let paramId = AccountManager.PID_REQUEST_TYPE
        guard let rType = paramsDictionary[paramId] else {
            print("ChopWebRequest: Unable to find param: \(paramId)")
            return ""
        }
        
        return rType */
        return headerValue(paramId: AccountManager.PID_REQUEST_TYPE)
    }
    
    func headerValue(paramId: String) -> String {
        
        guard let headerValue = paramsDictionary[paramId] else {
            print("ChopWebRequest: Unable to find param: \(paramId)")
            return ""
        }
        
        return headerValue
    }
    
    func payloadValue(paramId: String) -> String {
        
        guard let payloadValue = source.payloadParamsDictionary[paramId] else {
            print("ChopWebRequest: Unable to find param: \(paramId)")
            return ""
        }
        
        return payloadValue 
    }

    public private(set) var paramsDictionary = Dictionary<String, String>()
    
    var urlRequest: URLRequest? {
    
        get
        {
            guard let url = URL(string: self.destinationUrl) else {
                print("Error: cannot create URL: " + self.destinationUrl)
                return nil
            }
            
            // create params string to be included in request
            var params = ""
            for kvp in paramsDictionary {
                if params.lengthOfBytes(using: String.Encoding.ascii) > 0 {
                    params += "&"
                }
                params += "\(kvp.key)=\(kvp.value)"
            }
            
            // set up request
            var urlRequest = URLRequest(url: url)
            
            let body = NSMutableData()
            
            body.append(params.data(using: String.Encoding.utf8)!)
            
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = body as Data
            
            print("----- HTTP REQUEST -----------------")
            print("URL: " + url.absoluteString)
            print("Method: " + urlRequest.httpMethod!)
            print("Body: ")
            print(params)
            print("----- /HTTP REQUEST ----------------")
            
            return urlRequest
        }
    }
    
    init(withSource submissionSource: ChopWebRequestSource) {
        self.source = submissionSource
        
        // set up dictionary of JSON parameters to be included in the web request
        self.populateWebRequestParamsDictionary(dictionary: &paramsDictionary)
    }
    

    private func populateWebRequestParamsDictionary(dictionary: inout Dictionary<String, String>) {
        
        for kvp in source.headerParamsDictionary {
            
            dictionary[kvp.key] = kvp.value
        }

        let postDictionary = source.payloadParamsDictionary
        
        if postDictionary.count > 0 {
            var payload = ""
        
            let postArray = [postDictionary]
        
            do {
                guard let jsonData =  try JSONSerialization.data(
                    withJSONObject: postArray,
                    options: JSONSerialization.WritingOptions.prettyPrinted) as Data?
                else {
                    print("ChopWebRequest: Error converting data to JSON")
                    return
                }
                payload = String(data: jsonData, encoding: String.Encoding.utf8)!
                } catch  {
                    print("ChopWebRequest: Error trying to convert data to JSON")
                    return
            }

            dictionary["data"] = payload
        }
    }

    fileprivate var source: ChopWebRequestSource
}


protocol ChopWebRequestSource {
    
    var destinationUrl: String { get }
    
    var headerParamsDictionary: Dictionary<String, String> { get } // A dictionary of JSON keys/values
    var payloadParamsDictionary: Dictionary<String, String> { get } // A dictionary of JSON keys/values
    
}

extension ChopWebRequestSource {
    
    var payloadParamsDictionary: Dictionary<String, String> {  // A dictionary of JSON keys/values
        
        get {
            let params = ChopWebRequestParameters()
            
            return params.postDictionary
        }
    }

}

