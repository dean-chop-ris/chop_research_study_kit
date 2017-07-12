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
    static let PV_ACCT_NOT_CONFIRMED = "account_not_confirmed"
    static let PV_PASSWORD_INCORRECT = "password_incorrect"
    
    public var success: Bool {
        get
        {
            if statusCode != 200 {
                return false
            }
            
            if let val = headerFields[ChopWebRequestResponse.PID_REQUEST_RESULT] {
                return val == ChopWebRequestResponse.PV_SUCCESS
            }
 
            return false
        }
    }

    public var hasUserMessage: Bool {
        get { return !userMessage.isEmpty }
    }
        
    public var userMessage: String {
        
        get {
            return _userMessage.message(forResponseHeaders: self.headerFields)
        }
    }

    public var userMessageTitle: String {
        
        get {
            return _userMessage.title(forResponseHeaders: self.headerFields)
        }
    }

    public private(set) var headerFields = Dictionary<String, String>()
    
    init(httpResponse: HTTPURLResponse) {
        
        self.statusCode = httpResponse.statusCode

        // Headers
        let headers = httpResponse.allHeaderFields
         
        for header in headers {
            self.headerFields[header.key as! String] = self.headerFields[header.value as! String]
        }
    }

    init(usingSimulator simulator: ChopWebServerSimulator) {
        
        self.statusCode = simulator.statusCode
        self.headerFields = simulator.simulatedResponseHeaders
    }
    
    func process() {
        
    }

    private var statusCode: Int
    private var _userMessage = ChopWebRequestResponseUserMessage()
}
