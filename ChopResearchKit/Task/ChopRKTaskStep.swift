//
//  ChopRKTaskStep.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 5/25/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

protocol ChopRKTaskStep: ChopResearchStudyModuleStep {
 
    var passcodeProtected: Bool { get set }
    
    func populateRKStepArray(stepArray: inout [ORKStep])
}

