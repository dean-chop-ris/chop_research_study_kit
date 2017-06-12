//
//  ChopRKTaskViewController.swift
//  CHOP_RK
//
//  Created by Ritter, Dean on 1/26/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

public class ChopRKTaskViewController : ORKTaskViewController {

    var taskType: ChopResearchStudyModuleTypeEnum
    
    public init(type taskTypeIn: ChopResearchStudyModuleTypeEnum, task taskToRun: ORKTask?, taskRun taskRunUUID: UUID?) {
        self.taskType = taskTypeIn
        super.init(task: taskToRun, taskRun: taskRunUUID)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
