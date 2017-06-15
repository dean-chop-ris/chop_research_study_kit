//
//  ChopPasscodeEdit.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 6/15/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

struct ChopPasscodeEdit {
    
    
    init(withOptions options: ChopResearchStudyModuleOptions) {
        moduleOptions = options
    }

    
    fileprivate var moduleOptions: ChopResearchStudyModuleOptions
}


extension ChopPasscodeEdit: ChopPasscodeModuleImplementation {
    // MARK: ChopPasscodeModuleImplementation
    
    var options : ChopResearchStudyModuleOptions! { get { return self.moduleOptions } }
    
    func loadSteps(into moduleStepContainer: inout ChopModuleStepCollection) {
        
    }
    
    func createModuleViewController(delegate: ChopResearchStudy, rkTaskToRun: ORKTask) -> UIViewController {
        
        return UIViewController()
    }
    
    mutating func onFinish(withResult taskResult: ORKTaskResult) {
        
    }
}
