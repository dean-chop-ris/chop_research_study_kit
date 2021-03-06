//
//  ChopResearchStudyAccountLoginImplementation.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 6/5/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

protocol ChopResearchStudyAccountLoginImplementation {
    // TODO: Consider base protocol (for this and other protocol: ChopPasscodeModuleImplementation
    var options : ChopResearchStudyModuleOptions! { get }
    var requestType : String { get }
    var stepIdContainingloginEmail: String { get }

    func loadSteps(into moduleStepContainer: inout ChopModuleStepCollection)
    
    func createModuleViewController(delegate: ChopResearchStudy, rkTaskToRun: ORKTask) -> UIViewController
    
    mutating func onFinish(withResult taskResult: ORKTaskResult)

    func addUserMessage(action: inout ChopWorkflowAction)

    // TODO: TBD?
    func createPayloadParamsDictionary(fromCompletedModuleSteps moduleSteps: ChopModuleStepCollection) -> Dictionary<String, String>
    
}

extension ChopResearchStudyAccountLoginImplementation {
    
    var stepIdContainingloginEmail: String { return "None" }
    
}
