//
//  ChopStudyParticipationViewController.swift
//  Test_Workflow_1
//
//  Created by Ritter, Dean on 7/14/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import UIKit

class ChopStudyParticipationViewController: UITabBarController {
 

    fileprivate lazy var _study: ChopResearchStudy = {
        return ChopResearchStudy(initWorkflow: ChopDefaultWorkflow())
    }()
}

extension ChopStudyParticipationViewController: HoldsAChopStudy {
    // MARK: HoldsAChopStudy
    
    var study: ChopResearchStudy {
        get {
            return _study
        }
        
        set {
            _study = newValue
        }
    }
    
}
