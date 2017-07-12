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
    
    var requestType : String { get { return "login_user" } }

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
