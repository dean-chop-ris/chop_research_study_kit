//
//  ChopResearchStudyModule.swift
//  CHOP_RK
//
//  Created by Ritter, Dean on 2/6/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

enum ChopWebRequestType: String {
    case Registration = "register_user"
    case Login  = "login_user"
    case Confirmation = "is_account_confirmed"
}

protocol ChopResearchStudyModule {

    var identifier: String { get }
    var errorMessage: String { get }
    var moduleCompleteCallback: ModuleCompleteCallback? { get set }
    
    mutating func setOptions(options: ChopResearchStudyModuleOptions)
    
    func createModuleViewController(delegate: ChopResearchStudy) -> UIViewController

    // New Protocol? HasSteps? ResearchKitBased?
    func shouldPresentStep(stepIdToPresent: String, givenResult result: ORKTaskResult) -> ShouldPresentResultEnum
    
    
    mutating func onFinish(withResult taskResult: ORKTaskResult)

    func createWorkflowAction(from response: ChopWebRequestResponse) -> ChopWorkflowAction
    
    func canProcess(response: ChopWebRequestResponse) -> Bool
    mutating func process(response: ChopWebRequestResponse)
    
    var loadsRedcapItems: Bool { get }
    mutating func loadRedcapItems(provider: RedcapItemsProvider)
}



extension ChopResearchStudyModule {

    var errorMessage: String { get { return "No Error" } }

    var moduleCompleteCallback: ModuleCompleteCallback? {
        get { return nil }
        set {}
    }
    
    mutating func setOptions(options: ChopResearchStudyModuleOptions) { }
    
    func createModuleViewController(delegate: ChopResearchStudy) -> UIViewController {
        return UIViewController()
    }
    
    // New Protocol? HasSteps? ResearchKitBased?
    func shouldPresentStep(stepIdToPresent: String, givenResult result: ORKTaskResult) -> ShouldPresentResultEnum {
        return ShouldPresentResultEnum.YES
    }
    
    mutating func onFinish(withResult taskResult: ORKTaskResult) { }
    
    func createWorkflowAction(from response: ChopWebRequestResponse) -> ChopWorkflowAction {
        return ChopWorkflowAction()
    }
    
    func canProcess(response: ChopWebRequestResponse) -> Bool {
         return false
    }
    
    mutating func process(response: ChopWebRequestResponse) { }
    
    var loadsRedcapItems: Bool { return false }
    mutating func loadRedcapItems(provider: RedcapItemsProvider) {}
}
