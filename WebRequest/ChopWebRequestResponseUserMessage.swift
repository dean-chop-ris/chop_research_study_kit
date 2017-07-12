//
//  ChopWebRequestResponseUserMessage.swift
//  Test_AuthServer_1
//
//  Created by Ritter, Dean on 7/12/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation

struct ChopWebRequestResponseUserMessage {

    func message(forResponseHeaders responseHeaders: Dictionary<String, String>) -> String {
        var title = ""
        var msg = ""
        
        getText(forResponseHeaders: responseHeaders, title: &title, msg: &msg)
        
        return msg
    }
    
    func title(forResponseHeaders responseHeaders: Dictionary<String, String>) -> String {
        var title = ""
        var msg = ""
        
        getText(forResponseHeaders: responseHeaders, title: &title, msg: &msg)
        
        return title
    }
    
    func getText(forResponseHeaders responseHeaders: Dictionary<String, String>, title: inout String, msg: inout String ) {
        
        guard let requestType = responseHeaders[AccountManager.PID_REQUEST_TYPE] else {
            return
        }
        guard let result = responseHeaders[ChopWebRequestResponse.PID_REQUEST_RESULT] else {
            return
        }
        
        switch (requestType) {
            case ChopResearchStudyRegistration.REQUEST_TYPE:
                if result == ChopWebRequestResponse.PV_SUCCESS {
                    title = "Registration successful."
                    msg = "Please verify using your provided email."
                }
                if result == ChopWebRequestResponse.PV_ACCT_FOUND {
                    title = "Registration failed."
                    msg = "An account using that email is already in the database."
                }
                break
            case ChopResearchStudyLogin.REQUEST_TYPE:
                if result == ChopWebRequestResponse.PV_SUCCESS {
                    title = "Login successful."
                    msg = "Proceeding to main menu."
                }
                if result == ChopWebRequestResponse.PV_ACCT_NOT_FOUND {
                    title = "Login failed."
                    msg = "Account not found."
                }
                if result == ChopWebRequestResponse.PV_ACCT_NOT_CONFIRMED {
                    title = "Login failed."
                    msg = "Account not confirmed."
                }
                if result == ChopWebRequestResponse.PV_PASSWORD_INCORRECT {
                    title = "Login failed."
                    msg = "Password Incorrect."
                }
                break
            default:
                title = "Error"
                msg = "Unknown Request: " + requestType
        }
    }
}


