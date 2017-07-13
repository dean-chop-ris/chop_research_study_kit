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

    func addUserMessage(action: inout ChopWorkflowAction)
}
