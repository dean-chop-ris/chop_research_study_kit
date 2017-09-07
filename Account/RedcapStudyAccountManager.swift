//
//  RedcapStudyAccountManager.swift
//  LongitudinalStudy1
//
//  Created by Ritter, Dean on 8/31/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation

struct RedcapStudyAccountManager {
    
    
    
    func onLoginWebRequestResponseReceived(response: ChopWebRequestResponse) {
    
        if response.success {
            let requestParams = response.request?.paramsDictionary
            guard let emailFromRequest = requestParams?["email"] else {
                print("RedcapStudyAccountManager.onLoginWebRequestResponseReceived(): Unable to find param: email")
                return
            }
            
            var user = ChopUser()
            
            user.remoteDataStoreId = ""
            user.email = emailFromRequest
            
            user.commit()
        }
    }

}
