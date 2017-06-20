//
//  ChopTappingIntervalTask.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 6/20/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

struct ChopTappingIntervalTask {

    init(timeInterval: Int) {
        
        let option = ORKPredefinedTaskOption()
        let handOption = ORKPredefinedTaskHandOption()
        
        rkTask = ORKOrderedTask.twoFingerTappingIntervalTask(withIdentifier: "TappingIntervalTask",                                                                                                    intendedUseDescription: "Intended_Use_Description",
            duration: TimeInterval(timeInterval),
            handOptions: handOption,
            options: option)

    }
    
    func createModuleViewController(delegate: ChopResearchStudy) -> UIViewController {
        
        let taskViewController = ChopRKTaskViewController(
            type: ChopResearchStudyModuleTypeEnum.TappingIntervalTask,
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
                
                if (rkStepResult.results?.count)! > 0 {
                    for resultObject in rkStepResult.results! {
                        if resultObject is ORKTappingIntervalResult {
                            
                            self.result = resultObject as? ORKTappingIntervalResult
                            // for data, see result.samples
                            break
                        }
                    }
                }
            }
        }
    }
    
    fileprivate var rkTask: ORKOrderedTask
    fileprivate var result: ORKTappingIntervalResult?
}
