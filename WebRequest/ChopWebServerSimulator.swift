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
    var request: ChopWebRequest?
    
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
                case ChopWebRequestType.LoginState.rawValue:
                    responseDictionary = generateLoginStateResponse()
                    break
                case ChopWebRequestType.Logout.rawValue:
                    responseDictionary = generateLogoutResponse()
                    break
                case ChopWebRequestType.Update.rawValue:
                    responseDictionary = generateUpdateResponse()
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
        responseDictionary[AccountManager.PID_REMOTE_DATA_STORE_ID] = "23C837A0-E9CE-4A25-81E6-EC21D5E26674"
        
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

    func generateLoginStateResponse() -> Dictionary<String, String> {
        var responseDictionary = Dictionary<String, String>()

        let requestResult = ChopWebRequestResponse.PV_LOGGED_IN
        //let requestResult = ChopWebRequestResponse.PV_NOT_LOGGED_IN
        //let requestResult = ChopWebRequestResponse.PV_ACCT_NOT_FOUND
        //let requestResult = ChopWebRequestResponse.PV_ACCT_NOT_CONFIRMED

        responseDictionary[AccountManager.PID_REQUEST_TYPE] = ChopWebRequestType.LoginState.rawValue
        responseDictionary[ChopWebRequestResponse.PID_REQUEST_RESULT] = requestResult
        
        return responseDictionary
    }
    
    func generateLogoutResponse() -> Dictionary<String, String> {
        var responseDictionary = Dictionary<String, String>()

        let requestResult = ChopWebRequestResponse.PV_SUCCESS
        //let requestResult = ChopWebRequestResponse.PV_NOT_LOGGED_IN
        //let requestResult = ChopWebRequestResponse.PV_ACCT_NOT_FOUND
        //let requestResult = ChopWebRequestResponse.PV_ACCT_NOT_CONFIRMED

        responseDictionary[AccountManager.PID_REQUEST_TYPE] = ChopWebRequestType.Logout.rawValue
        responseDictionary[ChopWebRequestResponse.PID_REQUEST_RESULT] = requestResult
        
        return responseDictionary
    }
    
    func generateUpdateResponse() -> Dictionary<String, String> {
        var responseDictionary = Dictionary<String, String>()

        let requestResult = ChopWebRequestResponse.PV_SUCCESS
        //let requestResult = ChopWebRequestResponse.PV_NOT_LOGGED_IN
        //let requestResult = ChopWebRequestResponse.PV_ACCT_NOT_FOUND
        //let requestResult = ChopWebRequestResponse.PV_ACCT_NOT_CONFIRMED

        responseDictionary[AccountManager.PID_REQUEST_TYPE] = ChopWebRequestType.Update.rawValue
        responseDictionary[ChopWebRequestResponse.PID_REQUEST_RESULT] = requestResult
        
        return responseDictionary
    }
}
