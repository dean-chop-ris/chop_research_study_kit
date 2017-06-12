//
//  ChopLoginImplementationClient.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 6/8/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation


protocol ChopLoginImplementationClient {
    
    func registerUser() -> Bool

    func loginUser(with userLogin: UserLogin) -> Bool
}
