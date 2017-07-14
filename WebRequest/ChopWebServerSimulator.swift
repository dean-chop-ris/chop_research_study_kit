//
//  ChopWebServerSimulator.swift
//  Test_AuthServer_1
//
//  Created by Ritter, Dean on 7/11/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation

struct ChopWebServerSimulator {

    var statusCode: Int = 200
    var paramsDictionary: Dictionary<String, String>
    
    var simulatedResponseHeaders: Dictionary<String, String> {
        get {
            var responseDictionary = Dictionary<String, String>()
            
            if let val = paramsDictionary[AccountManager.PID_REQUEST_TYPE] {

                switch (val) {
                    case ChopWebRequestType.Registration.rawValue:
                    responseDictionary = generateRegistrationResponse()
                    break
                case ChopWebRequestType.Login.rawValue:
                    responseDictionary = generateLoginResponse()
                    break
                case ChopWebRequestType.Confirmation.rawValue:
                    responseDictionary = generateVerificationResponse()
                    break
                default:
                    break
                }
            }
            
            return responseDictionary
        }
    }
    
    init(withParamsDictionary initParams: Dictionary<String, String>) {
        
        self.paramsDictionary = initParams
    }
    
    func generateRegistrationResponse() -> Dictionary<String, String> {
        
        var responseDictionary = Dictionary<String, String>()
    
        let requestResult = ChopWebRequestResponse.PV_SUCCESS
        //let requestResult = ChopWebRequestResponse.PV_ACCT_FOUND
        
        
        responseDictionary[AccountManager.PID_REQUEST_TYPE] = ChopWebRequestType.Registration.rawValue
        responseDictionary[ChopWebRequestResponse.PID_REQUEST_RESULT] = requestResult
        
        return responseDictionary
    }

    func generateLoginResponse() -> Dictionary<String, String> {
        
        var responseDictionary = Dictionary<String, String>()
        
        let requestResult = ChopWebRequestResponse.PV_SUCCESS
        //let requestResult = ChopWebRequestResponse.PV_ACCT_NOT_FOUND
        //let requestResult = ChopWebRequestResponse.PV_ACCT_NOT_CONFIRMED
        //let requestResult = ChopWebRequestResponse.PV_PASSWORD_INCORRECT
        
        
        responseDictionary[AccountManager.PID_REQUEST_TYPE] = ChopWebRequestType.Login.rawValue
        responseDictionary[ChopWebRequestResponse.PID_REQUEST_RESULT] = requestResult
        
        return responseDictionary
    }
    
    func generateVerificationResponse() -> Dictionary<String, String> {
        
        var responseDictionary = Dictionary<String, String>()
        
        let requestResult = ChopWebRequestResponse.PV_ACCT_CONFIRMED
        //let requestResult = ChopWebRequestResponse.PV_ACCT_NOT_CONFIRMED
        //let requestResult = ChopWebRequestResponse.PV_SUCCESS
        //let requestResult = ChopWebRequestResponse.PV_ACCT_NOT_FOUND
        
        responseDictionary[AccountManager.PID_REQUEST_TYPE] = ChopWebRequestType.Confirmation.rawValue
        responseDictionary[ChopWebRequestResponse.PID_REQUEST_RESULT] = requestResult
        
        return responseDictionary
    }

}
