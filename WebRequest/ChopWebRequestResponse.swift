//
//  ChopWebRequestResponse.swift
//  Test_AuthServer_1
//
//  Created by Ritter, Dean on 7/7/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation


struct ChopWebRequestResponse {
    
    // Parameter ID's
    static let PID_REQUEST_RESULT = "request_result"
    
    // Parameter Values
    static let PV_SUCCESS = "success"
    static let PV_ACCT_FOUND = "account_found"
    static let PV_ACCT_NOT_FOUND = "account_not_found"
    static let PV_ACCT_CONFIRMED = "account_confirmed"
    static let PV_ACCT_NOT_CONFIRMED = "account_not_confirmed"
    static let PV_PASSWORD_INCORRECT = "password_incorrect"

    public private(set) var statusCode: Int

    public var isValid: Bool {
        get
        {
            return statusCode == 200
        }
    }

    public var success: Bool {
        get
        {
            if isValid == false {
                return false
            }
            
            if let val = self.requestResponseData.first?[ChopWebRequestResponse.PID_REQUEST_RESULT].debugDescription {
                return val == ChopWebRequestResponse.PV_SUCCESS
            }
 
            return false
        }
    }

    init(httpResponse: HTTPURLResponse, data: Data) {
        
        self.statusCode = httpResponse.statusCode

        parseJSON(data: data)
        
        print("----- HTTP RESPONSE -----------------")
        print("URL: " + (httpResponse.url?.absoluteString)!)
        print("Status Code: " + self.statusCode.description)

        let headers = httpResponse.allHeaderFields
        
        for header in headers {
            
            print("Header: \(header.key)\tValue: \(header.value)")
        }

        print("Body: ")
        print(self.requestResponseData)
        print("----- /HTTP RESPONSE ----------------")
    }

    init(usingSimulator simulator: ChopWebServerSimulator) {
        
        self.statusCode = simulator.statusCode
        self.requestResponseData += [simulator.simulatedResponseHeaders]
    }

    private mutating func parseJSON(data responseData: Data) {
        if parseData_singleDictionary(data: responseData) == false {
            
            if parseData_arrayOfDictionaries(data: responseData) == false {
                print("ChopWebRequestResponse: Parse response data failed")
            }
        }
    }

    func findResponseValue(key: String) -> String {

        var dictionary = self.requestResponseData.first
        
        return dictionary![key] as! String
    }

    
//    private mutating func parseJSON(data responseData: Data) {
//        do {
//            // first try to parse as a single dictionary
//            guard let singleDictionaryJsonResponseData = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
//                print("ChopWebRequestResponse: Parse single dictionary failed, trying array of dictionaries")
//            
//                // parse as array of dictionarries
//                guard let arrayOfDictionarysJsonResponseData = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [Dictionary<String,Any>] else {
//                    print("ChopWebRequestResponse: Error parsing response as array of dictionaries")
//                    return
//                }
//                self.data2 = arrayOfDictionarysJsonResponseData
//            }
//            self.data = singleDictionaryJsonResponseData as! Dictionary<String, String>
//            
//            //print("The JSON is: " + jsonDictionary.description)
//            
//        } catch  {
//            print("ChopWebRequestResponse: Error trying to convert data to JSON")
//            return
//        }
//    }

    private mutating func parseData_singleDictionary(data responseData: Data) -> Bool {
        
        do {
            print("ChopWebRequestResponse: Parse single dictionary")
            guard let singleDictionaryJsonResponseData = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
                print("ChopWebRequestResponse: Parse single dictionary failed")
                return false
            }
            self.requestResponseData += [singleDictionaryJsonResponseData as! Dictionary<String, String>]
            
            //print("The JSON is: " + jsonDictionary.description)
            
        } catch  {
            print("ChopWebRequestResponse: Error parsing single dictionary")
            return false
        }
        print("ChopWebRequestResponse: Parse single dictionary successful")
        return true
    }

    private mutating func parseData_arrayOfDictionaries(data responseData: Data) -> Bool {
        
        do {
            print("ChopWebRequestResponse: Parse array of dictionaries")
            guard let arrayOfDictionarysJsonResponseData = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [Dictionary<String,Any>] else {
                print("ChopWebRequestResponse: Error parsing response as array of dictionaries")
                return false
            }
            self.requestResponseData = arrayOfDictionarysJsonResponseData
            
            //print("The JSON is: " + jsonDictionary.description)
            
        } catch  {
            print("ChopWebRequestResponse: Error parsing array of dictionaries")
            return false
        }
        print("ChopWebRequestResponse: Parse array of dictionaries successful")
        return true
    }
    
    private var requestResponseData = [Dictionary<String,Any>]()
}
