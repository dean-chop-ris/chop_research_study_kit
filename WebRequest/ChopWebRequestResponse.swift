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
    
    public var success: Bool {
        get
        {
            if statusCode != 200 {
                return false
            }
            
            if let val = data[ChopWebRequestResponse.PID_REQUEST_RESULT] {
                return val == ChopWebRequestResponse.PV_SUCCESS
            }
 
            return false
        }
    }

    public private(set) var data = Dictionary<String, String>()
    
    init(httpResponse: HTTPURLResponse, data: Data) {
        
        self.statusCode = httpResponse.statusCode

        parseJSON(data: data)
        
        print("----- HTTP RESPONSE -----------------")
        print("URL: " + (httpResponse.url?.absoluteString)!)
        print("Status Code: " + self.statusCode.description)
        print("Body: ")
        print(self.data)
        print("----- /HTTP RESPONSE ----------------")
    }

    init(usingSimulator simulator: ChopWebServerSimulator) {
        
        self.statusCode = simulator.statusCode
        self.data = simulator.simulatedResponseHeaders
    }
    
    func process() {
        
    }

    private mutating func parseJSON(data responseData: Data) {
        do {
            guard let jsonDictionary = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
                print("Error converting data to JSON")
                return
            }
            
            //print("The JSON is: " + jsonDictionary.description)
            self.data = jsonDictionary as! Dictionary<String, String>
            
        } catch  {
            print("Error trying to convert data to JSON")
            return
        }
    }

    private var statusCode: Int
}
