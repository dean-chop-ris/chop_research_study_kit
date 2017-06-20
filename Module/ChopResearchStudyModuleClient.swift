//
//  ChopResearchStudyModuleClient.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 6/19/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation

protocol ChopResearchStudyModuleClient {
    
    func sendUserMessage(forClientWithId clientId: String, title: String, message: String)
    
}
