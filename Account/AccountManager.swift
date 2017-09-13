//
//  AccountManager.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 6/8/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

enum AccountStatus {
    case Unknown
    case NotRegistered
    case AwaitingVerification
    case Active
}

struct AccountManager {

    // Parameter ID's
    static let PID_REQUEST_TYPE = "requestType"
    static let PID_REMOTE_DATA_STORE_ID = "remote_data_store_id"
    
    /*
    var loginEmail: String
    {
        let stepId = impl?.stepIdContainingloginEmail
        let step = moduleSteps.findStep(withId: stepId!)

        if step is HoldsALoginEmail {
            let loginEmailStep = step as! HoldsALoginEmail
            
            return loginEmailStep.loginEmail
        }
        
        return ""
    }
    */
    
    var completionCallback: ModuleCompleteCallback?
    public private(set) var rkLoginTask : ChopRKTask!
    
    mutating func implement(options: ChopResearchStudyModuleOptions) -> Bool {
        
        // reset step collection
        moduleSteps = ChopModuleStepCollection()

        switch options.loginMode {
        case LoginMode.Registration:
            impl = ChopResearchStudyRegistration(
                forClient: self,
                withOptions: options)
        case LoginMode.Verification:
            impl = ChopResearchStudyVerification(withOptions: options)
        case LoginMode.Login:
            impl = ChopResearchStudyLogin(withOptions: options)
        default:
            print("ERROR: case not included: " + options.loginMode.rawValue)
            return false
        }
        
        impl?.loadSteps(into: &moduleSteps)
        
        rkLoginTask = ChopRKTask(identifier: "Login",
                                 stepsToInit: moduleSteps)
        return true
    }
    
    
    func createModuleViewController(delegate: ChopResearchStudy) -> UIViewController {
        
        return /* self.moduleVC = */ (impl?.createModuleViewController(
            delegate: delegate,
            rkTaskToRun: self.rkLoginTask))!
        
        //return self.moduleVC!
    }

    mutating func onFinish(withResult taskResult: ORKTaskResult) {
        
        moduleSteps.captureResults(withResult: taskResult)

        impl?.onFinish(withResult: taskResult)
    }

    func addUserMessage(action: inout ChopWorkflowAction) {
        impl?.addUserMessage(action: &action)
    }

    fileprivate var impl: ChopResearchStudyAccountLoginImplementation?
    fileprivate var moduleSteps = ChopModuleStepCollection()
}

extension AccountManager: ChopLoginImplementationClient {
    // MARK: ChopLoginImplementationClient

    func loginUser(with userLogin: UserLogin) -> Bool {
        
        let status = getAccountStatus()
        
        if (status == AccountStatus.AwaitingVerification) {
            
        }
        
        
        return true
    }

    func getAccountStatus() -> AccountStatus {
        return AccountStatus.AwaitingVerification
    }
}

extension AccountManager: ChopWebRequestSource {
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
            var params = ChopWebRequestParameters()
            
            //params.load(key: "requestType", value: "register_user")
            params.load(key: AccountManager.PID_REQUEST_TYPE,
                        value: (impl?.requestType)!)

            //params.load(key: "content", value: "record")
            //params.load(key: "format", value: "json")
            //params.load(key: "action", value: "import")
            //params.load(key: "type", value: "flat")
            //params.load(key: "overwriteBehavior", value: "overwrite")
            
            return params.postDictionary
        }
    }
    
    var payloadParamsDictionary: Dictionary<String, String> {
        get
        {
            //return (impl?.createPayloadParamsDictionary(fromCompletedModuleSteps: self.moduleSteps))!
            var params = ChopWebRequestParameters()
            
            params.load(moduleSteps: moduleSteps)
            
            return params.postDictionary
        }
    }
}


/*
protocol HoldsALoginEmail {
    
    var loginEmail: String { get }
}
*/







