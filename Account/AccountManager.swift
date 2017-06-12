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
    
    
    /* mutating */ func createModuleViewController(delegate: ChopResearchStudy) -> UIViewController {
        
        return /* self.moduleVC = */ (impl?.createModuleViewController(
            delegate: delegate,
            rkTaskToRun: self.rkLoginTask))!
        
        //return self.moduleVC!
    }

    mutating func onFinish(withResult taskResult: ORKTaskResult) {
        
        moduleSteps.captureResults(withResult: taskResult)

        impl?.onFinish(withResult: taskResult)
    }

    fileprivate var impl: ChopResearchStudyAccountLoginImplementation?
    fileprivate var moduleSteps = ChopModuleStepCollection()
    fileprivate var moduleVC: UIViewController? = nil
}

extension AccountManager: ChopLoginImplementationClient {
    // MARK: ChopLoginImplementationClient
    
    func registerUser() -> Bool {

        if impl?.options.loginMode != LoginMode.Registration {
            return false
        }
        
        /*
        let registrationStep = moduleSteps.findStep(withId: ChopResearchStudyRegistrationStep.SID_RegistrationStep) as! ChopResearchStudyRegistrationStep
         
            Note: Unsure of the mechanism managing registration info.
                    - a server? How to communicate with it
                    - REDCap? Probably not
         */
        
        
        
        
        return true
    }
    
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














