//
//  ChopResearchStudyRegistration.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 6/5/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

struct ChopResearchStudyRegistration {
    
     init(forClient clientInit: ChopLoginImplementationClient,
         withOptions options: ChopResearchStudyModuleOptions) {
        registrationOptions = options
        client = clientInit
    }
    
    fileprivate var registrationOptions: ChopResearchStudyModuleOptions
    fileprivate var client: ChopLoginImplementationClient
}

extension ChopResearchStudyRegistration: ChopResearchStudyAccountLoginImplementation {

    // MARK: ChopResearchStudyAccountLoginImplementation
    
    var requestType: String {
        get {
            return ChopWebRequestType.Registration.rawValue
        }
    }
    
    var options : ChopResearchStudyModuleOptions! { get { return self.registrationOptions } }

    func loadSteps(into moduleStepContainer: inout ChopModuleStepCollection) {
        
        let registrationStep = ChopResearchStudyRegistrationStep()
        
        if moduleStepContainer.add(element: registrationStep) == false {
            return
        }
        
        if options.includePasscode {
            
            let passcodeStep = ChopPasscodeStep()
            
            if moduleStepContainer.add(element: passcodeStep) == false {
                return
            }
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

        if result == ChopWebRequestResponse.PV_SUCCESS {
            action.userMessageTitle = "Registration successful."
            action.userMessage = "Please verify using your provided email."
        }
        if result == ChopWebRequestResponse.PV_ACCT_FOUND {
            action.userMessageTitle = "Registration failed."
            action.userMessage = "An account using that email is already in the database."
        }
    }

    func createPayloadParamsDictionary(fromCompletedModuleSteps moduleSteps: ChopModuleStepCollection) -> Dictionary<String, String> {
        
//        let regStep = moduleSteps.findStep(withId: ChopResearchStudyRegistrationStep.SID_RegistrationStep)
//        
//        
        return Dictionary<String, String>()
    }

}

