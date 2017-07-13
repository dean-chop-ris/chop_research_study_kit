//
//  ChopResearchStudyLogin.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 6/5/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

struct ChopResearchStudyLogin {
 
    init(withOptions optionsInit: ChopResearchStudyModuleOptions) {
        loginOptions = optionsInit
    }
    
    fileprivate var loginOptions: ChopResearchStudyModuleOptions

}

extension ChopResearchStudyLogin: ChopResearchStudyAccountLoginImplementation {
    // MARK: ChopResearchStudyAccountLoginImplementation
    
    var requestType : String { get { return ChopWebRequestType.Login.rawValue } }

    var options : ChopResearchStudyModuleOptions! { get { return self.loginOptions } }
     
    func loadSteps(into moduleStepContainer: inout ChopModuleStepCollection) {

        let loginStep = ChopResearchStudyLoginStep()
        
        if moduleStepContainer.add(element: loginStep) == false {
            return
        }
        
        /*
        let waitStep = ChopWaitStep(withStepID: "WaitStep",
                                    withTitle: "Please Wait!!",
                                    withText: "I'm busy.")
 
        if moduleStepContainer.add(element: waitStep) == false {
            return
        }
        */
     }
    
    func createModuleViewController(delegate: ChopResearchStudy, rkTaskToRun: ORKTask) -> UIViewController {
        
        let taskViewController = ChopLoginTaskViewController(
            type: ChopResearchStudyModuleTypeEnum.Login,
            task: rkTaskToRun,
            taskRun: nil)
        
        taskViewController.delegate = delegate
        
        return taskViewController

    }
    
    mutating func onFinish(withResult taskResult: ORKTaskResult) {
        
    }
 
    func addUserMessage(action: inout ChopWorkflowAction) {

        let responseHeaders = action.webRequestResponse?.headerFields
        
        guard let result = responseHeaders?[ChopWebRequestResponse.PID_REQUEST_RESULT] else {
            return
        }
        
        if result == ChopWebRequestResponse.PV_SUCCESS {
            action.userMessageTitle = "Login successful."
            action.userMessage = "Proceeding to main menu."
        }
        if result == ChopWebRequestResponse.PV_ACCT_NOT_FOUND {
            action.userMessageTitle = "Login failed."
            action.userMessage = "Account not found."
        }
        if result == ChopWebRequestResponse.PV_ACCT_NOT_CONFIRMED {
            action.userMessageTitle = "Login failed."
            action.userMessage = "Account not confirmed."
        }
        if result == ChopWebRequestResponse.PV_PASSWORD_INCORRECT {
            action.userMessageTitle = "Login failed."
            action.userMessage = "Password Incorrect."
        }
    }
    
    func createPayloadParamsDictionary(fromCompletedModuleSteps moduleSteps: ChopModuleStepCollection) -> Dictionary<String, String> {
        
        return Dictionary<String, String>()

    }
}

// MARK: -

class ChopLoginTaskViewController: ChopRKTaskViewController {
    
    
    public override init(type taskTypeIn: ChopResearchStudyModuleTypeEnum, task taskToRun: ORKTask?, taskRun taskRunUUID: UUID?) {

        super.init(type: taskTypeIn, task: taskToRun, taskRun: taskRunUUID)
    }
    
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ChopResearchStudyLogin: ChopWebRequestSource {
    // MARK: ChopWebRequestSource
    var destinationUrl: String
    {
        get
        {
            return "https://redcap.chop.edu/api/"
        }
    }

    var headerParamsDictionary: Dictionary<String, String> {
        get
        {
            return Dictionary<String, String>()
        }
    }
    
    var payloadParamsDictionary: Dictionary<String, String> {
        get
        {
            return Dictionary<String, String>()
        }
    }
}
