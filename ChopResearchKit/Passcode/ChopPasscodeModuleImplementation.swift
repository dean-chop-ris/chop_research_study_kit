//
//  ChopPasscodeModuleImplementation.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 6/15/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

protocol ChopPasscodeModuleImplementation {
        // TODO: Consider base protocol (for this and other protocol: ChopResearchStudyAccountLoginImplementation
    var options : ChopResearchStudyModuleOptions! { get }
    
    func loadSteps(into moduleStepContainer: inout ChopModuleStepCollection)
    
    func createModuleViewController(delegate: ChopResearchStudy, rkTaskToRun: ORKTask) -> UIViewController
    
    mutating func onFinish(withResult taskResult: ORKTaskResult)
    
}
