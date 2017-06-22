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
        
        let option = ORKPredefinedTaskOption()
        
        //option.insert(ORKPredefinedTaskOption.excludeAudio)
        
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
        
        /*
        //
        // Convert json items in file to items (Objective-C)
        //
        NSArray  *gaitItems = nil;
        if (url != nil) {
            NSData  *jsonData = [NSData dataWithContentsOfURL:url];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
            gaitItems = [json objectForKey:@"items"];
        }
        return  gaitItems;
        */
        
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
                            
                            let lastPathComponent = resultFile.fileURL?.lastPathComponent

                            if (lastPathComponent?.hasPrefix("accel_walking.outbound"))! {
                                print("Found urlGaitForward: " + ref.filePath)
                            }
                            if (lastPathComponent?.hasPrefix("accel_walking.rest"))! {
                                print("Found urlPosture: " + ref.filePath)
                            }
                            
                            resultFiles += [ref]
                            
                            fileNumber += 1

                            // Process file
                            
                            // Delete file
                            // Why doesn't this work?
                            /*
                            let defaultFileManager = FileManager.default
                            do {
                                try defaultFileManager.removeItem(atPath: ref.filePath)
                            } catch let error as NSError {
                                print("Could not delete file: \(ref.filePath): \(error.debugDescription)")
                            }
                            */
                            
                            /*
                            // Clear the directory
                            do {
                                let outputDir = (taskViewController.outputDirectory?.absoluteString)!
                                let filePaths = try defaultFileManager.contentsOfDirectory(atPath: outputDir)
                                for filePath in filePaths {
                                    try defaultFileManager.removeItem(atPath: filePath)
                                }
                            } catch let error as NSError {
                                print("Could not clear folder: \(error.debugDescription)")
                            }
                            */
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
