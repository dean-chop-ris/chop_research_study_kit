//
//  ChopResearchStudyModule.swift
//  CHOP_RK
//
//  Created by Ritter, Dean on 2/6/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

protocol ChopResearchStudyModule {
    
    var identifier: String { get }
    var errorMessage: String { get }

    mutating func setOptions(options: ChopResearchStudyModuleOptions)
    
    func createModuleViewController(delegate: ChopResearchStudy) -> UIViewController

    // New Protocol? HasSteps? ResearchKitBased?
    func shouldPresentStep(stepIdToPresent: String, givenResult result: ORKTaskResult) -> Bool
    
    
    mutating func onFinish(withResult taskResult: ORKTaskResult)

}
