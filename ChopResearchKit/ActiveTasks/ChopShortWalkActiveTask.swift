//
//  ChopShortWalkActiveTask.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 6/15/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

struct ChopShortWalkActiveTask {
    
    init(withClient moduleClient: ChopResearchStudyModuleClient, numberOfStepsPerLeg: Int, restDuration: Int) {
        
        self.client = moduleClient
        
        var option = ORKPredefinedTaskOption()
        
        option.insert(ORKPredefinedTaskOption.excludeAudio)
        
        rkTask = ORKOrderedTask.shortWalk(withIdentifier: "ShortWalk",
                                          intendedUseDescription: "Intended_Use_Description",
                                          numberOfStepsPerLeg: numberOfStepsPerLeg,
                                          restDuration: TimeInterval(restDuration),
                                          options: option)
        
    }
    
    func createModuleViewController(delegate: ChopResearchStudy) -> UIViewController {
        
        let taskViewController = ChopRKTaskViewController(
            type: ChopResearchStudyModuleTypeEnum.ShortWalkActiveTask,
            task: self.rkTask,
            taskRun: nil)
        
        let defaultFileManager = FileManager.default
        let documentDirectoryURL = defaultFileManager.urls(for: .documentDirectory, in: .userDomainMask)
        taskViewController.outputDirectory = documentDirectoryURL.first!
        
        taskViewController.delegate = delegate
        
        return taskViewController
    }

    mutating func onFinish(withResult taskResult: ORKTaskResult) {
        
        for stepResult in taskResult.results! {
            if stepResult is ORKStepResult {
                let rkStepResult = stepResult as! ORKStepResult
                
                var fileNumber = 1
                if (rkStepResult.results?.count)! > 0 {
                    for resultObject in rkStepResult.results! {
                        if resultObject is ORKFileResult {
                            let resultFile = resultObject as! ORKFileResult
                            var ref = ChopActiveTaskResultFileReference()
                            
                            ref.stepIdentifier = rkStepResult.identifier
                            ref.fileNumber = fileNumber
                            ref.filePath = (resultFile.fileURL?.absoluteString)!
                            
                            resultFiles += [ref]
                            
                            fileNumber += 1
                        }
                    }
                }
            }
        }
    }

    fileprivate var rkTask: ORKOrderedTask
    fileprivate var client: ChopResearchStudyModuleClient
    fileprivate var resultFiles = [ChopActiveTaskResultFileReference]()
}
