//
//  ChopWorkflowAction.swift
//  Test_AuthServer_1
//
//  Created by Ritter, Dean on 7/12/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation

enum ChopWorkflowActionTypeEnum {
    case UserMessage // Supply a user message, no workflow
    case ToStudy     // go to study
    case ToOnboarding   // go to onboarding
    case ToWithdrawal   // go to withdrawal
    case None        // do nothing
}

struct ChopWorkflowAction {
    
    var hasUserMessage: Bool {
        get { return !userMessage.isEmpty }
    }
    
    var webRequestResponse: ChopWebRequestResponse? = nil
    var userMessage: String = ""
    var userMessageTitle: String = ""
    var actionType = ChopWorkflowActionTypeEnum.None
}
