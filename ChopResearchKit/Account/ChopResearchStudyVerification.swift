//
//  ChopResearchStudyVerification.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 6/5/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

struct ChopResearchStudyVerification {
    
    init(withOptions optionsInit: ChopResearchStudyModuleOptions) {
        verificationOptions = optionsInit
        
        userMessages.add(
            webRequestResponse: ChopWebRequestResponse.PV_ACCT_CONFIRMED,
            title: "Confirmation Successful",
            message: "Account Confirmed")
        userMessages.add(
            webRequestResponse: ChopWebRequestResponse.PV_ACCT_NOT_CONFIRMED,
            title: "Confirmation Failure",
            message: "Account still awaiting confirmation")
        userMessages.add(
            webRequestResponse: ChopWebRequestResponse.PV_ACCT_NOT_FOUND,
            title: "Confirmation Failure",
            message: "Account not found")
    }
    
    fileprivate var verificationOptions: ChopResearchStudyModuleOptions
    fileprivate var userMessages = ChopUserMessageCollection()
}

extension ChopResearchStudyVerification: ChopResearchStudyAccountLoginImplementation {
    // MARK: ChopResearchStudyAccountLoginImplementation

    var requestType : String { get { return ChopWebRequestType.Confirmation.rawValue } }

    var options : ChopResearchStudyModuleOptions! { get { return self.verificationOptions } }

    func loadSteps(into moduleStepContainer: inout ChopModuleStepCollection) {
        
        let verificationStep = ChopResearchStudyVerificationStep()
        
        if moduleStepContainer.add(element: verificationStep) == false {
            return
        }
    }
    
    func createModuleViewController(delegate: ChopResearchStudy, rkTaskToRun: ORKTask) -> UIViewController {
        
        let taskViewController = ChopRKTaskViewController(
            type: ChopResearchStudyModuleTypeEnum.Login,
            task: rkTaskToRun,
            taskRun: nil)
        
        taskViewController.delegate = delegate
        
        return taskViewController
    }

    mutating func onFinish(withResult taskResult: ORKTaskResult) {
        
    }
    
    func addUserMessage(action: inout ChopWorkflowAction) {
        
        let responseData = action.webRequestResponse?.data
        
        guard let result = responseData?[ChopWebRequestResponse.PID_REQUEST_RESULT] else {
            return
        }

        var title = ""
        var message = ""
        
        if userMessages.getUserText(webRequestResponse: result, title: &title, message: &message) {
            
            action.userMessageTitle = title
            action.userMessage = message
        }
    }
    
    func createPayloadParamsDictionary(fromCompletedModuleSteps moduleSteps: ChopModuleStepCollection) -> Dictionary<String, String> {
     
        return Dictionary<String, String>()
    }
}

class ChopVerificationStepViewController: ORKVerificationStepViewController {
    
    override func resendEmailButtonTapped() {
        
        // perform resend email
        
        let alert = ChopUIAlert(forViewController: self, withTitle: "Email Sent", andMessage: "Verification email has been re-sent.")
        
        alert.show()
    }
}

extension ChopResearchStudyVerification: ChopWebRequestSource {
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

