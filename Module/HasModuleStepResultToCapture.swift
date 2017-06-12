//
//  HasModuleStepResultToCapture.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 6/5/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

protocol HasModuleStepDataToCapture: ChopResearchStudyModuleStep {
        mutating func captureResult(fromORKTaskResult: ORKTaskResult)
}
