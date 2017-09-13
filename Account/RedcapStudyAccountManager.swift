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

            let emailFromRequest = response.request?.payloadValue(paramId: "email")
            var user = ChopUser(withEmail: emailFromRequest!)
            let remoteDataStoreIdFromResponse = response.responseDataValue(
                paramId: AccountManager.PID_REMOTE_DATA_STORE_ID)
            
            user.email = emailFromRequest!
            user.remoteDataStoreId = remoteDataStoreIdFromResponse
            
            if user.commit() == false {
                print("CoreData Update Error")
            }
        }
    }
}
