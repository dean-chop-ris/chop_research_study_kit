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
    
    static let REQUEST_TYPE = "register_user"

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
            return ChopResearchStudyRegistration.REQUEST_TYPE
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

        //if client.registerUser() == false {
            // handle error
        //}
    }

    func createPayloadParamsDictionary(fromCompletedModuleSteps moduleSteps: ChopModuleStepCollection) -> Dictionary<String, String> {
        
//        let regStep = moduleSteps.findStep(withId: ChopResearchStudyRegistrationStep.SID_RegistrationStep)
//        
//        
        return Dictionary<String, String>()
    }

}

